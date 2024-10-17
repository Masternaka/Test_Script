#!/bin/bash

# Vérification des droits root
if [ "$EUID" -ne 0 ]; then
  echo "Veuillez exécuter ce script en tant que root."
  exit 1
fi

# Mise à jour du système
echo "Mise à jour du système..."
pacman -Syu --noconfirm

# Installation de Zsh
echo "Installation de Zsh..."
pacman -S zsh --noconfirm

# Définir Zsh comme shell par défaut
echo "Définir Zsh comme shell par défaut..."
chsh -s /bin/zsh

# Installation de git si non installé (nécessaire pour Oh My Zsh)
if ! command -v git &> /dev/null; then
    echo "Git n'est pas installé, installation de git..."
    pacman -S git --noconfirm
fi

# Installation de curl si non installé (nécessaire pour installer Oh My Zsh)
if ! command -v curl &> /dev/null; then
    echo "Curl n'est pas installé, installation de curl..."
    pacman -S curl --noconfirm
fi

# Installation de Oh My Zsh
echo "Installation de Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || echo "Oh My Zsh est déjà installé."

# Vérifier si le fichier .zshrc existe, sinon le créer
if [ ! -f "$HOME/.zshrc" ]; then
    echo "Le fichier .zshrc n'existe pas, création d'un nouveau .zshrc..."
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
fi

# Installation de Powerlevel10k
echo "Installation de Powerlevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Configuration du thème Powerlevel10k dans le fichier .zshrc
echo "Configuration de Powerlevel10k comme thème..."
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# Installation des polices recommandées pour Powerlevel10k (nerd fonts)
echo "Installation des polices Nerd Fonts..."
pacman -S ttf-meslo-nerd-font-powerlevel10k --noconfirm

# Fin du script
echo "Installation terminée. Veuillez redémarrer votre terminal ou exécuter 'zsh' pour appliquer les changements."
