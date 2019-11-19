
function DownloadBuildDefinitionsFromFolder
{
    param([string] $folderName)

    $homeDir = "<MyLocalFolder>\$folderName"
    New-Item -ItemType Directory -Force -Path $homeDir
    $VSTS_RestApiHost = "<MyTeamCollectionProjectURL>/_apis"
    $VSTS_PAT = "<MyToken>"
    $headers = @{Authorization = "Basic " + [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($VSTS_PAT)"))}

    ### Download Folder Info ###
    Write-Host -NoNewLine "Downloading Build Pipeline Folder Info....."
    $downloadBuildDef = "$($VSTS_RestApiHost)/build/folders/$folderName"
    $buildDefinitions = Invoke-RestMethod -Method Get -Uri $downloadBuildDef -Headers $headers -OutFile "$homeDir\..\$folderName.json"
    Write-Host "$folderName"

        
    ### Download Build Definitions ###
    Write-Host "Downloading Build Pipelines..."
    $downloadBuildDef = "$($VSTS_RestApiHost)/build/definitions?path=\$folderName"
    $buildDefinitions = Invoke-RestMethod -Method Get -Uri $downloadBuildDef -Headers $headers
    Write-Host $buildDefinitions
    foreach ($buildDefinition in $buildDefinitions.value) {
        $defName = $buildDefinition.name
        $defId = $buildDefinition.id
        Write-Host "Downloading $defId $defName ....."
        $downloadBuildDef = "$($VSTS_RestApiHost)/build/definitions/$defId"
        $response = Invoke-RestMethod -Method Get -Uri $downloadBuildDef -Headers $headers -OutFile "$homeDir\$defName.json"
    }
    
}

DownloadBuildDefinitionsFromFolder "<MyBuildFolder-1>"
DownloadBuildDefinitionsFromFolder "<MyBuildFolder-2>"

