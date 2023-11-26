# Création des profils itinérant pour les utilisateurs
Clear-Host 

# Demander le chemin des profils itinérants
$roamingProfilePath = Read-Host "Entrez le chemin du profil itinerant (par exemple, \\Serveur\ProfilItinerant)"

while (-not (Test-Path $roamingProfilePath -PathType Container)) {
    Write-Host "Le dossier des profil itinerants $roamingProfilePath n'existe pas. Veuillez verifier le chemin specifie." -ForegroundColor Red
    $roamingProfilePath = Read-Host "Entrez le chemin du profil itinerant (par exemple, \\Serveur\ProfilItinerant)"
}

# Récupérer toutes les UOs contenant des utilisateurs
$organizationalUnits = Get-ADOrganizationalUnit -Filter 'Name -like "*"' -SearchScope OneLevel | Where-Object { $_.DistinguishedName -notlike '*OU=Domain Controllers*' }

foreach ($organizationalUnit in $organizationalUnits) {
    # Récupérer tous les utilisateurs de l'OU actuelle
    $users = Get-ADUser -Filter * -SearchBase $organizationalUnit.DistinguishedName

    foreach ($user in $users) {
        $userName = $user.SamAccountName

        # Vérifier si le profil itinérant est déjà configuré
        if ($null -eq $user.ProfilePath) {
            # Configurer le profil itinérant
            $profil = $user.GivenName[0] + "." + $user.Surname
            Set-ADUser -Identity $userName -ProfilePath "$($roamingProfilePath)\$($profil)"
            Write-Host "Le profil itinerant a ete configure pour l'utilisateur $userName dans $organizationalUnit."
        } else {
            Write-Host "Le profil itinerant est deja configure pour l'utilisateur $userName dans $organizationalUnit."
        }
    }
}

Write-Host "La configuration des profils d'itinerance pour tous les utilisateurs dans les OU contenant des utilisateurs a ete effectuee avec succes." -ForegroundColor Green

# Demande à l'utilisateur s'il souhaite revenir au menu principal
Read-Host "Appuyez sur une touche pour revenir au menu principal."
exit