#  Version 1.1 - Jim Herrmann - 19-DEC-2016

param (
	[string]$server = "usa0300nadc008.na.xerox.net",
	[Parameter(Mandatory=$true)][string]$grpName,
	[Parameter(Mandatory=$true)][string]$filename
	)
	
$users = import-csv $filename -Header "sAMAccountName","company","employeeType","employeeNumber","domain"
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
	$uid = $user.sAMAccountName

	Try {
		$uidlook = get-aduser -filter "(sAMAccountName -eq '$uid')" -server usa0300nadc008.na.xerox.net
		If ($uidlook.sAMAccountName -eq $uid) {
			$NAUsers = $NAUsers + $uidlook.sAMAccountName
		}
		Else {
			$uidlook = get-aduser -filter "(sAMAccountName -eq '$uid')" -server usa0300eudc005.eu.xerox.net
			If ($uidlook.sAMAccountName -eq $uid) {
				$EUUsers = $EUUsers + $uidlook
			}
			Else {
			#User not found in AD
			Write-Output "User $uid not found in AD" | out-file -append -filepath ".\failure.log"
			}
		}
	}
	catch [System.UnauthorizedAccessException]
		{
		Write-Output "Access Denied - $uid" | out-file -append -filepath ".\failure.log"
		}
	catch [system.exception]
		{
		Write-Output "System Error - $uid" | out-file -append -filepath ".\failure.log"
		#Write-Output $error | out-file -append -filepath ".\logs\failure.log"
		}
}
	$ValidCount = $NAUsers.count + $EUUsers.count
	Write-Output "$ValidCount valid users found."

#Process EU Users
$a = 0
$group = get-adgroup $grpName
foreach ($EUUser in $EUUsers) {
	$a++
	#$mbrBlock = "'" + $User + "'," + $mbrBlock
	$do = add-adgroupmember -identity $group -members $EUUser

	If (($a % 2500) -eq 0)
    {
		#$do = add-adgroupmember -identity $group -members $mbrBlock
        Write-Progress -Status "$a Users Processed... " -Activity 'Sleeping 30 seconds'
        Start-Sleep -Seconds 900 #900 = 15 minutes
		#$mbrBlock = ""
    }

}

#Procee NA Users
$a = 0
$mbrBlock = @()
foreach ($NAUser in $NAUsers) {
	$a++
	$mbrBlock = $mbrBlock + $NAUser
	#$do = add-adgroupmember -identity $group -members $user

	If (($a % 2500) -eq 0)
    {
		$do = add-adgroupmember -identity $group -members $mbrBlock
        Write-Progress -Status "$a Users Processed... " -Activity 'Sleeping 30 seconds'
        Start-Sleep -Seconds 900 #900 = 15 minutes
		$mbrBlock = @()
    }
}
#Last write of partial block group
If ($mbrBlock.count -ne 0) {
	$do = add-adgroupmember -identity $group -members $mbrBlock
	}
Write-Progress -Status "$a Users Processed. " -Activity 'Job Complete'
Start-Sleep -Seconds 10 #900 = 15 minutes
