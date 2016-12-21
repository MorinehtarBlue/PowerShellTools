#
# Get_UndefinedSubnets.ps1
#
#$PWD = "d:\WorkingMaterials\ENDS\SubnetInfo"

$NumLines = 50		#number of lines to tail from Netlogon.log file
$NumDays = 7		#Number of days to tail from Netlogon.log file


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
 
 
 
 $subnetList = New-Object System.Collections.ArrayList
 Write-Output "DomainController,Subnet"
 Foreach($dc in $dcList)
 {
 	#Write-Host $dc "Collecting NetLogon Log Data..."
	$colOperatingSystems = get-wmiobject -Class Win32_OperatingSystem -Namespace root\CIMV2 -ComputerName $dc
	ForEach($objOperatingSystem In $colOperatingSystems)
	{
			$SystemDir = $objOperatingSystem.SystemDirectory
	}
	if ($SystemDir -ne "")
	{
	$strDir = [String]::$SystemDir.ToLower
	$SystemDir = $SystemDir.Replace("\system32","")
	$OSPath = $SystemDir.SubString(2)
	$NLPath = "\\"+$dc+"\c$"+$OSPath+"\debug\netlogon.log"
	Write-Host "NetLogon Log Path:" $NLPath
	$tailOut = &$PWD\tail.exe -$numLines $NLPath
	Foreach($tLine in $tailOut)
	{
		if ($tLine.Contains("NO_CLIENT_SITE"))
		{
			$arTLine = $tLine.Split(" ")
			$ipAddr = $arTLine[$arTLine.Count -1]
			if ($ipAddr.StartsWith("13"))
			{
				$subnet = $ipAddr.SubString(0, $ipAddr.LastIndexOf("."))
				if ($subnetList.Contains($subnet))
				{
				#Subnet already in list
				}
				else
				{
				#Add subnet to list 
				$subnetCount = $subnetList.Add($subnet)
				Write-Output $dc','$subnet
				}
			}
		}
	}
	}
 }
 Write-Host $subnetList.Count "Undefined Subnets Found."