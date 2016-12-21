#
# Get_DCPatchLevels.ps1
#
#$PWD = "d:\WorkingMaterials\ENDS\SubnetInfo"

Write-Host "******************************************"
Write-Host "*** GETTING LIST OF DOMAIN CONTROLLERS ***"
Write-Host "******************************************"

#Get list of DC's in each domain
 $dcList = New-Object System.Collections.ArrayList

#XRXNA DOMAIN
 $root=[ADSI]"LDAP://ldapsna.idns.xerox.com/OU=Domain Controllers,DC=na,DC=xerox,DC=net"
 $search=[System.DirectoryServices.DirectorySearcher]$root
 $Search.Filter="(&(objectCategory=Computer)(name=*))"
 $results=$Search.FindAll()
 Foreach($result in $results)
 {
 	$dcName = $result.properties.item('dNSHostName')
 	$dcCount = $dcList.Add($dcName)
 }
#XRXEU DOMAIN
 $root=[ADSI]"LDAP://ldapseu.idns.xerox.com/OU=Domain Controllers,DC=eu,DC=xerox,DC=net"
 $search=[System.DirectoryServices.DirectorySearcher]$root
 $Search.Filter="(&(objectCategory=Computer)(name=*))"
 $results=$Search.FindAll()
 Foreach($result in $results)
 {
 	$dcName = $result.properties.item('dNSHostName')
 	$dcCount = $dcList.Add($dcName)
 }
#XRXSA DOMAIN
# $root=[ADSI]"LDAP://ldap-server.sa.xerox.net/OU=Domain Controllers,DC=sa,DC=xerox,DC=net"
# $search=[System.DirectoryServices.DirectorySearcher]$root
# $Search.Filter="(&(objectCategory=Computer)(name=*))"
# $results=$Search.FindAll()
# Foreach($result in $results)
# {
# 	$dcName = $result.properties.item('dNSHostName')
# 	$dcCount = $dcList.Add($dcName)
# }
#XRXROOT DOMAIN
 $root=[ADSI]"LDAP://ldaps.idns.xerox.com/OU=Domain Controllers,DC=xerox,DC=net"
 $search=[System.DirectoryServices.DirectorySearcher]$root
 $Search.Filter="(&(objectCategory=Computer)(name=*))"
 $results=$Search.FindAll()
 Foreach($result in $results)
 {
 	$dcName = $result.properties.item('dNSHostName')
 	$dcCount = $dcList.Add($dcName)
 }
 Write-Host $dcList.Count "DC's Found."
 
 
 
 #$subnetList = New-Object System.Collections.ArrayList
 Write-Output "Domain Controller,ISR Level,WSU Level"#,FW Level"
 Foreach($dc in $dcList)
 {
	$iSR = 0
	$wSU = 0
	$reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $dc)
	$regKey = $reg.OpenSubKey("SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\IsrSlot")
#	$regKey.GetValueNames()
	Write-Host $dc
	If ($regKey -ne "") {
		$iSR = $regKey.GetValue("ISRVer")
		$wSU = $regKey.GetValue("PatchLevel")
#		$fWR = $regKey.GetValue("FWVer")
		Write-Output $dc','$iSR','$wSU
		#','$fWR
 	}
 }
