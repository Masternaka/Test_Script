#!/bin/bash

# Vérifier si l'utilisateur est root
if [ "$EUID" -ne 0 ]; then
  echo "Veuillez exécuter ce script en tant que root (ou utilisez sudo)." 
  exit
fi

# Mettre à jour les paquets
echo "Mise à jour des paquets..."
pacman -Syu --noconfirm

# Installer Zsh
echo "Installation de Zsh..."
pacman -S zsh --noconfirm

# Définir Zsh comme shell par défaut
echo "Définir Zsh comme shell par défaut..."
chsh -s $(which zsh)

# Installer Zinit
echo "Installation de Zinit..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/master/doc/install.sh)"

# Cloner le thème Powerlevel10k
echo "Installation du thème Powerlevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZDOTDIR:-$HOME}/.zsh/powerlevel10k

# Ajouter Powerlevel10k et Zinit à .zshrc
echo "Configuration de Zsh..."
cat << 'EOF' >> ~/.zshrc

# Source Zinit
source ~/.zshrc

# Installer et charger des plugins avec Zinit
zinit light romkatv/powerlevel10k
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions

# Charger le thème Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF

# Relancer Zsh pour que les changements prennent effet
exec zsh

echo "Installation terminée ! Redémarrez le terminal ou exécutez 'exec zsh'."
