#
# Get_UserParametersBlob.ps1
#
$TSuserParameters = New-Object System.Object
$TSuserParameters |Add-Member -membertype NoteProperty -name Types -value @{"CtxCfgPresent" = "Int32"; "CtxCfgFlags1" = "Int32"; "CtxCallBack" = "Int32"; "CtxKeyboardLayout" = "Int32"; "CtxMinEncryptionLevel" = "Int32"; "CtxNWLogonServer" = "Int32"; "CtxWFHomeDirDrive" = "ASCII"; "CtxWFHomeDir" = "ASCII"; "CtxWFHomeDrive" = "ASCII"; "CtxInitialProgram" = "ASCII"; "CtxMaxConnectionTime" = "Int32"; "CtxMaxDisconnectionTime" = "Int32"; "CtxMaxIdleTime" = "Int32"; "CtxWFProfilePath" = "ASCII"; "CtxShadow" = "Int32"; "CtxWorkDirectory" = "ASCII"; "CtxCallbackNumber" = "ASCII"}
$TSuserParameters |Add-Member -membertype NoteProperty -name TSAttributes -value @{}
$TSuserParameters |Add-Member -membertype NoteProperty -name SpecificationURL -value"http://msdn.microsoft.com/en-us/library/cc248570(v=prot.10).aspx"
$TSuserParameters |Add-Member -membertype NoteProperty -name Reserved -value [byte[]]
$TSuserParameters |Add-Member -membertype NoteProperty -name AttributeCount -value [uint16]0
$TSuserParameters |Add-Member -membertype ScriptMethod -name init -value {
	$this.TSAttributes = @{}
	[byte[]]$this.Reserved = [byte[]]$null
}
$TSuserParameters |Add-Member -membertype ScriptMethod -name UnBlob -value {
	Param ($Input)
	$this.init()
	$ArrayStep = 1
	#Add-Type -AssemblyName mscorlib
	#A new array for writing things back
	[Byte[]] $resultarray = $NULL
	#$userInfo.userParameters
	$char = [char]1
	#The value is a binary blob so we will get a binary representation of it
	#$input.length
	$userparms = [System.Text.Encoding]::unicode.GetBytes($Input)
	#$userparms.count
	#$userInfo.userParameters
	If ($userparms) #if we have any data then we need to process it
	{
		#Write-Host "Processing $userparms"
		$Valueenum = $userparms.GetEnumerator()
		$Valueenum.reset()
		$result = $Valueenum.MoveNext()
		#Now lets get past the initial reserved 96 bytes as we do not care about this.
		Write-Host "skipping reserved bytes"
		for ($ArrayStep = 1; $ArrayStep -le 96; $ArrayStep ++)
		{
			[byte[]]$this.reserved += $Valueenum.current #Store the reserved section so we can add it back for storing
			#Write-Host "Step $ArrayStep value $value"
			$result = $Valueenum.MoveNext()
		}
		#Next 2 bytes are the signature nee to turn this into a unicode char and if it is a P there is valid tem services data otherwise give up
		#So to combine two bites into a unicode char we do:
		Write-Host "Loading signature"
		[Byte[]]$unicodearray = $NULL
		for ($ArrayStep = 1; $Arraystep -le 2; $ArrayStep ++)
		{
			$value = $Valueenum.current
			#Write-Host "Step $ArrayStep value $value"
			[Byte[]]$unicodearray += $Value
			$result = $Valueenum.MoveNext()
		}
		$TSSignature = [System.Text.Encoding]::unicode.GetString($unicodearray)
		Write-Host "Signatire is $TSSignature based on $unicodearray"
		[uint32] $Value = $NULL
		If ($TSSignature -eq "P") # We have valid TS data
		{
			Write-Host "We have valid TS data so process it"
			#So now we need to grab the next two bytes which make up a 32 bit unsigned int so we know how many attributes are in this thing
			#We have no such data type so lets improvise by adding the value of the bytes together after multiplying the higer order byte by 256
			$Value = [uint16]$Valueenum.current
			$result = $Valueenum.MoveNext()
			$Value += [uint16]$Valueenum.current * 256
			$result = $Valueenum.MoveNext()
			write-Host "Found $value TS Attributes in the blob"
			$this.AttributeCount = [uint16]$value
			For ($AttribNo = 1; $AttribNo -le $value; $AttribNo ++)#For each attribute lets get going
			{
				#Get the first attribute, 2 bytes for name length, 2 bytes for value length, and 2 bytes for type, followed by the data. 
				#Grab name length
				$NameLength = [uint16]$Valueenum.current
				$result = $Valueenum.MoveNext()
				$NameLength += [uint16]$Valueenum.current * 256
				$result = $Valueenum.MoveNext()
				
				#Grab Value length
				$ValueLength = [uint16]$Valueenum.current
				$result = $Valueenum.MoveNext()
				$ValueLength += [uint16]$Valueenum.current * 256
				$result = $Valueenum.MoveNext()
				#Grab Type
				$TypeValue = [uint16]$Valueenum.current
				$result = $Valueenum.MoveNext()
				$TypeValue += [uint16]$Valueenum.current * 256
				$result = $Valueenum.MoveNext()
				#Write-Host "NameLength is $NameLength, ValueLength is $ValueLength, Type is $TypeValue"
				#Now we know how many bytes bellong to the following fields:
				#Get the name bytes into an array
				$NameUnicodeArray = $NULL
				for ($ArrayStep = 1; $Arraystep -le $NameLength; $ArrayStep ++)
				{
					[Byte[]]$NameUnicodeArray += $Valueenum.current
					$result = $Valueenum.MoveNext()
				}
				#Get the attribute value bytes into an array
				$ATTValueASCIICodes = ""
				for ($ArrayStep = 1; $Arraystep -le $ValueLength; $ArrayStep ++)
				{
					$ATTValueASCIICodes += [char][byte]$Valueenum.current
					$result = $Valueenum.MoveNext()
				}
				#Grab the name
				$AttributeName = [System.Text.Encoding]::unicode.GetString($NameUnicodeArray)
				Write-Host "UnBlobing: $AttributeName"
				#manipulate the value array as required
				#it is sets of two ASCII chars representing the numeric value of actual ASCII chars
				$AttributeValue = $NULL
				#$TempStr = "" #tem string for the Hex values
				#$ValueByteArray | foreach {	$TempStr += [char][byte]$_ } #get the bytes into a string as the ASCII chars
				#write-host "Temp String = $ATTValueASCIICodes it is $($ATTValueASCIICodes.length)"
				switch ($this.Types.$AttributeName)
				{
					"Int32" {				
						$AttributeValue = [convert]::toint32($ATTValueASCIICodes,16)
					}
					"ASCII" {
						$AttributeValue = ""
						#$ASCIIString = [System.Text.Encoding]::ASCII.GetString($TempStr)# make them into an ascii string
						for ($ArrayStep = 0; $Arraystep -lt $ATTValueASCIICodes.length; $ArrayStep += 2)
						{
							$FinalChar = [char][byte]([convert]::toint16( $ATTValueASCIICodes[($ArrayStep) ] + $ATTValueASCIICodes[$ArrayStep + 1],16)) #Grab the char created by this conversion
							$AttributeValue += $FinalChar #add them to the array.
						}
					}
					Default {
						$AttributeValue = "Attribute type Not defined"
					}
				}
				
				If ($this.TSAttributes.containsKey($AttributeName))
				{
					$this.TSAttributes.$AttributeName = @($AttributeValue,$ATTValueASCIICodes,$NameLength,$ValueLength,$TypeValue)
				}
				else
				{
					$this.TSAttributes.add($AttributeName,@($AttributeValue,$ATTValueASCIICodes,$NameLength,$ValueLength,$TypeValue))
				}
			}
			Write-Host "================================"
		}
		else
		{
			write-host "Signature is not valid, no TS Data"
		}
	}
}
$TSuserParameters |Add-Member -membertype ScriptMethod -name Blobify -value {
	#Lets build this thing
	#Start with the reserved bytes
	[byte[]]$result = $this.Reserved
	#now add the Signature "P" as we are writing valid data
	[byte[]]$result += [System.Text.Encoding]::unicode.GetBytes("P")
	#Now for the number of attributes being stored, we need to reverse the bytes in this 16 bit unsigned int
	$byte1 = [byte](($this.AttributeCount -band 65280) % 256)
	$byte2 = [byte]($this.AttributeCount -band 255)
	[byte[]]$result += $byte2
	[byte[]]$result += $byte1
	#Now for the attributes:
	$this.TSAttributes.getenumerator() | foreach {
		$Valuearray = $_.value
		$attname = $_.key
		#Get the reversed bytes for the NameLength field
		$byte1 = [byte](($Valuearray[2] -band 65280) % 256)
		$byte2 = [byte]($Valuearray[2] -band 255)
		[byte[]]$result += $byte2
		[byte[]]$result += $byte1
		#And again for the ValueLength
		$byte1 = [byte](($Valuearray[3] -band 65280) % 256)
		$byte2 = [byte]($Valuearray[3] -band 255)
		[byte[]]$result += $byte2
		[byte[]]$result += $byte1
		#And again for the typevalue
		$byte1 = [byte](($Valuearray[4] -band 65280) % 256)
		$byte2 = [byte]($Valuearray[4] -band 255)
		[byte[]]$result += $byte2
		[byte[]]$result += $byte1
		#Now add the propertyname in plain ASCII text
		Write-Host "Blobifying `"$attname`""
		#$attnamearray = [System.Text.Encoding]::unicode.GetBytes("$attname")
		#Write-Host "Attname array = $($attnamearray.count), valuelength = $($Valuearray[2])"
		[byte[]]$result += [System.Text.Encoding]::unicode.GetBytes("$attname")
		#write-Host "$($result.count)"
		#for ($loopcount = 1; $loopcount -le $attname.length; $loopcount ++)
		#{
		#	[byte[]]$result += [BYTE][CHAR]$attname[$loopcount - 1]
		#}
		#And finaly add the value to the result using the ASCII conversion
		#New array of bytes to add  the att value to so we can see how big it is
		$HexString = $Valuearray[1]
		[byte[]]$attvalbytes = $null
		switch ($this.Types.$attname)
		{
			"ASCII"	{
				#now for each part of the hex string lets get the value for that ascii char
				$HexString.ToCharArray() | foreach {
					[byte[]]$attvalbytes += [BYTE][CHAR]($_)
				}
			}
			"Int32" {
				#For each char we need to store the byte value
				$HexString.ToCharArray() | foreach {
					[byte[]]$attvalbytes += [BYTE][CHAR]($_ )
				}
			}
		}
		$result += $attvalbytes
		write-Host "att value is $($attvalbytes.count) and was $($Valuearray[3])"
		Write-Host "NewASCII = $([System.Text.Encoding]::ASCII.GetString($attvalbytes))"
		Write-Host "OldASCII = $($Valuearray[1])"
		Write-Host "================================"
		#[System.Text.Encoding]::unicode.GetString($result)
	}
	return [System.Text.Encoding]::unicode.GetString($result)
}
$TSuserParameters |Add-Member -membertype ScriptMethod -name AddUpdate -value {
	Param ($Attname,$NewAttValue,$TypeValue)
	$HexString = ""
	
	switch ($this.Types.$Attname)
	{
		"ASCII"	{
			Write-host "ascii"
			for ($loopcount = 0; $loopcount -lt $AttValue.length; $loopcount ++)
			{
				#Lets get the Hex value for this char as a string
				$HexString = [convert]::tostring([BYTE][CHAR]($AttValue[$loopcount]),16)
				#As the hex conversion drops the leading zero on the first char if we have a less than 10 value add 0 toi the front if we do not have an even number of chars
				If (($hexstring.length % 2) -eq 1){ $hexstring = "0" + $hexstring}
			}
		}
		"Int32" {
			#convert the int32 to hex
			$HexString = [convert]::tostring($AttValue,16)
			#As the hex conversion drops the leading zero on the first char if we have a less than 10 value add 0 toi the front if we do not have an even number of chars
			If (($hexstring.length % 2) -eq 1){ $hexstring = "0" + $hexstring}
			#There is also the special case of the ctX flags value which is always stored as the full 32bits even when there ere empty bits:
			if (($attname -eq "CtxCfgFlags1") -and ($hexstring.length -lt 8))
			{
				$Loopmax = $hexstring.length
				for ($loopcount = 1; $loopcount -le (8 - $Loopmax); $loopcount ++) {$HexString = "0" + $HexString ; Write-host "Done"}
			}
		}
	}
	$namelenght = ([System.Text.Encoding]::unicode.GetBytes($Attname)).count
	#Now change the values in the table:
	If ($this.TSAttributes.containsKey($Attname))
	{
		#If we do not have an type value we can look in the table and get it from there as it is unlikely this attribute will change types
		If (-not $TypeValue)#If we are not offered a type value by the user we will assum it is the standard of 1
		{
			$TypeValue = $this.TSAttributes.$Attname[4]
		}
		$this.TSAttributes.$Attname = @($NewAttValue,$HexString,$namelenght,$HexString.length,$TypeValue)
	}
	else
	{
		If (-not $TypeValue)#If we are not offered a type value by the user we will assum it is the standard of 1
		{
			$TypeValue = 1
		}
		$this.TSAttributes.add($Attname,@($NewAttValue,$HexString,$namelenght,$HexString.length,$TypeValue))
	}
}
$TSuserParameters |Add-Member -membertype ScriptMethod -name Remove -value {
	Param ($Attname)
	If ($this.TSAttributes.containsKey($Attname))
	{
		$test.remove("12")
		return $true
	}
	else
	{
		return $false
	}
}