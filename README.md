# Installation automatique de proxmox
Ce repo ressource tous les scripts et services nécessaires à l'installation automatique de proxmox sur un serveur baremetal ou virtuel.

> [!CAUTION]
>
> Pour le moment (14/04/2025) 
> Seule la partie `netboot` est pour le moment necessaire
> la partie `kea` était un test mais pour le moment dnsmasq (dans le script de netboot) est suffisant.
> la partie `http-server` n'est pour le moment qu'un prototype, dans le futur c'est normalement `"application-controler"` qui hebergera et servira ces fichiers.

## Instuctions d'installation

### 1. Netboot

Dans un premier temps, il nous faut un serveur DHCP et TFTP pour le netboot de proxmox.
C'est ce que va installer le script `netboot/install-netboot.sh`.

Il va ensuite récuperer le bootloader (de netboot.xyz) depuis le site distant (pour avoir la derniere version) et le `netboot/menu.ipxe` (qui est le menu personnalisé pxe)

> [!IMPORTANT]
>
> Pour le moment le réseau sera `192.168.50.0/24`, le serveur aura `192.168.50.254/24`, c'est pour le moment écrit en dur comme ça dans les scripts (voir `http-server/preseed.cfg`), on verra plus tard pour le rendre dynamique (DNS ? ou autre ?)

Suite à l'exécution du script, il sera possible sur n'importe qu'elle machine sur le même réseau d'installer proxmox, et au bout de quelques temps (~10min), un noeud proxmox sera disponible


### 2. HTTP-server

Pour le moment il n'y a pas d'application controler, donc on va l'émuler avec python.
```bash
python3 -m http.server -p 8081 -d ./http-server
```



