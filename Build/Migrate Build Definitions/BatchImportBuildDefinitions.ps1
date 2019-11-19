
function UploadBuildDefinitionsToFolder
{
    param([string] $folderName)

    $homeDir = "<MyLocalFolder>\epnet"
    $VSTS_RestApiHost = "<MyCollectionProjectURL>/_apis"
    $VSTS_PAT = "<MyToken>"
    $headers = @{Authorization = "Basic " + [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($VSTS_PAT)"))}


    ### Create Build Folder ###
    $buildDefInfo = Get-Content "$homeDir\$folderName.json"
    Write-Host "Creating Build Pipeline Folder.....$folderName"
    $createBuildFolder = "$($VSTS_RestApiHost)/build/folders?path=$folderName&api-version=5.0-preview.2"
    $response = Invoke-RestMethod -Method PUT -Uri $createBuildFolder -Body $buildDefInfo -ContentType 'application/json' -Headers $headers
    Write-Host $response.id


    ### Upload Build Definitions ###
    $jsonFiles = Get-ChildItem "$homeDir\$folderName"
    foreach($jsonFile in $jsonFiles) {
        Write-Host -NoNewLine "Uploading Build Definition.....$($jsonFile.Name)....."
        $uploadBuildDef = "$($VSTS_RestApiHost)/build/definitions?api-version=5.0"
        $buildDefInfo = Get-Content $jsonFile.FullName
        $response = Invoke-RestMethod -Method POST -Uri $uploadBuildDef -Body $buildDefInfo -ContentType 'application/json' -Headers $headers
        Write-Host $response.id
    }
}


UploadBuildDefinitionsToFolder "<MyBuildFolder-1>"
UploadBuildDefinitionsToFolder "<MyBuildFolder-2>"
