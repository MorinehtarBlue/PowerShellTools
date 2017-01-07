#
# Get_LockEvents.ps1
#
param (
	[string]$server = "usa7109nadc002.na.xerox.net",
	[Parameter(Mandatory=$true)][string]$user
	)
$filename = "c:\temp\" + $user + "_LockEvts.csv"

# Get Credentials
$cred = get-credential
# Set log span to reduce load
$span = (Get-Date) - (New-TimeSpan -Minutes 30)
# Pull list from selected DC
Get-WinEvent -FilterHashtable @{Logname='Security';StartTime=$span} -ComputerName $server -Credential $cred | Where-Object {$_.Message -like '*$user*'} | Select-Object TimeCreated,MachineName,Id,Message | Export-Csv -Path $filename
