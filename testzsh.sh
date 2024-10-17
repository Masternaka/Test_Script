#!/bin/bash

# Vérification des droits root
if [ "$EUID" -ne 0 ]; then
  echo "Veuillez exécuter ce script en tant que root."
  exit 1
fi

# Définir le répertoire home de l'utilisateur courant
USER_HOME=$(eval echo "~$SUDO_USER")

# Mise à jour du système
echo "Mise à jour du système..."
pacman -Syu --noconfirm

# Installation de Zsh
echo "Installation de Zsh..."
pacman -S zsh --noconfirm

# Définir Zsh comme shell par défaut
echo "Définir Zsh comme shell par défaut pour l'utilisateur $SUDO_USER..."
chsh -s /bin/zsh $SUDO_USER

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

# Installation de Oh My Zsh dans le répertoire utilisateur
echo "Installation de Oh My Zsh pour l'utilisateur $SUDO_USER..."
sudo -u $SUDO_USER sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || echo "Oh My Zsh est déjà installé."

# Vérifier si le fichier .zshrc existe dans le répertoire home, sinon le créer
if [ ! -f "$USER_HOME/.zshrc" ]; then
    echo "Le fichier .zshrc n'existe pas, création d'un nouveau .zshrc dans $USER_HOME..."
    cp $USER_HOME/.oh-my-zsh/templates/zshrc.zsh-template $USER_HOME/.zshrc
    chown $SUDO_USER:$SUDO_USER $USER_HOME/.zshrc
fi

# Installation de Powerlevel10k
echo "Installation de Powerlevel10k..."
sudo -u $SUDO_USER git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$USER_HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Configuration du thème Powerlevel10k dans le fichier .zshrc
echo "Configuration de Powerlevel10k comme thème dans $USER_HOME/.zshrc..."
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' $USER_HOME/.zshrc

# Installation des polices recommandées pour Powerlevel10k (nerd fonts)
echo "Installation des polices Nerd Fonts..."
pacman -S ttf-meslo-nerd --noconfirm

# Fin du script
echo "Installation terminée. Veuillez redémarrer votre terminal ou exécuter 'zsh' pour appliquer les changements."
