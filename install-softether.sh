#/bin/bash

echo "このシェルスクリプトはSoftetherをビルドして、インストール、systemdに登録するように設定しています。"
echo "OSはdebian系を想定しています。詳しくはREADME.mdを見てください。"
echo "実行しますか？(y|n)"
read yn
case '@yn' in
    [yY]*) echo "実行します…" ;;
    *) echo "中止します。"
    exit 1 ;;
esac

sudo apt -y install build-essential libreadline-dev libssl-dev libncurses-dev libz-dev make gcc git
git clone https://github.com/SoftEtherVPN/SoftEtherVPN_Stable
cd SoftEtherVPN_Stable
./configure
make -j2
sudo mkdir /usr/local/vpnserver
sudo cp -rp bin/vpnserver/vpnserver /usr/local/vpnserver/
sudo cp -rp bin/vpncmd/vpncmd /usr/local/vpnserver/
sudo cp -rp bin/vpncmd/hamcore.se2 /usr/local/vpnserver/

#コマンドの設定
echo "#bin/bash
sudo /usr/local/vpnserver/vpncmd" > ./vpncmd
sudo chmod +x vpncmd
sudo mv vpncmd /usr/local/bin/
echo "#/bin/bash
sudo /usr/local/vpnserver/vpnserver" > ./vpnserver
sudo chmod +x vpnserver
sudo mv vpnserver /usr/local/bin/vpnserver

#systemdの設定
echo "[Unit]
Description=SoftEther VPN Server
After=network.target network-online.target

[Service]
ExecStart=/usr/local/vpnserver/vpnserver start
ExecStop=/usr/local/vpnserver/vpnserver stop
Type=forking
RestartSec=3s

[Install]
WantedBy=multi-user.target" > ./vpnserver.Service
sudo mv vpnserver.service /etc/systemd/system/
sudo systemctl enable vpnserver.service --now
