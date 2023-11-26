# Configuration de l'adresse IP, de la passerelle, du masque CIDR et du nom d'hôte
Clear-Host

# Fonction pour valider l'adresse IP
function Test-ValidIPAddress {
    param(
        [string]$IPAddress
    )
    
    $ipPattern = "^(\d{1,3}\.){3}\d{1,3}$"
    
    if ($IPAddress -match $ipPattern) {
        return $true
    }
    else {
        return $false
    }
}

# Fonction pour valider le masque CIDR
function Test-ValidSubnetMask {
    param(
        [string]$SubnetMask
    )
    
    $subnetMaskPattern = "^\d{1,2}$"
    
    if ($SubnetMask -match $subnetMaskPattern -and $SubnetMask -ge 0 -and $SubnetMask -le 32) {
        return $true
    }
    else {
        return $false
    }
}

#Saisie d'un nom d'hôte
$Hostname = Read-Host "Nom d'hôte (Actuel: $env:computername)"

# Saisie de l'adresse IP et validation
$IPAddress = Read-Host "Adresse IPv4"
while (-not (Test-ValidIPAddress -IPAddress $IPAddress)) {
    Write-Host "Adresse IP invalide. Veuillez entrer une adresse IP valide." -ForegroundColor Red
    $IPAddress = Read-Host "Adresse IPv4"
}

# Saisie du masque CIDR et validation
$MaskCIDR = Read-Host "Masque CIDR (par exemple, 24 pour 255.255.255.0)"
while (-not (Test-ValidSubnetMask -SubnetMask $MaskCIDR)) {
    Write-Host "Masque CIDR invalide. Veuillez entrer un masque CIDR valide (de 0 à 32)." -ForegroundColor Red
    $MaskCIDR = Read-Host "Adresse IPv4"
}

# Saisie de la passerelle par défaut et validation
$DefaultGateway = Read-Host "Passerelle par défaut"
while (-not (Test-ValidIPAddress -IPAddress $DefaultGateway)) {
    Write-Host "Adresse IP invalide. Veuillez entrer une adresse IP valide."
    $DefaultGateway = Read-Host "Passerelle par défaut" -ForegroundColor Red
}

# Saisie du DNS et validation
$DNSServer = Read-Host "Serveur DNS"
while (-not (Test-ValidIPAddress -IPAddress $DNSServer)) {
    Write-Host "Adresse IP invalide. Veuillez entrer une adresse IP valide." -ForegroundColor Red
    $DNSServer = Read-Host "Serveur DNS"
}

Write-Host "Configuration de l'adresse IP, de la passerelle, du masque CIDR et du nom d'hote..."

New-NetIPAddress -InterfaceIndex (NetAdapter).IfIndex -IPAddress $IPAddress -PrefixLength $MaskCIDR -DefaultGateway $DefaultGateway
Set-DnsClientServerAddress -InterfaceIndex (NetAdapter).IfIndex -ServerAddresses $DNSServer
Rename-Computer -NewName $Hostname

Write-Host "L'adresse IP a ete reglee avec succes sur: $($IPAddress), Masque: $($MaskCIDR), Passerelle par defaut: $($DefaultGateway) et le serveur DNS: $($DNSServer)" -ForegroundColor Green

# Demande à l'utilisateur s'il souhaite redémarrer le serveur
$choice = Read-Host "La configuration necessite un redemarrage du serveur. Souhaitez-vous redemarrer maintenant ? (O/N)"
if ($choice -eq "O") {
    Restart-Computer -Force
} else {
    # Demande à l'utilisateur s'il souhaite revenir au menu principal
    Read-Host "Appuyez sur une touche pour revenir au menu principal."
    exit
}