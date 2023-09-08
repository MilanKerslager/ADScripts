Import-Module activedirectory

$OrganisationUnit='OU=Eso-cl Users Office365 sync,DC=eso-cl,DC=cz' 
 
$Users=Get-ADUser -filter '*' -Properties homeDirectory, whenCreated

#$Users | Out-GridView

foreach ($User in $Users) {
    #Write-Host $User.SamAccountName $User.HomeDirectory
    if ($User.HomeDirectory -ne $null){ 
        $CheckUserhomedir=$(try {Test-Path $User.homeDirectory} catch {$null}) 
        if ($CheckUserhomedir -ne $True){ 
            Write-Host "User "$User.SamAccountName "has no homedir in FS "$User.homeDirectory". Account created "$User.whenCreated -ForegroundColor Red 
        } 
    }else{ 
       Write-Host "User "$User.SamAccountName "has not homedir defined in AD" -ForegroundColor Yellow
    } 
}  