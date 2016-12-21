#
# FindShares.ps1
#
# Define the parameter that passes in the computer name to the script.
# Use the local computer if no name is specified.
param ($computer = ".")

# Create a WMI object to access the Win32_Share class.  Pass the
# data down the pipeline to a filter, which removes the default shares.
# Then, pass the data down the pipeline to sort the results by name.
$shares = get-wmiobject -class "Win32_Share" `
  -namespace "root\CIMV2" -computername $computer |
  where-object `
  {
    ($_.caption -ne "default share") `
    -and ($_.caption -notlike "remote*") `
    -and ($_.caption -notlike "logon*") `
  } |
  sort-object name

# Run an If statement if user-defined shares exist.
if ($shares -ne $null)
{
  # Add a blank line before the results.  Create a
  # ForEach statement to iterate through the shares.
  write-host
  foreach ($share in $shares)
  {
    # For each share, provide the name and path.
    write-host "Share name: " $share.name
    write-host "File path: " $share.path
    write-host
  }
}

# Run an Else statement if no user-defined share exit.
else
{
  if ($computer -eq ".")
  {
    # Return a message that names the local computer.
    write-host
    write-host "The computer $env:computerName contains only the default shares."
    write-host
  }

  else
  {
    # Return a message that names the specified computer.
    write-host
    write-host "The computer $computer contains only the default shares."
    write-host
  }
}