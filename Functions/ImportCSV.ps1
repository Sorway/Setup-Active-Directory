# Créations des unités d’organisation, groupes et importation des utilisateurs dans l'Active Directory
Clear-Host

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
$csvFile = Import-Csv -Path $csvFilePath -Delimiter ";" -Encoding UTF8

# Parcourir chaque ligne du fichier CSV
foreach ($entry in $csvFile) {
    # Vérification si l'Unité d'Organisation existe, sinon la créer
    $ouName = $entry.OU
    $ouPath = "OU=$ouName,$domainDC"
    if ($ouName -ne "") {
        if (-not (Get-ADOrganizationalUnit -Filter {Name -eq $ouName} -SearchBase $domainDC -ErrorAction SilentlyContinue)) {
            try {
                New-ADOrganizationalUnit -Name $ouName -Path $domainDC -ErrorAction Stop
                Write-Host "OU creee : $ouPath" -ForegroundColor Green
            } catch {
                Write-Host "Erreur lors de la creation de l'OU $ouName : $_" -ForegroundColor Red
            }
        }
    
    }

    # Vérification si le groupe existe, sinon le créer
    $groupName = $entry.Groupe
    if ($groupName -ne "") {
        if (-not (Get-ADGroup -Filter {Name -eq $groupName} -SearchBase $domainDC -ErrorAction SilentlyContinue)) {
            try {
                New-ADGroup -Name $groupName -Path $ouPath -GroupCategory Security -GroupScope Global
    
                $memberOf = $entry.MemberOf
                if ($memberOf) {
                    if (-not (Get-ADGroup -Filter {Name -eq $memberOf} -SearchBase $domainDC -ErrorAction SilentlyContinue)) {
                        New-ADGroup -Name $memberOf -Path $ouPath -GroupCategory Security -GroupScope Global
                    }
                    Get-ADGroup -Filter 'Name -eq $groupName' | Add-ADPrincipalGroupMembership -MemberOf $memberOf
                }
    
                Write-Host "Groupe $groupName cree dans $ouPath" -ForegroundColor Green
            } catch {
                Write-Host "Erreur lors de la creation du groupe $groupName : $_" -ForegroundColor Red
            }
        }
    }

    # Création de l'utilisateur
    try {
        $userSamAccountName = $entry.Prenom[0] + "." + $entry.Nom
        $password = (ConvertTo-SecureString -AsPlainText $entry.Password -Force)
        $userProperties = @{
            Name                = "$($entry.Prenom) $($entry.Nom)"
            DisplayName         = "$($entry.Prenom) $($entry.Nom)"
            GivenName           = $entry.Prenom
            Surname             = $entry.Nom
            Title               = $entry.Fonction
            SamAccountName      = $userSamAccountName
            UserPrincipalName   = "$($userSamAccountName)@$($domainName)"
            EmailAddress        = "$($userSamAccountName)@$($domainName)"
            AccountPassword     = $password
            ChangePasswordAtLogon = $false
            Path                = $ouPath
            Enabled             = $true
        }
    
        New-ADUser @userProperties
        if ($entry.Groupe) {
            Add-ADGroupMember -Identity $groupName -Members $userSamAccountName
            Write-Host "Ajout de l'utilisateur $($userSamAccountName) au groupe $($groupName)" -ForegroundColor Green
        }

        Write-Host "Utilisateur $($userSamAccountName) cree dans $ouPath" -ForegroundColor Green
    } catch {
        Write-Host "Erreur lors de la creation de l'utilisateur $($userSamAccountName): $_" -ForegroundColor Red
    }
}

# Demande à l'utilisateur s'il souhaite revenir au menu principal
Read-Host "Appuyez sur une touche pour revenir au menu principal."
exit