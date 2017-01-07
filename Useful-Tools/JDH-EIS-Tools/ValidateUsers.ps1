#  Version 1.0 - Jim Herrmann - 2-JAN-2017

param (
	[string]$server = "usa0300nadc008.na.xerox.net",
	[Parameter(Mandatory=$true)][string]$filename
	)
	
$users = get-content $filename #import-csv $filename -Header "sAMAccountName","company","employeeType","employeeNumber","domain"
[int]$a = 0
[int]$NACount = 0
[int]$EUCount = 0
[int]$pct = 0
$NAUsers = @()
$EUUsers = @()
cls

foreach ($user in $users) {
	$a++
	$pct = $a / $users.count * 100
	Write-Progress "Validating user list... " -PercentComplete $pct -CurrentOperation "$pct% Complete" -Status " Please wait."
	$uidlook = ""
	$uid = ""
	$uid = $user

		$uidlook = get-aduser -filter "(sAMAccountName -eq '$uid')" -properties sAMAccountName,mail,userAccountControl,distinguishedName -server usa0300nadc008.na.xerox.net
		If ($uidlook.sAMAccountName -eq $uid) {
			$NAUsers = $NAUsers + $uidlook.sAMAccountName
			$outline = $uidlook.sAMAccountName+';'+$uidlook.mail+';'+$uidlook.userAccountControl+';'+$uidlook.DistinguishedName
			Write-Output $outline | Out-File -Append -FilePath "c:\temp\spinco\XTinACS_NAUsers.txt"
		}
		Else {
			$uidlook = get-aduser -filter "(sAMAccountName -eq '$uid')" -properties sAMAccountName,mail,userAccountControl,distinguishedName -server usa0300eudc005.eu.xerox.net
			If ($uidlook.sAMAccountName -eq $uid) {
				$EUUsers = $EUUsers + $uidlook
				$outline = $uidlook.sAMAccountName + ";" + $uidlook.mail + ";" + $uidlook.userAccountControl + ";" + $uidlook.DistinguishedName
				Write-Output $outline | Out-File -Append -FilePath "c:\temp\spinco\XTinACS_EUUsers.txt"
			}
			Else {
			#User not found in AD
			Write-Output "User $uid not found in AD" | out-file -append -filepath "c:\temp\spinco\failure.log"
			}
		}

}
	$ValidCount = $NAUsers.count + $EUUsers.count
	Write-Output "$ValidCount valid users found."

