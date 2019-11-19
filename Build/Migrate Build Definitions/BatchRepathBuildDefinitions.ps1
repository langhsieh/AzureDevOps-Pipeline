
function RepathBuildDefinition
{
    param([string] $folderName)
    $oldFolderName = "$folderName"
    $newFolderName = "$($folderName)_Future"
    $homeDir = "<MyLocalFolder>"

    ### Copy new folder's json file ###
    Copy-Item "$homeDir\$oldFolderName.json" "$homeDir\$newFolderName.json"

    ### Replace with new Path then drop it over to new path folder ###
    $jsonFiles = Get-ChildItem "$homeDir\$oldfolderName"
    foreach($jsonFile in $jsonFiles) {
        Write-Host -NoNewLine "Replacing Build Definition Info with new path.....$($jsonFile.Name)....."
        $buildDefInfo = Get-Content $jsonFile.FullName
        $buildDefInfo = $buildDefInfo.Replace("`"path`":`"\\$oldFolderName`",", "`"path`":`"\\$newFolderName`",")
        New-Item -ItemType Directory -Force -Path "$homeDir\$newFolderName"
        $buildDefInfo | Set-Content -Path "$homeDir\$newFolderName\$($jsonFile.Name)"
        Write-Host $newFolderName
    }
}

RepathBuildDefinition "<MyBuildFolder-1>"
RepathBuildDefinition "<MyBuildFolder-2>"