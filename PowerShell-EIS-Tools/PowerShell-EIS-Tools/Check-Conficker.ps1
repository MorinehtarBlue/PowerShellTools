#
# Check_Conficker.ps1
#
$PWD = "c:\temp"
$nl = "`r"  #Escape character for line break
$log = "Security"
$eventID = 4768
$count = $args[0]
#$date = $args[1]


Write-Host "******************************************"
Write-Host "*** GETTING LIST OF DOMAIN CONTROLLERS ***"
Write-Host "******************************************"

#Get list of DC's in each domain
 $dcList = New-Object System.Collections.ArrayList

#XRXNA DOMAIN
 $root=[ADSI]"LDAP://ldap-server.na.xerox.net/OU=Domain Controllers,DC=na,DC=xerox,DC=net"
 $search=[System.DirectoryServices.DirectorySearcher]$root
 $Search.Filter="(&(objectCategory=Computer)(name=*))"
 $results=$Search.FindAll()
 Foreach($result in $results)
 {
 	$dcName = $result.properties.item('dNSHostName')
 	$dcCount = $dcList.Add($dcName)
 }
#XRXEU DOMAIN
 $root=[ADSI]"LDAP://ldap-server.eu.xerox.net/OU=Domain Controllers,DC=eu,DC=xerox,DC=net"
 $search=[System.DirectoryServices.DirectorySearcher]$root
 $Search.Filter="(&(objectCategory=Computer)(name=*))"
 $results=$Search.FindAll()
 Foreach($result in $results)
 {
 	$dcName = $result.properties.item('dNSHostName')
 	$dcCount = $dcList.Add($dcName)
 }
#XRXSA DOMAIN
 $root=[ADSI]"LDAP://ldap-server.sa.xerox.net/OU=Domain Controllers,DC=sa,DC=xerox,DC=net"
 $search=[System.DirectoryServices.DirectorySearcher]$root
 $Search.Filter="(&(objectCategory=Computer)(name=*))"
 $results=$Search.FindAll()
 Foreach($result in $results)
 {
 	$dcName = $result.properties.item('dNSHostName')
 	$dcCount = $dcList.Add($dcName)
 }
#XRXROOT DOMAIN
 $root=[ADSI]"LDAP://ldaps.xerox.net/OU=Domain Controllers,DC=xerox,DC=net"
 $search=[System.DirectoryServices.DirectorySearcher]$root
 $Search.Filter="(&(objectCategory=Computer)(name=*))"
 $results=$Search.FindAll()
 Foreach($result in $results)
 {
 	$dcName = $result.properties.item('dNSHostName')
 	$dcCount = $dcList.Add($dcName)
 }
 Write-Host $dcList.Count "DC's Found."

#Write Header to File
 Write-Output "Servername`tDate/Time`tDetails`tUsername`tClientIP`tPortNumber"

ForEach ($dc in $dcList) {

Write-Host "Connecting to $dc"
#$dslog = New-Object System.Diagnostics.EventLog($log, $dc)
#$dslog.get_entries() | Where-Object {($_.EventID -eq $eventID) -and ($_.TimeGenerated -gt '6/15/2009')}
#$logs = [System.Diagnostics.EventLog]::GetEventLogs($dc)
#$Seclog = $logs|? {$_.log -eq $log}
#$logCount = $Seclog.Entries.Count
#Write-Host "System Event Log has $logCount Entries"
#If ($Seclog.Entries.Count -gt $count) {
#$SecEntries = $Seclog.Entries[($logCount - $count)..($logCount - 1)] | Where {($_.EventID -eq $eventID) -and ($_.TimeGenerated -gt $date)}
$SecEntries = Get-EventLog -Newest $count Security -ComputerName $dc | Where {$_.EventID -eq 4768}
	If ($SecEntries.Count -ge 1) {
		Write-Host $SecEntries.Count "Entries Found on $dc"
		ForEach ($SecEntry in $SecEntries) {
			$timeStamp = $SecEntry.TimeGenerated
			$entryInfo = $SecEntry.Message
			$targetAcct = $SecEntry.TargetUserName
			$IpAddress = $SecEntry.IpAddress
			$IpPort = $SecEntry.IpPort
			$outLine = "$dc`t$timeStamp`t$entryInfo`t$targetAcct`t$IpAddress`t$IpPort"
			Write-Output $outLine
			}
	}
	$SecEntries = $Seclog.Close
}