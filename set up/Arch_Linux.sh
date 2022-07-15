#/usr/bin

sudo pacman -Syy
sudo pacman -Syu
mkdir ./backups
echo "Do you want to install packages required for build?(y|n)"
read install
echo "Do you want to set sshd?(y|n)"
read ssh
case "$ssh" in
    [yY]*) echo "Do you want to set ssh auth?(publickey)(y|n)"   
    read auth;;
esac
case "$ssh" in
    [yY]*) echo "Do you want to change ssh port?(y|n)"
    read sshdport;;
esac

echo "Do you want to change locale?(y|n)"
read locale

case "$install" in
    [yY]*)sudo pacman -S base-devel git wget vim cmake llvm clang go htop ufw
    git clone https://aur.archlinux.org/yay.git &&cd yay &&makepkg -si &&cd .. &&rm -rf yay ;;
    *) echo "Skip install packages" ;;
esac

if [ ! -d ~/.ssh ]; then
    mkdir ~/.ssh
    sudo chmod 700 ~/.ssh
fi

case "$ssh" in
    [yY]*) sudo pacman -S openssh ;;
    *) echo "Skip install openssh" ;;
esac

case "$auth" in
    [yY]*) echo "Please paste public key(SSH):"
    read key
    echo $key >> ~/.ssh/authorized_keys
    sudo chmod 600 ~/.ssh/authorized_keys
    sudo cp -r /etc/ssh/sshd_config ./backups/
    passwdauth = "`sudo grep PasswordAuthentication /etc/ssh/sshd_config`"
    sudo sed -i 's/"$passwdauth"/PasswordAuthentication no/' /etc/ssh/sshd_config
    sudo systemctl restart sshd ;;
    *) echo "Skip sshd settings(public key)" ;;
esac

case "$locale" in
    [yY]*) sudo cp /etc/locale.gen ./backups/
    sudo sed -i 's/#ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/' /etc/locale.gen
    sudo locale-gen
    sudo localectl set-locale LANG=ja_JP.UTF-8 ;;
    *) echo "Skip locale settings" ;;
esac

case "$sshdport" in
    [yY]*) echo "Please input sshd port number"
    read ssh_port;;
esac

sudo ufw allow ${ssh_port:=22}/tcp
sudo ufw logging off
sudo ufw reload
sudo ufw enable
echo "Done"
