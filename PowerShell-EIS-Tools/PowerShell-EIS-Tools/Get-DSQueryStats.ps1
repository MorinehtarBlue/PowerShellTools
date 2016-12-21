#
# Get_DSQueryStats.ps1
#
$PWD = "c:\temp"
$nl = "`r"  #Escape character for line break
$log = "Directory Service"
$eventID = 1643
$count = $args[0]
$date = $args[1]


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
 Write-Output "Servername`tDate/Time`tInterval`tNumSearches`tNumExpensive`tNumInefficient"

ForEach ($dc in $dcList) {

Write-Host "Connecting to $dc"
#$dslog = New-Object System.Diagnostics.EventLog($log, $dc)
#$dslog.get_entries() | Where-Object {($_.EventID -eq $eventID) -and ($_.TimeGenerated -gt '6/15/2009')}
$logs = [System.Diagnostics.EventLog]::GetEventLogs($dc)
$dslog = $logs |? {$_.log -eq $log}
$dsEntries = $dslog.Entries[($dslog.Entries.Count -1)..($dslog.Entries.Count -$count)] | Where {($_.EventID -eq $eventID) -and ($_.TimeGenerated -ge $date)}

If ($dsEntries.Count -ge 1) {
	Write-Host $dsEntries.Count "Entries Found on $dc"
	ForEach ($dsEntry in $dsEntries) {
		$timeStamp = $dsEntry.TimeGenerated
		$entryInfo = $dsEntry.Message
		$arEntryInfo = $entryInfo.Split($nl)
		$interval = $arEntryInfo[5]
		$interval = $interval.Remove(0, 1)
		$numSearches = $arEntryInfo[8]
		$numSearches = $numSearches.Remove(0, 1)
		$numExpensive = $arEntryInfo[17]
		$numExpensive = $numExpensive.Remove(0, 1)
		$numInefficient = $arEntryInfo[20]
		$numInefficient = $numInefficient.Remove(0, 1)
		$outLine = "$dc`t$timeStamp`t$interval`t$numSearches`t$numExpensive`t$numInefficient"
		Write-Output $outLine
		}
	}
}