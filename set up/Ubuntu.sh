#/bin/bash

echo "Updating package lists"
sudo apt update > /dev/null

echo "Do you install apt-fast?(y|n)"
read apt_fast
case "$apt_fast" in
    [Yy]*) sudo add-apt-repository ppa:apt-fast/stable && \
    sudo apt -y install apt-fast
    apt="apt-fast" ;;
    *) apt="apt" ;;
esac

echo "Do you want to install packages required build?(y|n)"
read build
case "$build" in
    [Yy]*) echo "Installing packages…"
     sudo "$apt" -y install build-essential cmake clang gcc llvm > /dev/null ;;
esac


echo "Do you want to upgrade packages?(y|n)"
read package_update
case "$package_update" in
    [Yy]*) sudo "$apt" upgrade -y ;;
esac

echo "Do you want to set up sshd?(y|n)"
read sshd_set_up
case "$sshd_set_up" in
    [Yy]*) sudo "$apt" install openssh
    echo "Do you want to set up pubkey auth?"
    read pubkey
    case "$pubkey" in
        [Yy]*) mkdir ~/.ssh
        echo "Please paste public key"
        read auth
        echo "$auth" > ~/.ssh/authorized_keys ;;
    esac
    sudo sed -i 's/"PasswordAuthentication yes"/PasswordAuthentication no' /etc/ssh/sshd_config ;;
esac

echo "Done!"
