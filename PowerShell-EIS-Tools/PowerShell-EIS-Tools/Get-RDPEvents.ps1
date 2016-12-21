#
# Get_RDPEvents.ps1
#
# Get Credentials
$userNA = get-credential
$userEU = get-credential
#$userXDE = get-credential
$lastWeek = (Get-Date) - (New-TimeSpan -Day 7)
# AutoNS
Get-WinEvent -FilterHashtable @{Logname="Microsoft-Windows-TerminalServices-LocalSessionManager/Operational";ID=21;StartTime=$lastWeek} -ComputerName usa0300vm0100.na.xerox.net -Credential $userNA | Select-Object TimeCreated,MachineName,Id,Message | Export-Csv -Path USA0300VM0100_RDPEvt.csv
#Get-WinEvent -FilterHashtable @{Logname="Microsoft-Windows-TerminalServices-LocalSessionManager/Operational";ID=21;StartTime=$lastWeek} -ComputerName xde0300vm0110.na.xerox.org -Credential $userXDE | Select-Object TimeCreated,MachineName,Id,Message | Export-Csv -Path XDE0300VM0110_RDPEvt.csv
Get-WinEvent -FilterHashtable @{Logname="Microsoft-Windows-TerminalServices-LocalSessionManager/Operational";ID=21;StartTime=$lastWeek} -ComputerName usa7061vm0100.na.xerox.net -Credential $userNA | Select-Object TimeCreated,MachineName,Id,Message | Export-Csv -Path USA7061VM0100_RDPEvt.csv
#Get-WinEvent -FilterHashtable @{Logname="Microsoft-Windows-TerminalServices-LocalSessionManager/Operational";ID=21;StartTime=$lastWeek} -ComputerName xde7061vm0110.na.xerox.org -Credential $userXDE | Select-Object TimeCreated,MachineName,Id,Message | Export-Csv -Path XDE7061VM0110_RDPEvt.csv

# NS
Get-WinEvent -FilterHashtable @{Logname="Microsoft-Windows-TerminalServices-LocalSessionManager/Operational";ID=21;StartTime=$lastWeek} -ComputerName usa0300NS001.na.xerox.net -Credential $userNA | Select-Object TimeCreated,MachineName,Id,Message | Export-Csv -Path USA0300NS001_RDPEvt.csv
Get-WinEvent -FilterHashtable @{Logname="Microsoft-Windows-TerminalServices-LocalSessionManager/Operational";ID=21;StartTime=$lastWeek} -ComputerName usa0300NS002.na.xerox.net -Credential $userNA | Select-Object TimeCreated,MachineName,Id,Message | Export-Csv -Path USA0300NS002_RDPEvt.csv
Get-WinEvent -FilterHashtable @{Logname="Microsoft-Windows-TerminalServices-LocalSessionManager/Operational";ID=21;StartTime=$lastWeek} -ComputerName usa0300NS003.na.xerox.net -Credential $userNA | Select-Object TimeCreated,MachineName,Id,Message | Export-Csv -Path USA0300NS003_RDPEvt.csv
Get-WinEvent -FilterHashtable @{Logname="Microsoft-Windows-TerminalServices-LocalSessionManager/Operational";ID=21;StartTime=$lastWeek} -ComputerName usa7061NS001.na.xerox.net -Credential $userNA | Select-Object TimeCreated,MachineName,Id,Message | Export-Csv -Path USA7061NS001_RDPEvt.csv
Get-WinEvent -FilterHashtable @{Logname="Microsoft-Windows-TerminalServices-LocalSessionManager/Operational";ID=21;StartTime=$lastWeek} -ComputerName usa7061NS002.na.xerox.net -Credential $userNA | Select-Object TimeCreated,MachineName,Id,Message | Export-Csv -Path USA7061NS002_RDPEvt.csv
Get-WinEvent -FilterHashtable @{Logname="Microsoft-Windows-TerminalServices-LocalSessionManager/Operational";ID=21;StartTime=$lastWeek} -ComputerName usa7061NS003.na.xerox.net -Credential $userNA | Select-Object TimeCreated,MachineName,Id,Message | Export-Csv -Path USA7061NS003_RDPEvt.csv
Get-WinEvent -FilterHashtable @{Logname="Microsoft-Windows-TerminalServices-LocalSessionManager/Operational";ID=21;StartTime=$lastWeek} -ComputerName gbrend01NS001.eu.xerox.net -Credential $userEU | Select-Object TimeCreated,MachineName,Id,Message | Export-Csv -Path GBREND01NS001_RDPEvt.csv
Get-WinEvent -FilterHashtable @{Logname="Microsoft-Windows-TerminalServices-LocalSessionManager/Operational";ID=21;StartTime=$lastWeek} -ComputerName gbrend01NS002.eu.xerox.net -Credential $userEU | Select-Object TimeCreated,MachineName,Id,Message | Export-Csv -Path GBREND01NS002_RDPEvt.csv
Get-WinEvent -FilterHashtable @{Logname="Microsoft-Windows-TerminalServices-LocalSessionManager/Operational";ID=21;StartTime=$lastWeek} -ComputerName gbrend01NS003.eu.xerox.net -Credential $userEU | Select-Object TimeCreated,MachineName,Id,Message | Export-Csv -Path GBREND01NS003_RDPEvt.csv
Get-WinEvent -FilterHashtable @{Logname="Microsoft-Windows-TerminalServices-LocalSessionManager/Operational";ID=21;StartTime=$lastWeek} -ComputerName gbrlon05NS001.eu.xerox.net -Credential $userEU | Select-Object TimeCreated,MachineName,Id,Message | Export-Csv -Path GBRLON05NS001_RDPEvt.csv
Get-WinEvent -FilterHashtable @{Logname="Microsoft-Windows-TerminalServices-LocalSessionManager/Operational";ID=21;StartTime=$lastWeek} -ComputerName gbrlon05NS002.eu.xerox.net -Credential $userEU | Select-Object TimeCreated,MachineName,Id,Message | Export-Csv -Path GBRLON05NS002_RDPEvt.csv
Get-WinEvent -FilterHashtable @{Logname="Microsoft-Windows-TerminalServices-LocalSessionManager/Operational";ID=21;StartTime=$lastWeek} -ComputerName gbrlon05NS003.eu.xerox.net -Credential $userEU | Select-Object TimeCreated,MachineName,Id,Message | Export-Csv -Path GBRLON05NS003_RDPEvt.csv
