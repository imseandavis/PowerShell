
function New-VCard {
<#
.SYNOPSIS
    Builds a VCard

.DESCRIPTION
    Uses the data passed in as parameters to build a valid VCard string.

.PARAMETER Name
    The name to be put in the "Name" vCard field.
    
.PARAMETER FormattedName
    The name to be put in the "Formatted Name" vCard field.

.PARAMETER Nickname
    The name to be put in the "Nickname" vCard field.

.PARAMETER Birthday
    The birthday to be put in the "Birthday" vCard field.

.PARAMETER Address
    The address to be put in the "Address" vCard field.

.PARAMETER Telephone
    The phone number to be put in the "Telephone" vCard field.

.PARAMETER Email
    The email address to be put in the "Email" vCard field.

.PARAMETER LogoURL
	The Logo URL to be put in the "Logo" vCard field.
	
.PARAMETER Title	
	The title to be put in the "Title" vCard field.

.PARAMETER Organization
	The organization to be put in the "Organization" vCard field.

.PARAMETER Note
	The note to be put in the "Note" vCard field.

.PARAMETER URL
	The URL to be put in the "Title" vCard field.

.PARAMETER UID
	The UID to be put in the "Title" vCard field.

.PARAMETER Twitter
	The Twitter handle to be put in the "Twitter" vCard field.

.PARAMETER Skype
	The Skype username to be put in the "Skype" vCard field.

.PARAMETER Properties
	The properties used to build the vCard.
	
#>
	
	[OutputType([string])]
	param(
		$Name,
		
		[Parameter(Mandatory=$true)]
		$FormattedName,
		
		$Nickname,
		$Birthday,
		
		$Address,
		
		$Telephone,
		
		$Email,
		
		[ValidateSet("H","L","M","Q")]
		[Parameter(Mandatory=$false)]
		$ErrorCorrection = "M",
		
		$LogoURL,
		$Title,
		$Organization,
		$Note,
		$URL,
		$UID,
		$Twitter,
		$Skype,
		$Properties,
		        
		[Parameter(Mandatory=$true)]
        $Content,

        [ZXing.BarcodeFormat]$BarcodeFormat = [ZXing.BarcodeFormat]::QR_Code,

        [ZXing.Common.EncodingOptions]$Options,

        [Parameter(Mandatory=$true)]
		[String]$ImagePath,

        [System.Drawing.Imaging.ImageFormat]$ImageFormat = [System.Drawing.Imaging.ImageFormat]::Png,

        [int]$Width,

        [int]$Height,

        [switch]$Passthrough,
		
		[Parameter(Mandatory=$false)]
		$TopPadding = 2,
		
		[Parameter(Mandatory=$false)]
		$SidePadding = 2,
		
		[Parameter(Mandatory=$false)]
		$CharacterWidth = 1,
		
		[switch]$Invert
	)
	
	process {
		#Create a New vCard Builder Object
		$vCardBuilder = New-Object Text.StringBuilder("BEGIN:VCARD`r`nVERSION:4.0`r`n")
		
		#Map vCard Parameters To vCard Fields As Per RFC Found Here: https://en.wikipedia.org/wiki/VCard#vCard_4.0
		#Theres Many More Fields But These Were The Ones I Thought Would Be Most Frequently Used, Feel Free To Add More
		$ParameterMapping = @{
			"Name"="N";
			"FormattedName"="FN";
			"Birthday"="BDAY";
			"Address"="ADR";
			"Telephone"="TEL";
			"LogoURL"="LOGO;PNG";
			"Organization"="ORG";
			"Twitter"="X-TWITTER";
			"Skype"="X-SKYPE";
		}
		
		#Write All The Key Value Pairs To The vCard Object
		$PSBoundParameters.Keys | ?{$_ -ne "Properties"} | %{
			if($ParameterMapping.ContainsKey($_)) {
				$Name = $ParameterMapping[$_]
			} else {
				$Name = $_.ToUpper()
			}
			$Value = $PSBoundParameters[$_]
			$vCardBuilder.AppendLine( ("{0}:{1}" -f $Name, $Value) ) | Out-Null
		}
		if($Properties) {
			$Properties.Keys | %{
				$vCardBuilder.AppendLine( ("{0}:{1}" -f $_, $Properties[$_]) ) | Out-Null
			}
		}
		$vCardBuilder.Append("END:VCARD") | Out-Null
		$vCardBuilder.ToString()
		
		#Convert To QR Code
		$QRCode = [ZXing.QrCode.Internal.Encoder]::Encode($vCardBuilder, [ZXing.QrCode.Internal.ErrorCorrectionLevel]::$ErrorCorrection)
		
		#Output QR Code To Image File
		$Writer = New-Object ZXing.BarcodeWriter -Property @{ Format = $BarcodeFormat; Options = $Options }
		if($Width) {
			$Writer.Options.Width = $Width
		}
		if($Height) {
			$Writer.Options.Height = $Height
		}
		try {
			$Bitmap = $Writer.Write($Content)
			$Bitmap.Save($ImagePath, $ImageFormat)
			if($Passthrough) {
				$ImagePath
			}
		} catch {
			Write-Error -Message "Error creating barcode: $($_.Exception.Message)" -Exception $_.Exception
		} finally {
			if($Bitmap) {
				$Bitmap.Dispose()
			}
		}
		
		#Output QR Code To Screen If Display QR Code Was Turned On
		If($DisplayQRCode)
		{
			if($Invert) {
			$BlankChar = " "
			$SolidChar = [string][char]0x2588
			$TopActiveChar = [string][char]0x2580
			$BottomActiveChar = [string][char]0x2584
			} else {
				$BlankChar = [string][char]0x2588
				$SolidChar = " "
				$TopActiveChar = [string][char]0x2584
				$BottomActiveChar = [string][char]0x2580
			}
			
			1..$TopPadding | %{
				Write-Debug ($BlankChar * ($QRCode.Matrix.Width + $SidePadding + $SidePadding) * $CharacterWidth) -fore black -back white
				$BlankChar * ($QRCode.Matrix.Width + $SidePadding + $SidePadding) * $CharacterWidth
			}
			for($r = 0; $r -lt $QRCode.Matrix.Height; $r++) {
				$RowSB = new-object Text.StringBuilder
				$RowSB.Append($BlankChar * $SidePadding * $CharacterWidth) | Out-Null
				for($c = 0; $c -lt $QRCode.Matrix.Width; $c++) {
					$ThisRowEntry = $QRCode.Matrix.Array[$c][$r]
					if($r -lt $QRCode.Matrix.Height - 1) {
						$NextRowEntry = $QRCode.Matrix.Array[$c][$r + 1]
					} else {
						$NextRowEntry = 0
					}
					
					if($ThisRowEntry -And $NextRowEntry) {
						$Out = $SolidChar
					} elseif ($ThisRowEntry -And !$NextRowEntry) {
						$Out = $TopActiveChar
					} elseif (!$ThisRowEntry -And $NextRowEntry) {
						$Out = $BottomActiveChar
					} else {
						$Out = $BlankChar
					}
					
					$RowSB.Append($Out) | Out-Null
				}
				$r++
				$RowSB.Append($BlankChar * $SidePadding * $CharacterWidth) | Out-Null
				Write-Debug $RowSB.ToString() -fore Black -back White
				$RowSB.ToString()
			}
			1..$TopPadding | %{
				Write-Debug ($BlankChar * ($QRCode.Matrix.Width + $SidePadding + $SidePadding) * $CharacterWidth) -fore black -back white
				$BlankChar * ($QRCode.Matrix.Width + $SidePadding + $SidePadding) * $CharacterWidth
			}
		}
	}
}





function Format-QRCode {
	
<#
.SYNOPSIS
    Takes a QRCode object and formats it for output on the screen.

.DESCRIPTION
    Uses line drawing to convert a QRCode for display on the screen.

.PARAMETER QRCode
    A QRCode output from ConvertTo-QRCode

.PARAMETER TopPadding
    The ammount of padding to put around the code.

.PARAMETER SidePadding
    The ammount of padding to put around the code. You may need to add padding depending on the font used in your terminal.

.PARAMETER CharacterWidth
    The number of characters to use to output each block of the QRCode.

.PARAMETER Invert
    The default PowerShell console is light text on a dark background. If you are using dark text on a light background
    you will need to invert the output so the barcode is the correct color.
#>

	param(
		[Parameter(ValueFromPipeline=$true,Mandatory=$true)]
		[ZXing.QrCode.Internal.QRCode]$QRCode,
		
		[Parameter(Mandatory=$false)]
		$TopPadding = 2,
		
		[Parameter(Mandatory=$false)]
		$SidePadding = 2,
		
		[Parameter(Mandatory=$false)]
		$CharacterWidth = 1,
		
		[switch]$Invert
	)
	
	#These seem backwards, but in the default ps console they come out correct (dark bg, light text)
	if($Invert) {
		$BlankChar = " "
		$SolidChar = [string][char]0x2588
		$TopActiveChar = [string][char]0x2580
		$BottomActiveChar = [string][char]0x2584
	} else {
		$BlankChar = [string][char]0x2588
		$SolidChar = " "
		$TopActiveChar = [string][char]0x2584
		$BottomActiveChar = [string][char]0x2580
	}
	
	1..$TopPadding | %{
		#Write-Host ($BlankChar * ($QRCode.Matrix.Width + $SidePadding + $SidePadding) * $CharacterWidth) -fore black -back white
		$BlankChar * ($QRCode.Matrix.Width + $SidePadding + $SidePadding) * $CharacterWidth
	}
	for($r = 0; $r -lt $QRCode.Matrix.Height; $r++) {
		$RowSB = new-object Text.StringBuilder
		$RowSB.Append($BlankChar * $SidePadding * $CharacterWidth) | Out-Null
		for($c = 0; $c -lt $QRCode.Matrix.Width; $c++) {
			$ThisRowEntry = $QRCode.Matrix.Array[$c][$r]
			if($r -lt $QRCode.Matrix.Height - 1) {
				$NextRowEntry = $QRCode.Matrix.Array[$c][$r + 1]
			} else {
				$NextRowEntry = 0
			}
			
			if($ThisRowEntry -And $NextRowEntry) {
				#Make a solid block
				$Out = $SolidChar
			} elseif ($ThisRowEntry -And !$NextRowEntry) {
				$Out = $TopActiveChar
			} elseif (!$ThisRowEntry -And $NextRowEntry) {
				$Out = $BottomActiveChar
			} else {
				$Out = $BlankChar
			}
			
			$RowSB.Append($Out) | Out-Null
		}
		$r++
		$RowSB.Append($BlankChar * $SidePadding * $CharacterWidth) | Out-Null
		#Write-Host $RowSB.ToString() -fore Black -back White
		$RowSB.ToString()
	}
	1..$TopPadding | %{
		#Write-Host ($BlankChar * ($QRCode.Matrix.Width + $SidePadding + $SidePadding) * $CharacterWidth) -fore black -back white
		$BlankChar * ($QRCode.Matrix.Width + $SidePadding + $SidePadding) * $CharacterWidth
	}
}


function Out-BarcodeImage {
    
<#
.SYNOPSIS
    Creates a barcode and saves it as an image file.

.DESCRIPTION
    Uses the ZXing.Net library to create barcodes and save them as image files.

.PARAMETER Content
    The contents of the barcode.  This needs to be valid content for the BarcodeFormat you are writing.

.PARAMETER BarcodeFormat
    One of the barcode formats supported by ZXing.Net

.PARAMETER Options
    Barcode encoding options.

.PARAMETER Path
    The output file to create.

.PARAMETER ImageFormat
    One of the image formats supported by System.Drawing.Imaging

.PARAMETER Width
    The width in pixels of the image file.

.PARAMETER Height
    The height in pixels of the image file.

.PARAMETER Passthrough
    Indicates that the output path should be passed along in the pipeline.
#>

	param(
        [Parameter(Mandatory=$true)]
        $Content,

        [ZXing.BarcodeFormat]$BarcodeFormat = [ZXing.BarcodeFormat]::QR_Code,

        [ZXing.Common.EncodingOptions]$Options,

        [String]$Path,

        [System.Drawing.Imaging.ImageFormat]$ImageFormat = [System.Drawing.Imaging.ImageFormat]::Png,

        [int]$Width,

        [int]$Height,

        [switch]$Passthrough
    )
    $Writer = New-Object ZXing.BarcodeWriter -Property @{ Format = $BarcodeFormat; Options = $Options }
    if($Width) {
        $Writer.Options.Width = $Width
    }
    if($Height) {
        $Writer.Options.Height = $Height
    }
    try {
        $Bitmap = $Writer.Write($Content)
        $Bitmap.Save($Path, $ImageFormat)
        if($Passthrough) {
            $Path
        }
    } catch {
        Write-Error -Message "Error creating barcode: $($_.Exception.Message)" -Exception $_.Exception
    } finally {
        if($Bitmap) {
            $Bitmap.Dispose()
        }
    }
}