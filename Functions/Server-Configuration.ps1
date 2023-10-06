# Configuration de l'adresse IP, de la passerelle, du masque CIDR et du nom d'hôte
Clear-Host

$Hostname = Read-Host "Nom d'hôte (Actuel: $env:computername)"
$IPAddress = Read-Host "Adresse IPv4"
$MaskCIDR = Read-Host "Masque (Notation CIDR)"
$DefaultGateway = Read-Host "Passerelle par défaut"
$DNSServer = Read-Host "Serveur DNS"

Write-Host "Configuration de l'adresse IP, de la passerelle, du masque CIDR et du nom d'hôte..."

New-NetIPAddress -InterfaceIndex (NetAdapter).IfIndex -IPAddress $IPAddress -PrefixLength $MaskCIDR -DefaultGateway $DefaultGateway
Set-DnsClientServerAddress -InterfaceIndex (NetAdapter).IfIndex -ServerAddresses $DNSServer
Rename-Computer -NewName $Hostname

Write-Host "L'adresse IP a été réglée avec succès sur: $($IPAddress), Masque: $($MaskCIDR), Passerelle par défaut: $($DefaultGateway) et le serveur DNS: $($DNSServer)" -ForegroundColor Green

# Demande à l'utilisateur s'il souhaite redémarrer le serveur
$choice = Read-Host "La configuration nécessite un redémarrage du serveur. Souhaitez-vous redémarrer maintenant ? (O/N)"
if ($choice -eq "O") {
    Restart-Computer -Force
} else {
    # Demande à l'utilisateur s'il souhaite revenir au menu principal
    $returnChoice = Read-Host "Appuyez sur une touche pour revenir au menu principal ? (O/N)"
    exit
}