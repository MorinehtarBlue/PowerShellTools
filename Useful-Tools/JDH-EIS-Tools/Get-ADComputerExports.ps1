#
# Get_ADComputerExports.ps1
# Computer object export for XT domains to support SAM office initiatives
# Date Codes for LastLogonTimestamp:
#	7/1/2016	131118048000000000
#	8/1/2016	131144832000000000
#	9/1/2016	131171616000000000
#	10/1/2016	131197536000000000
#	11/1/2016	131224320000000000
#	12/1/2016	131250240000000000
#

$now = Get-Date

#XRXROOT
$DomainName = "xerox.net"
$Domain = Get-ADDomain $DomainName
$PDC = $Domain.PDCEmulator 
Get-ADComputer -Server $PDC -Properties cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl -LdapFilter "(&(pwdLastSet>=131143565000000000)(operatingSystem=Windows*Server*))" | select cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl | Export-Csv -NoTypeInformation -Path "P:\SAM\$DomainName.csv" -Encoding Unicode 

#XRXEU
$DomainName = "eu.xerox.net"
$Domain = Get-ADDomain $DomainName
$PDC = $Domain.PDCEmulator 
Get-ADComputer -Server $PDC -Properties cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl -LdapFilter "(&(pwdLastSet>=131143565000000000)(operatingSystem=Windows*Server*))" | select cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl | Export-Csv -NoTypeInformation -Path "P:\SAM\$DomainName.csv" -Encoding Unicode 

#XRXNA
$DomainName = "na.xerox.net"
$Domain = Get-ADDomain $DomainName
$PDC = $Domain.PDCEmulator 
Get-ADComputer -Server $PDC -Properties cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl -LdapFilter "(&(pwdLastSet>=131143565000000000)(operatingSystem=Windows*Server*))" | select cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl | Export-Csv -NoTypeInformation -Path "P:\SAM\$DomainName.csv" -Encoding Unicode 

#XRXSA
$DomainName = "sa.xerox.net"
$Domain = Get-ADDomain $DomainName
$PDC = $Domain.PDCEmulator 
Get-ADComputer -Server $PDC -Properties cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl -LdapFilter "(&(pwdLastSet>=131143565000000000)(operatingSystem=Windows*Server*))" | select cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl | Export-Csv -NoTypeInformation -Path "P:\SAM\$DomainName.csv" -Encoding Unicode 

$userCred = get-credential -Message "XDE User Logon"
#XDEROOT
$DomainName = "xerox.org"
$Domain = Get-ADDomain $DomainName -Credential $userCred
$PDC = $Domain.PDCEmulator 
Get-ADComputer -Server $PDC -Properties cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl -LdapFilter "(&(pwdLastSet>=131143565000000000)(operatingSystem=Windows*Server*))" -Credential $userCred | select cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl | Export-Csv -NoTypeInformation -Path "P:\SAM\$DomainName.csv" -Encoding Unicode 

#XDEEU
$DomainName = "eu.xerox.org"
$Domain = Get-ADDomain $DomainName
$PDC = $Domain.PDCEmulator 
Get-ADComputer -Server $PDC -Properties cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl -LdapFilter "(&(pwdLastSet>=131143565000000000)(operatingSystem=Windows*Server*))" -Credential $userCred | select cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl | Export-Csv -NoTypeInformation -Path "P:\SAM\$DomainName.csv" -Encoding Unicode 

#XDENA
$DomainName = "na.xerox.org"
$Domain = Get-ADDomain $DomainName
$PDC = $Domain.PDCEmulator 
Get-ADComputer -Server $PDC -Properties cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl -LdapFilter "(&(pwdLastSet>=131143565000000000)(operatingSystem=Windows*Server*))" -Credential $userCred | select cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl | Export-Csv -NoTypeInformation -Path "P:\SAM\$DomainName.csv" -Encoding Unicode 

#XDESA
$DomainName = "sa.xerox.org"
$Domain = Get-ADDomain $DomainName
$PDC = $Domain.PDCEmulator 
Get-ADComputer -Server $PDC -Properties cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl -LdapFilter "(&(pwdLastSet>=131143565000000000)(operatingSystem=Windows*Server*))" -Credential $userCred | select cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl | Export-Csv -NoTypeInformation -Path "P:\SAM\$DomainName.csv" -Encoding Unicode 

#XDE3ROOT
#$DomainName = "xde3.xerox.org"
#$Domain = Get-ADDomain $DomainName
#$PDC = $Domain.PDCEmulator 
#Get-ADComputer -Server $PDC -Properties cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl -LdapFilter "(&(pwdLastSet>=131143565000000000)(operatingSystem=Windows*Server*))" | select cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl | Export-Csv -NoTypeInformation -Path "P:\SAM\$DomainName.csv" -Encoding Unicode 

#XDE3EU
$DomainName = "eu.xde3.xerox.org"
$Domain = Get-ADDomain $DomainName
$PDC = $Domain.PDCEmulator 
Get-ADComputer -Server $PDC -Properties cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl -LdapFilter "(&(pwdLastSet>=131143565000000000)(operatingSystem=Windows*Server*))" | select cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl | Export-Csv -NoTypeInformation -Path "P:\SAM\$DomainName.csv" -Encoding Unicode 

#XDE3NA
$DomainName = "na.xde3.xerox.org"
$Domain = Get-ADDomain $DomainName
$PDC = $Domain.PDCEmulator 
Get-ADComputer -Server $PDC -Properties cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl -LdapFilter "(&(pwdLastSet>=131143565000000000)(operatingSystem=Windows*Server*))" | select cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl | Export-Csv -NoTypeInformation -Path "P:\SAM\$DomainName.csv" -Encoding Unicode 

#SDI
$DomainName = "sdi.na.xde3.xerox.org"
$Domain = Get-ADDomain $DomainName
$PDC = $Domain.PDCEmulator 
Get-ADComputer -Server $PDC -Properties cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl -LdapFilter "(&(pwdLastSet>=131143565000000000)(operatingSystem=Windows*Server*))" | select cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl | Export-Csv -NoTypeInformation -Path "P:\SAM\$DomainName.csv" -Encoding Unicode 

#XRCC
$DomainName = "xrcc.xeroxlabs.com"
$Domain = Get-ADDomain $DomainName
$PDC = $Domain.PDCEmulator 
Get-ADComputer -Server $PDC -Properties cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl -LdapFilter "(&(pwdLastSet>=131143565000000000)(operatingSystem=Windows*Server*))" | select cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl | Export-Csv -NoTypeInformation -Path "P:\SAM\$DomainName.csv" -Encoding Unicode 

#XRCE
$DomainName = "xrce.xeroxlabs.com"
$Domain = Get-ADDomain $DomainName
$PDC = $Domain.PDCEmulator 
Get-ADComputer -Server $PDC -Properties cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl -LdapFilter "(&(pwdLastSet>=131143565000000000)(operatingSystem=Windows*Server*))" | select cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl | Export-Csv -NoTypeInformation -Path "P:\SAM\$DomainName.csv" -Encoding Unicode 

#WCRT
$DomainName = "wcrt.xeroxlabs.com"
$Domain = Get-ADDomain $DomainName
$PDC = $Domain.PDCEmulator 
Get-ADComputer -Server $PDC -Properties cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl -LdapFilter "(&(pwdLastSet>=131143565000000000)(operatingSystem=Windows*Server*))" | select cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl | Export-Csv -NoTypeInformation -Path "P:\SAM\$DomainName.csv" -Encoding Unicode 

#Make Zip File
Compress-Archive -Path P:\SAM\*.csv -DestinationPath P:\SAM\XTDomains.zip

#Mail the Zip file
Send-MailMessage -To james.herrmann@xerox.com -From XeroxAuthenticationServices@xerox.com -Subject "XT Domain Exports - $now" -Body "Please see the attached reports generated $now." -SmtpServer forwarder.mail.xerox.com -Attachments p:\sam\XTDomains.zip

#Get-ADComputer -Server $PDC -Properties cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl -LdapFilter "(&(pwdLastSet>=131143565000000000)(operatingSystem=*Server*))" | select cn,sAMAccountName,pwdLastSet,lastLogonTimestamp,dNSHostName,operatingSystem,operatingSystemServicePack,operatingSystemVersion,userAccountControl | Export-Csv -NoTypeInformation -Path "P:\SAM\$DomainName.csv" -Encoding Unicode 
