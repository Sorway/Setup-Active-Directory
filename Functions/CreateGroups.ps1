# Créations des groupes dans l'Active Directory

# Demande à l'utilisateur de saisir le nom du domaine
$domainName = Read-Host "Entrez le nom du domaine au format 'nom.extension' (exemple: sorway.local)"

# Vérification que le nom de domaine a été saisi
while ([string]::IsNullOrEmpty($domainName)) {
    Write-Host "Le nom du domaine est obligatoire." -ForegroundColor Red
    $domainName = Read-Host "Entrez le nom du domaine au format 'nom.extension' (exemple: sorway.local)"
}

# Conversion du nom du domaine en format "nom.extension"
$domainDC = "DC=" + ($domainName.Split('.') -join ',DC=')

# Demande à l'utilisateur de saisir le chemin vers le fichier CSV
$csvFilePath = Read-Host "Entrez le chemin complet du fichier CSV"

# Vérification que le chemin du fichier CSV a été saisi
while ([string]::IsNullOrEmpty($csvFilePath)) {
    Write-Host "Le chemin du fichier CSV est obligatoire." -ForegroundColor Red
    $csvFilePath = Read-Host "Entrez le chemin complet du fichier CSV"
}

# Vérification que le chemin du fichier CSV est valide
if (-not (Test-Path -Path $csvFilePath -PathType Leaf)) {
    Write-Host "Le chemin du fichier CSV n'est pas valide." -ForegroundColor Red
    $csvFilePath = Read-Host "Entrez le chemin complet du fichier CSV"
}

# Importation du fichier CSV
$csvFile = Import-Csv -Path $csvFilePath -Delimiter ";"*

# Création des groupes en fonction du fichier CSV
foreach ($entry in $csvFile) {
    $groupName = $entry.Groupe
    $ouName = $entry.OU

    # Vérification si le nom du groupe et de l'OU sont non vides
    if ($groupName -ne "" -and $ouName -ne "") {
        # Chemin complet de l'OU
        $ouPath = "OU=$ouName,$domainDC"

        # Vérification si l'OU existe déjà
        $ouExists = Get-ADOrganizationalUnit -Filter {Name -eq $ouName} -SearchBase $domainDC -ErrorAction SilentlyContinue

        if (!$ouExists) {
            # Création de l'OU avec gestion des erreurs
            try {
                New-ADOrganizationalUnit -Name $ouName -Path $domainDC -ErrorAction Stop
                Write-Host "OU créée : $ouPath"
            } catch {
                Write-Host "Erreur lors de la création de l'OU $ouName : $_" -ForegroundColor Red
            }
        } else {
            Write-Host "L'OU $ouName existe déjà dans le domaine $domainName" -ForegroundColor Yellow
        }

        # Création du groupe dans l'OU spécifiée
        try {
            New-ADGroup -Name $groupName -Path $ouPath -GroupScope Global
            Write-Host "Groupe $groupName créé dans $ouPath"
        } catch {
            Write-Host "Erreur lors de la création du groupe $groupName : $_" -ForegroundColor Red
        }
    }
}

# Demande à l'utilisateur s'il souhaite revenir au menu principal
Read-Host "Appuyez sur une touche pour revenir au menu principal ? (O/N)"
exit