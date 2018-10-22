$file = Read-Host -prompt "Drop List File"
$nodes = Get-Content $file
$prog = 0
"`n`n`n`n`n`n`n`n"
$tmpf = New-TemporaryFile
"Computer	PingStatus" | Out-File $tmpf -Append
Write-Progress -Activity "Checking Hosts" -PercentComplete 0
foreach($ip in $nodes){
	$perc = $prog/$nodes.count*100
	Write-Progress -Activity "Checking Hosts" -CurrentOperation "Host: $ip" -Status "$perc%" -PercentComplete $perc
	$ping = Get-WmiObject Win32_PingStatus -filter "Address='$ip'" 
	if($ping.StatusCode -eq 0){"$ip        [ONLINE]"; "$ip	OK" | Out-File $tmpf -Append} 
	else{"$ip       [OFFLINE]"; "$ip	Down" | Out-File $tmpf -Append}
	$prog = $prog + 1
}
Write-Progress -Activity "Checking Hosts" -Completed -PercentComplete ($prog/$nodes.count*100)

Rename-Item $tmpf.FullName $tmpf.Name.Replace(".tmp",".csv")
Invoke-Item $tmpf.FullName.Replace(".tmp",".csv")