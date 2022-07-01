#/usr/bin

sudo pacman -Syy
sudo pacman -Syu
echo "Do you want to install packages required for build?(y|n)"
read install
if [ $install == "y" ] || [ $install == "Y" ] || [ $install == "yes" ] || [ $install == "Yes" ]; then
    sudo pacman -S base-devel git wget vim cmake llvm clang go htop ufw
    git clone https://aur.archlinux.org/yay.git &&cd yay &&makepkg -si &&cd .. &&rm -rf yay
fi
if [ ! -d ~/.ssh ]; then
    mkdir ~/.ssh
    sudo chmod 700 ~/.ssh
fi
echo "Do you want to set ssh auth?(y|n)"
read auth

if [ $auth == "y" ] || [ $auth == "Y" ] || [ $auth == "yes" ] || [ $auth == "Yes" ]; then
    sudo pacman -S openssh
    echo "Please paste public key(SSH):"
    read key
    echo $key >> ~/.ssh/authorized_keys
    sudo chmod 600 ~/.ssh/authorized_keys
    sudo cp -r /etc/ssh/sshd_config /etc/ssh/sshd_config.bk
    sudo sed -e 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    sudo systemctl restart sshd
fi
sudo ufw allow 22/tcp
sudo ufw logging off
sudo ufw enable
echo "Done"
