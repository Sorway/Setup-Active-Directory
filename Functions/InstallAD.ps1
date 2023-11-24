# Installation de l'Active Directory et du serveur DNS
Clear-Host

if (Get-WindowsFeature -Name AD-Domain-Services -ErrorAction SilentlyContinue) {
    if ((Get-WindowsFeature -Name AD-Domain-Services).Installed) { 
        Write-Host "L'Active Directory est déjà installé." -ForegroundColor Red
        Read-Host "Appuyez sur une touche pour continuer."
        exit
    }
}

$DomainName = Read-Host "Nom de domaine (exemple: google.com)"
$NetbiosName = Read-Host "Nom Netbios (exemple: GOOGLE)"

Write-Host "Installation de l'Active Directory et du serveur DNS..."

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

$ForestConfiguration = @{
    '-DatabasePath'= 'C:\Windows\NTDS';
    '-DomainName' = $DomainName;
    '-DomainNetbiosName' = $NetbiosName;
    '-InstallDns' = $true;
    '-LogPath' = 'C:\Windows\NTDS';
    '-NoRebootOnCompletion' = $false;
    '-SysvolPath' = 'C:\Windows\SYSVOL';
    '-Force' = $true;
    '-CreateDnsDelegation' = $false 
}

Install-ADDSForest @ForestConfiguration

Write-Host "Installation terminée."

# Demande à l'utilisateur s'il souhaite redémarrer le serveur
$choice = Read-Host "La configuration nécessite un redémarrage du serveur. Souhaitez-vous redémarrer maintenant ? (O/N)"
if ($choice -eq "O") {
    Restart-Computer -Force
} else {
    # Demande à l'utilisateur s'il souhaite revenir au menu principal
    Read-Host "Appuyez sur une touche pour revenir au menu principal ? (O/N)"
    exit
}