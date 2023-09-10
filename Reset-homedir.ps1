Import-Module ActiveDirectory

# reset HomeDirectory for users in specific context (OU)
# WARNING: if OU SearchBase is incorrect, it iterate all users in AD
# WARNING: HomeDrive must have colon added after a letter

function Reset-Homedir([System.Object] $Users, [string] $Share) {
    $count = $Users.Count
    Write-Host Počet uživatelů pro nastavení: $count
    $Users | ForEach-Object {
        $homeDirectory = $Share + $_.SamAccountName;
        Write-Host $count $_.SamAccountName $homeDirectory
        # Assign user's home directory path
        Set-ADUser -Identity $_.SamAccountName -HomeDirectory $homeDirectory -HomeDrive H:
        $count--
    }
}

#$users = Get-ADUser -Filter * -SearchBase "OU=2023,OU=Žáci,OU=Eso-cl Users Office365 sync,DC=eso-cl,DC=cz"
$users = Get-ADUser -Filter * -SearchBase "OU=Žáci,OU=Eso-cl Users Office365 sync,DC=eso-cl,DC=cz"
Reset-Homedir -Users $users -Share '\\srvfs01\Home$\'

#exit

$users = Get-ADUser -Filter * -SearchBase "OU=Vedení,OU=Eso-cl Users Office365 sync,DC=eso-cl,DC=cz"
Reset-Homedir -Users $users -Share '\\srvfs01\Home_U$\'

#exit

$users = Get-ADUser -Filter * -SearchBase "OU=Učitelé,OU=Eso-cl Users Office365 sync,DC=eso-cl,DC=cz"
Reset-Homedir -Users $users -Share '\\srvfs01\Home_U$\'

#exit