#This should point to the root of a home folder/FR share. Subfolders in this folder match AD account usernames. 

$Folders = get-childitem \\SRVFS01\HOME$\
$Folders+= get-childitem \\SRVFS01\HOME_U$\

$NamesToIgnore = ""
#$NamesToIgnore = "balajkovak"

$FoldersToBeRemoved = @()
foreach ($Folder in $Folders){
    $Username = $Folder.Name
    if ($NamesToIgnore -notcontains $Username) {
        try {
          $UsernameCheck = Get-ADUser -Identity $Username  -Properties * -ErrorAction SilentlyContinue
        } catch {
        }
        if ($? -eq $false -and $Username -notlike $NamesToIgnore){
            $FoldersInformation = @{"Username"=$Username;"FullName"=$Folder.FullName;"Last Write Time"=$Folder.LastWriteTime}
            $FoldersToBeRemoved += New-Object -TypeName psobject -Property $FoldersInformation
            Write-Host $Username $Folder.FullName
        }
    }
}

$FoldersToBeRemoved | Out-GridView

pause

$FoldersToBeRemoved | ForEach-Object {
    Write-Host "Deleting: "$_.FullName
    # pro skutecne smazani zakomentovat -Verbose -WhatIf
    #Remove-Item $_.FullName -Recurse -Force -Verbose -WhatIf
    Remove-Item $_.FullName -Recurse -Force
}