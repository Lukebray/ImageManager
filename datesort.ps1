# Get the files 
$Files = Get-ChildItem -Path 'C:\Users\LukeBray\Pictures\DateSortTest' -File -Recurse 
$Files

# Target Folder 
$TargetPath = 'C:\Users\LukeBray\Pictures\DateSortTest'

# Load assembly
[reflection.assembly]::LoadWithPartialName("System.Drawing")

Foreach ( $File in $Files ){
    #Get dateTaken property of picture
    $Pic = New-Object System.Drawing.Bitmap($File.FullName)
    $BiteArr = $pic.GetPropertyItem(36867).Value
    $DateString = [System.Text.Encoding]::ASCII.GetString($biteArr) 
    $DateTaken = [datetime]::ParseExact($DateString,"yyyy:MM:dd HH:mm:ss`0",$Null)
    $Pic.Dispose()

    # Directory path
	if ($DateTaken.Day -lt 10 -and $DateTaken.Month -lt 10) {
	$Directory = $targetPath + "\" + $DateTaken.Year + "-0" + $DateTaken.Month + "-0" + $DateTaken.Day
	}
	
	elseif ($DateTaken.Month -lt 10 -and $DateTaken.Day -gt 9) {
	$Directory = $targetPath + "\" + $DateTaken.Year + "-0" + $DateTaken.Month + "-" + $DateTaken.Day
	}
	
	elseif ($DateTaken.Day -lt 10 -and $DateTaken.Month -gt 9) {
	$Directory = $targetPath + "\" + $DateTaken.Year + "-" + $DateTaken.Month + "-0" + $DateTaken.Day
	}
	
	else {
	$Directory = $targetPath + "\" + $DateTaken.Year + "-" + $DateTaken.Month + "-" + $DateTaken.Day
	}

    # Move file
    if ( -not ( Test-Path $Directory ) ) {
        New-Item $Directory -ItemType Directory
    }
    Move-Item $File.FullName -Destination $Directory
}

pause