# Installation de promxox en automatique

On utilise une base debian 12 puis on installe proxmox dessus [https://pve.proxmox.com/wiki/Install_Proxmox_VE_on_Debian_12_Bookworm](https://pve.proxmox.com/wiki/Install_Proxmox_VE_on_Debian_12_Bookworm)

Il y a plusieurs fichiers de configuration 

- `preseed.cfg` : le fichier de preseed pour l'installation de debian, il va repondre automatiquement aux questions de l'installateur debian, il va aussi installer le systeme de base et le kernel de debian, il formate le premier disque (sda), il active aussi open-ssh

- `1-proxmox-install.sh` : la premiere partie de l'installation de proxmox, il va preparer le systeme (hostname, reseau, etc) et installer les paquets de base de proxmox

- `2-proxmox-install.sh` : la deuxieme partie de l'installation de proxmox, Il s'execute apres le reboot de la machine, il va installer le kernel de proxmox.

- `2-proxmox.service` : le fichier de service systemd qui va lancer le script `2-proxmox-install.sh` au reboot de la machine, il se lance une fois puis supprime le service pour ne pas le relancer au prochain reboot

> [!CAUTION]
> N'oubliez pas de modifier le fichier `preseed.cfg` pour mettre la bonne adresse ip pour recuperer les scripts bash