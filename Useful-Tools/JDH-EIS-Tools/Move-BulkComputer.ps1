#
# Move_BulkComputer.ps1
#
#**************************************************
# This script is intended to move those computer
# accounts within the Xerox Enterprise Directory 
# which are not part of the HCL Transition. 
#
# Filename: MoveSvr.ps1
#	Created: 2-June-2009	By: jim.herrmann@xerox.com
#
# Command Line:
# 	MoveSvr.ps1 <filename> <destination>
#
#	<filename>		Text file listing computer objects to be moved.
#					File must only contain NetBIOS names, one per line!
#
#	<destination>	Active Directory location where the objects will be moved to.
#					(i.e. "OU=Servers,OU=USA,DC=na,DC=xerox,DC=net")  Quotes Required!

$listFile = ""
$compName = ""
$destOU = ""
$compDN = ""
$moveState = ""
$X=0
$Y=0

Write-Host "Starting Script MoveSvr.ps1"
#Check for correct number of command line arguments and validate info.
If ($Args.Count -ne 2)
	{
	Write-Error "Command line parameters incorrect."
	Write-Host "MoveSvr.ps1 <filename> <destination>"
	}
Else
	{
	If ($Args[0].contains("="))
		{ # Command Line is reversed <destination> <filename>
		$listFile=$Args[1]
		$destOU=$Args[0]
		}
	Else
		{
		$listFile=$Args[0]
		$destOU=$Args[1]
		}
	If (Test-Path $PWD\$listFile)
		{
		Write-Output "List File Selected:" $listFile
		Write-Output "Destination OU:" $destOU

		# Being processing list file
		Get-Content $PWD\$listFile | ForEach-Object {
			$compName=$_
			$compDN=dsQuery computer -name $compName
			Write-Host "Moving:" $compDN
		
			$moveState=dsMove $compDN -newparent $destOU
			Write-Output $moveState
			If ($moveState.Contains("succeeded"))
				{
				# Add one to successful count
				$X=$X++
				}
			Else
				{
				# Add one to failure count
				$Y=$Y++
				}
			}
		# Write completion information
		Write-Host "Successfully moved" $X "servers."
		Write-Host "Failed to move" $Y "servers."
		Write-Host "Script Completed."
		}
	Else
		{
		Write-Error "List file not found."
		}
	}