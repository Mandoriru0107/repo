#/bin/bash

DISTRO=$(lsb_release -is)
VERSION=$(lsb_release -sr)
DIST_VERSION="${DISTRO}_${VERSION}"

case "$DIST_VERSION" in
    Debian_9* )       REPO_NAME="http://apt.llvm.org/stretch/  llvm-toolchain-stretch main" ;;
    Debian_10* )      REPO_NAME="http://apt.llvm.org/buster/   llvm-toolchain-buster  main" ;;
    Debian_11* )      REPO_NAME="http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye  main" ;;
    Debian_unstable ) REPO_NAME="http://apt.llvm.org/unstable/ llvm-toolchain         main" ;;
    Debian_testing )  REPO_NAME="http://apt.llvm.org/unstable/ llvm-toolchain         main" ;;

    Ubuntu_16.04 )    REPO_NAME="http://apt.llvm.org/xenial/   llvm-toolchain-xenial  main" ;;
    Ubuntu_18.04 )    REPO_NAME="http://apt.llvm.org/bionic/   llvm-toolchain-bionic  main" ;;
    Ubuntu_18.10 )    REPO_NAME="http://apt.llvm.org/cosmic/   llvm-toolchain-cosmic  main" ;;
    Ubuntu_19.04 )    REPO_NAME="http://apt.llvm.org/disco/    llvm-toolchain-disco   main" ;;
    Ubuntu_19.10 )   REPO_NAME="http://apt.llvm.org/eoan/      llvm-toolchain-eoan    main" ;;
    Ubuntu_20.04 )   REPO_NAME="http://apt.llvm.org/focal/     llvm-toolchain-focal   main" ;;
    Ubuntu_20.10 )   REPO_NAME="http://apt.llvm.org/groovy/    llvm-toolchain-groovy  main" ;;
    Ubuntu_21.04 )   REPO_NAME="http://apt.llvm.org/hirsute/   llvm-toolchain-hirsute main" ;;
    Ubuntu_21.10 )   REPO_NAME="http://apt.llvm.org/impish/    llvm-toolchain-impish main" ;;
    Ubuntu_22.04 )   REPO_NAME="http://apt.llvm.org/jammy/     llvm-toolchain-jammy  main" ;;

    Linuxmint_19* )  REPO_NAME="http://apt.llvm.org/bionic/   llvm-toolchain-bionic  main" ;;
    Linuxmint_20* )  REPO_NAME="http://apt.llvm.org/focal/    llvm-toolchain-focal   main" ;;

    * )
    echo "お使いのOSにこのシェルスクリプトは対応していません。"
esac

wget https://apt.llvm.org/llvm-snapshot.gpg.key
gpg --no-default-keyring --keyring ./llvm-snapshot.gpg --import llvm-snapshot.gpg.key
sudo mv llvm-snapshot.gpg /usr/share/keyrings/
rm -f llvm-snapshot.gpg~ llvm-snapshot.gpg.key
echo "deb [signed-by=/usr/share/keyrings/llvm-snapshot.gpg] "$REPO_NAME"" | sudo tee /etc/apt/sources.list.d/llvm.list > /dev/null
echo "Done"
echo "sudo apt updateを実行することを推奨します。"
