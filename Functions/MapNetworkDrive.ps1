# Mapper un lecteur réseau dans Active Directory pour les utilisateurs
Clear-Host 

# Demander le chemin du dossier de base
$basePath = Read-Host "Entrez le chemin du dossier de base (par exemple, \\Serveur\Donnees)"

# Vérifier si le dossier de base existe
while (-not (Test-Path $basePath -PathType Container)) {
    Write-Host "Le dossier de base $cheminBase n'existe pas. Veuillez verifier le chemin specifie." -ForegroundColor Red
    $basePath = Read-Host "Entrez le chemin du dossier de base (par exemple, \\Serveur\Donnees)"
}

# Demander la lettre du lecteur réseau
$driverLetter = Read-Host "Entrez la lettre du lecteur reseau (par exemple, Z)"

# Récupérer toutes les UOs contenant des utilisateurs
$organizationalUnits = Get-ADOrganizationalUnit -Filter 'Name -like "*"' -SearchScope OneLevel | Where-Object { $_.DistinguishedName -notlike '*OU=Domain Controllers*' }

foreach ($organizationalUnit in $organizationalUnits) {
    # Récupérer tous les utilisateurs de l'OU actuelle
    $users = Get-ADUser -Filter * -SearchBase $organizationalUnit.DistinguishedName

    foreach ($user in $users) {
        $userName = $user.SamAccountName
        $profil = $user.GivenName[0] + "." + $user.Surname

        # Définir le chemin complet du dossier de base
        $homePath = Join-Path $basePath $profil

        # Créer le dossier s'il n'existe pas
        if (-not (Test-Path $homePath -PathType Container)) {
            New-Item -Path $homePath -ItemType Directory
            Write-Host "Dossier cree: $homePath" -ForegroundColor Green
        }

        # Mettre à jour le chemin du dossier de base de l'utilisateur
        Set-ADUser -Identity $userName -HomeDirectory $homePath -HomeDrive $driverLetter 
        Write-Host "Lecteur reseau $driverLetter mappe pour $userName vers $homePath." -ForegroundColor Green
    }
}

# Demande à l'utilisateur s'il souhaite revenir au menu principal
Read-Host "Appuyez sur une touche pour revenir au menu principal."
exit