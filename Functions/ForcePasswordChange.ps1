# Ce script PowerShell récupère tous les utilisateurs de l'annuaire Active Directory
# et active l'option ChangePasswordAtLogon pour chacun d'eux, ce qui force chaque utilisateur
# à changer son mot de passe lors de la prochaine connexion.
Clear-Host 

# Demander confirmation à l'utilisateur
$confirmation = Read-Host "Voulez-vous vraiment forcer le changement du mot de passe pour tous les utilisateurs (option ChangePasswordAtLogon) ? (O/N)"

# Vérifier la réponse de l'utilisateur
if ($confirmation -eq "O") {
    # Récupérer toutes les UOs contenant des utilisateurs
    $organizationalUnits = Get-ADOrganizationalUnit -Filter 'Name -like "*"' -SearchScope OneLevel | Where-Object { $_.DistinguishedName -notlike '*OU=Domain Controllers*' }

    foreach ($organizationalUnit in $organizationalUnits) {
        # Récupérer tous les utilisateurs de l'OU actuelle
        $users = Get-ADUser -Filter * -SearchBase $organizationalUnit.DistinguishedName
    
        foreach ($user in $users) {
            Set-ADUser -Identity $user -ChangePasswordAtLogon:$True
            Write-Host "L'option ChangePasswordAtLogon a ete activee pour l'utilisateur $($user.SamAccountName)." -ForegroundColor Green
        }
    }
} else {
    Write-Host "Opération annulee. Aucune modification n'a ete effectuee." -ForegroundColor Red
}

# Demande à l'utilisateur s'il souhaite revenir au menu principal
Read-Host "Appuyez sur une touche pour revenir au menu principal."
exit