function GetAddress($m, $f) {
    $sA = [System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object {$_.GlobalAssemblyCache -and $_.Location.Split('\\')[-1] -eq 'Sy' + 'ste' + 'm.dll'}

    $uNM = ForEach ($t in $sA.GetTypes()) {
        $t | Where-Object {$_.FullName -like '*Nati' + 'veM' + 'ethods' -and $_.Fullname -like '*Win32*' -and $_.Fullname -like '*Un*'}
    }

    $mH = $uNM.GetMethods() | Where-Object {$_.Name -like '*Handle' -and $_.Name -like '*Module*'} | Select-Object -First 1
    $pA = $uNM.GetMethod('GetProcAdd' + 'ress', [type[]]('Int' + 'Ptr', 'Sy' + 'stem.S' + 'tring'))

    $mH.Invoke($null, @($m))
    $pA.Invoke($null, @($m, $f))
}
