# Načtení AD modulu (pokud není načten)
Import-Module ActiveDirectory

$ou = "OU=Učitelé,OU=Eso-cl Users Office365 sync,DC=eso-cl,DC=cz"
$ou = "OU=Žáci,OU=Eso-cl Users Office365 sync,DC=eso-cl,DC=cz"

# Získání všech uživatelů
$users = Get-ADUser -Filter * -SearchBase $ou -Properties GivenName, Surname, DisplayName

$count = $users.Count
foreach ($user in $users) {
    # Sestavení nového jména
    $newDisplayName = "$($user.GivenName) $($user.Surname)".Trim()

    # Přeskočí, pokud je jméno prázdné nebo stejné
    if ([string]::IsNullOrWhiteSpace($newDisplayName) -or ($user.DisplayName -eq $newDisplayName)) {
        continue
    }

    Write-Output "${count}: $($user.SamAccountName): '$($user.DisplayName)' -> '$newDisplayName'"

    # Nastavení nového display name
    Set-ADUser -Identity $user.DistinguishedName -DisplayName $newDisplayName
    $count--
}