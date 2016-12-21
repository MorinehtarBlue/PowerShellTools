#
# Get_ADStaleUsers.ps1
#
Write-Output "surname;givenName;displayName;samAccountName;description;email;ipPhone;telephone;info;c;co;whenCreated;lastLogonTimestamp;daysSinceLogon;UserCN;userAccountControl;status;dsPath"

 $rootPath="LDAP://"+$args[0]
 $numDays=$args[1]
 $root=[ADSI]$rootPath
 $search=[System.DirectoryServices.DirectorySearcher]$root
 $search.Filter="(&(objectCategory=user)(objectClass=person))"
 $search.PageSize=100
 $search.SearchScope=$args[2]
 $results=$search.FindAll()
 $today = Get-Date
 $nl = "`r`n"  #Escape character for line break

 Foreach($result in $results)
 {
  $sn = $result.Properties.Item('sn')[0]
  $givenName = $result.Properties.Item('givenName')[0]
  $dispName = $result.Properties.Item('displayName')[0]
  $samAcctName = $result.Properties.Item('samAccountName')[0]
  $email = $result.Properties.Item('mail')[0]
  $desc = $result.Properties.Item('description')[0]
  $status = $result.Properties.Item('status')[0]
  $ipPhone = $result.Properties.Item('ipPhone')[0]
  $tele = $result.Properties.Item('telephoneNumber')[0]
  $info = $result.Properties.Item('info')[0]
  $c = $result.Properties.Item('c')[0]
  $co = $result.Properties.Item('co')[0]
  $cn = $result.Properties.Item('cn')[0]
  $dsPath = $result.Path
  $dsPath = $dsPath.Remove(0, 7)
  $created = $result.Properties.Item('whenCreated')[0]
  [TimeSpan]$acctAge = New-TimeSpan $created $today
  $lastLogonTimestamp = [datetime]::FromFileTime($result.properties.item('lastLogonTimestamp')[0])
  [TimeSpan]$staleDuration = New-TimeSpan $lastLogonTimestamp $today
  $daysOld = $staleDuration.Days
  $uAC = $result.Properties.Item('userAccountControl')[0]
	switch ($uAC) 
	{ 
	{($uAC -bor 0x0002) -eq $uAC} {$status = "Disabled "} # ; $flags += "ACCOUNTDISABLE"} 
	{($uAC -bor 0x0008) -eq $uAC} {$status = "HomeDirReq "+$status} # ; $flags += "HOMEDIR_REQUIRED"} 
	{($uAC -bor 0x0010) -eq $uAC} {$status = "Locked "+$status} # ; $flags += "LOCKOUT"} 
	{($uAC -bor 0x0020) -eq $uAC} {$status = "NoPasswd "+$status} # ; $flags += "PASSWD_NOTREQD"} 
	{($uAC -bor 0x0040) -eq $uAC} {$status = "PasswdCannotChange "+$status} # ; $flags += "PASSWD_CANT_CHANGE"} 
	{($uAC -bor 0x0080) -eq $uAC} {$status = "EncryptPasswd "+$status} # ; $flags += "ENCRYPTED_TEXT_PWD_ALLOWED"} 
	{($uAC -bor 0x0100) -eq $uAC} {$status = "TempDupAcct "+$status} # ; $flags += "TEMP_DUPLICATE_ACCOUNT"} 
	{($uAC -bor 0x0200) -eq $uAC} {$status = "NormalUser "+$status} # ; $flags += "NORMAL_ACCOUNT"} 
	{($uAC -bor 0x0800) -eq $uAC} {$status = "DomainTrustAcct "+$status} # ; $flags += "INTERDOMAIN_TRUST_ACCOUNT"} 
	{($uAC -bor 0x1000) -eq $uAC} {$status = "WorkstationAcct "+$status} # ; $flags += "WORKSTATION_TRUST_ACCOUNT"} 
	{($uAC -bor 0x2000) -eq $uAC} {$status = "ServerAcct "+$status} # ; $flags += "SERVER_TRUST_ACCOUNT"}
	{($uAC -bor 0x10000) -eq $uAC} {$status = "NonExpirePasswd "+$status} # ; $flags += "DONT_EXPIRE_PASSWORD"} 
	{($uAC -bor 0x20000) -eq $uAC} {$status = "MNSLogonAcct "+$status} # ; $flags += "MNS_LOGON_ACCOUNT"} 
	{($uAC -bor 0x40000) -eq $uAC} {$status = "SmartCardReq "+$status} # ; $flags += "SMARTCARD_REQUIRED"} 
	{($uAC -bor 0x80000) -eq $uAC} {$status = "TrustForDelegation "+$status} # ; $flags += "TRUSTED_FOR_DELEGATION"} 
	{($uAC -bor 0x100000) -eq $uAC} {$status = "NotDelegated "+$status} # ; $flags += "NOT_DELEGATED"} 
	{($uAC -bor 0x200000) -eq $uAC} {$status = "DES_KeyOnly "+$status} # ; $flags += "USE_DES_KEY_ONLY"} 
	{($uAC -bor 0x400000) -eq $uAC} {$status = "NoReqPreAuth "+$status} # ; $flags += "DONT_REQ_PREAUTH"} 
	{($uAC -bor 0x800000) -eq $uAC} {$status = "PasswdExpired "+$status} # ; $flags += "PASSWORD_EXPIRED"} 
	{($uAC -bor 0x1000000) -eq $uAC} {$status = "TrustedAuthDelegation "+$status} # ; $flags += "TRUSTED_TO_AUTH_FOR_DELEGATION"} 
	} 

	#check teleNotes for line feeds and semicolons
	If($info.length -gt 0)
	{
		If($info.Contains($nl))
		{
			$arInfo = $info.split($nl)
			$teleNotes = $arInfo | ForEach-Object {$fullstring = ""} {$fullstring += $_} {$fullstring}
		}
		Else
		{
			$teleNotes = $info
		}
		If($teleNotes.Contains(";"))
		{
			$arInfo = $teleNotes.Split(";")
			$teleNotes = $arInfo | ForEach-Object {$fullstring = ""} {$fullstring += $_} {$fullstring}
		}
	}
	Else
	{
		$teleNotes = ""
	}
	
	#Remove semicolons from telephone number if they exist
	If($tele.length -gt 0)
	{
				If($tele.Contains(";"))
		{
			$arTele = $tele.Split(";")
			$tele = $arTele | ForEach-Object {$fullstring = ""} {$fullstring += $_} {$fullstring}
		}
	}
	Else
	{
		$tele = ""
	}

	#check description for line feeds and semicolons
	If($desc.length -gt 0)
	{
		If($desc.Contains($nl))
		{
			$arDesc = $desc.split($nl)
			$desc = $arDesc | ForEach-Object {$fullstring = ""} {$fullstring += $_} {$fullstring}
		}
		If($desc.Contains(";"))
		{
			$arDesc = $desc.Split(";")
			$desc = $arDesc | ForEach-Object {$fullstring = ""} {$fullstring += $_} {$fullstring}
		}
	}
	Else
	{
		$desc = ""
	}


  #check for last logon to be more than specified number of days ago and account was created more than 6 months ago
  If($daysOld -gt $numDays)
  {
  	If($acctAge.Days -gt 180)
	{
	  	#Write-Host "$name,$lastLogonTimestamp,$daysOld,$adsPath"
  		Write-Output "$sn;$givenName;$dispName;$samAcctName;$desc;$email;$ipPhone;$tele;'$teleNotes';$c;$co;$created;$lastLogonTimestamp;$daysOld;$cn;$uAC;$status;$dsPath"
		$x++
	}
  }
 } #end foreach
Write-Host "$x Users not authenticated in $numDays days."
