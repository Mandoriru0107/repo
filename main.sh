#/usr/bin

sudo pacman -Syy
sudo pacman -Syu
mkdir ./backups
echo "Do you want to install packages required for build?(y|n)"
read install
echo "Do you want to set ssh?(y|n)"
read ssh
if [ $ssh == "y" ] || [ $ssh == "Y" ] || [ $ssh == "yes" ] || [ $ssh == "Yes" ]; then
    echo "Do you want to set ssh auth(publickey)(y|n)"   
    read auth
fi
echo "Do you want to change locale?(y|n)"
read locale

if [ $install == "y" ] || [ $install == "Y" ] || [ $install == "yes" ] || [ $install == "Yes" ]; then
    sudo pacman -S base-devel git wget vim cmake llvm clang go htop ufw
    git clone https://aur.archlinux.org/yay.git &&cd yay &&makepkg -si &&cd .. &&rm -rf yay
fi

if [ ! -d ~/.ssh ]; then
    mkdir ~/.ssh
    sudo chmod 700 ~/.ssh
fi

if [ $ssh == "y" ] || [ $ssh == "Y" ] || [ $ssh == "yes" ] || [ $ssh == "Yes" ]; then
    sudo pacman -S openssh
fi

if [ $auth == "y" ] || [ $auth == "Y" ] || [ $auth == "yes" ] || [ $auth == "Yes" ]; then
    sudo pacman -S openssh
    echo "Please paste public key(SSH):"
    read key
    echo $key >> ~/.ssh/authorized_keys
    sudo chmod 600 ~/.ssh/authorized_keys
    sudo cp -r /etc/ssh/sshd_config ./backups/
    sudo sed -e 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    sudo systemctl restart sshd
fi

if [ $auth == "y" ] || [ $auth == "Y" ] || [ $auth == "yes" ] || [ $auth == "Yes" ]; then
    sudo cp /etc/locale.gen ./backups/
    sudo sed -e 's/#ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/' /etc/locale.gen
    sudo locale-gen
    sudo localectl set-locale LANG=ja_JP.UTF-8
fi

sudo ufw allow 22/tcp
sudo ufw logging off
sudo ufw enable
echo "Done"
