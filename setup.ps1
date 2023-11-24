# Setup.ps1

# Menu principal
function ShowMenu {
    Write-Host "
     _        _   _             ____  _               _
    / \   ___| |_(_)_   _____  |  _ \(_)_ __ ___  ___| |_ ___  _ __ _   _
   / _ \ / __| __| \ \ / / _ \ | | | | | '__/ _ \/ __| __/ _ \| '__| | | |
  / ___ \ (__| |_| |\ V /  __/ | |_| | | | |  __/ (__| || (_) | |  | |_| |
 /_/   \_\___|\__|_| \_/ \___| |____/|_|_|  \___|\___|\__\___/|_|   \__, |
                                                                    |___/"
    Write-Host "Auteur: Sorway"
    Write-Host "-----------------------------------"
    Write-Host "Menu de gestion de l'Active Directory"
    Write-Host "[0]: Configuration par défaut du serveur"
    Write-Host "[1]: Installer l'Active Directory"
    Write-Host "[2]: Créer les UO, groupes et importation des utilisateurs en fonction d'un fichier CSV"
    Write-Host "[3]: Création des profils itinérants"
    Write-Host "[4]: Mappage du lecteur réseau personnel"
    Write-Host "[Q]: Quitter"
}

# Boucle du menu
$continue = $true
while ($continue) {
    Clear-Host
    ShowMenu
    $choice = Read-Host "Sélectionnez une option"
    
    switch ($choice) {
        "0" { .\Functions\Server-Configuration.ps1 }
        "1" { .\Functions\InstallAD.ps1 }
        "2" { .\Functions\ImportCSV.ps1 }
        "3" { .\Functions\CreateProfiles.ps1 }
        "4" { .\Functions\MapNetworkDrive.ps1 }
        "Q" { $continue = $false }
        default { Write-Host "Option invalide." }
    }
}