# Set up
Linuxをセットアップする為のシェルスクリプト。
現在、Arch Linux系&Ubuntu系に対応しています。
## ⚠︎注意
このコードは実験段階で不完全 or 構文ミスがあります。
発見した場合はIssuesにお願いします。

# llvm-repo.sh
テスト済み。
debian系のOSにllvmを追加するシェルスクリプトです。
コードの7割くらいは[公式のllvm.sh](https://apt.llvm.org/llvm.sh)から取得したものです。
[llvm公式の方法](https://apt.llvm.org)はapt 2.1.8より非推奨となった方法(apt-keyコマンドを使用)なので、キーリングを/usr/share/keyrings/に配置して、レポと紐づける設定をしています。

# install-softether.sh
テスト済み。
debian系にSoftEther VPNをインストール、systemdの設定をするシェルスクリプトです。
Softether VPNは[ソースコード](https://github.com/SoftEtherVPN/SoftEtherVPN_Stable)をコンパイルして使用します。
インストール設定後は、vpncmdコマンドとvpnserverコマンドが使えるはずです。
