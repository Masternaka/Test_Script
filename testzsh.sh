#!/bin/bash

# Vérifier si l'utilisateur est root
if [ "$EUID" -ne 0 ]; then
  echo "Veuillez exécuter ce script en tant que root (ou utilisez sudo)." 
  exit
fi

# Mise à jour des paquets pour Arch Linux
echo "Mise à jour des paquets..."
pacman -Syu --noconfirm

# Installer Zsh
echo "Installation de Zsh..."
pacman -S zsh git curl --noconfirm

# Définir Zsh comme shell par défaut
echo "Définir Zsh comme shell par défaut..."
chsh -s $(which zsh)

# Installer Zinit
echo "Installation de Zinit..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/master/doc/install.sh)"

# Cloner Powerlevel10k
echo "Installation du thème Powerlevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZDOTDIR:-$HOME}/.zsh/powerlevel10k

# Créer le fichier .zshrc avec la configuration complète
echo "Création du fichier .zshrc avec les configurations..."
cat << 'EOF' > ~/.zshrc
# Activer les options Zsh
setopt autocd
setopt correct
setopt nobeep
setopt extended_glob

# Historique
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Chemins
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Alias pratiques
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'

# Activer Zinit (plugin manager)
source "$HOME/.zinit/bin/zinit.zsh"

# Plugins populaires avec Zinit
zinit light romkatv/powerlevel10k        # Thème Powerlevel10k
zinit light zsh-users/zsh-autosuggestions # Suggestions automatiques des commandes
zinit light zsh-users/zsh-syntax-highlighting # Coloration syntaxique
zinit light zsh-users/zsh-completions     # Auto-complétions pour de nombreux outils
zinit light agkozak/zsh-z                # Gestion des répertoires avec z

# Charger Powerlevel10k si installé
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Thème Powerlevel10k prompt
if [[ -r ~/.p10k.zsh ]]; then
  source ~/.p10k.zsh
else
  echo "Powerlevel10k configuration file not found. Run 'p10k configure' to generate it."
fi

# Rendre l'invite plus interactive avec Powerlevel10k
EOF

# Relancer Zsh pour appliquer la configuration
exec zsh

echo "Installation terminée ! Redémarrez le terminal ou exécutez 'exec zsh' pour appliquer les modifications."
