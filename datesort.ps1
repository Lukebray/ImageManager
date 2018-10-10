# Get the files 
$Files = Get-ChildItem -Path 'YOUR_PATH_HERE' -File -Recurse 
$Files

# Target Folder 
$TargetPath = 'TARGET_PATH_HERE'

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
	$Directory = $targetPath + "\" + $DateTaken.Year + "-" + ($DateTaken.Month).PadLeft(2,'0') + "-" + ($DateTaken.Day).PadLeft(2,'0')

    # Move file
    if ( -not ( Test-Path $Directory ) ) {
        New-Item $Directory -ItemType Directory
    }
    Move-Item $File.FullName -Destination $Directory
}

pause
