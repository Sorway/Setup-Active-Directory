# Créations des unités d’organisation dans l'Active Directory

# Demande à l'utilisateur de saisir le nom du domaine
$domainName = Read-Host "Entrez le nom du domaine au format 'nom.extension' (exemple: sorway.local)"

# Vérification que le nom de domaine a été saisi
while ([string]::IsNullOrEmpty($domainName)) {
    Write-Host "Le nom du domaine est obligatoire." -ForegroundColor Red
    $domainName = Read-Host "Entrez le nom du domaine au format 'nom.extension' (exemple: sorway.local)"
}

# Conversion du nom du domaine en format "nom.extension"
$domainComponents = $domainName.Split('.')
$domainDC = $domainComponents -join ',DC='

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
$csvFile = Import-Csv -Path $csvFilePath -Delimiter ";"

# Parcours du fichier CSV pour créer les Unités d'Organisation (UO)
foreach ($entry in $csvFile) {
    $ouName = $entry.OU
    
    # Vérification si le nom de l'UO est non vide
    if ($ouName -ne "") {
        # Chemin complet de l'UO
        $ouPath = "OU=$ouName,DC=$domainDC"
        
        # Vérification si l'OU existe déjà
        $ouExists = Get-ADOrganizationalUnit -Filter {Name -eq $ouName} -SearchBase "DC=$domainDC" -ErrorAction SilentlyContinue
        
        if (!$ouExists) {
            # Création de l'UO avec gestion des erreurs
            try {
                New-ADOrganizationalUnit -Name $ouName -Path "DC=$domainDC" -ErrorAction Stop
                Write-Host "OU créée : $ouPath"
            } catch {
                Write-Host "Erreur lors de la création de l'OU $ouName : $_" -ForegroundColor Red
            }
        } else {
            Write-Host "L'OU $ouName existe déjà dans le domaine $domainName" -ForegroundColor Yellow
        }
    }
}