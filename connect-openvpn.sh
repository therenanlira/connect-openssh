#!/bin/bash

read -p "
(1) Conectar VPN 
(2) Desconectar VPN 
(3) Checar conexão 
(4) Instalar VPN
(5) Desinstalar VPN

Escolha uma opção: " INPUT
read -p "Informe a URL da VPN: " URL
printf "\n"

pkg_install(){
    DISTRO=$(egrep -i "ID" /etc/*-release)
    VERSION_ID=$(egrep -i "VERSION_ID" /etc/*-release)

    if [[ ! -f /usr/sbin/openvpn ]]; then
        if [[ $DISTRO == *"debian"* ]]; then
            printf "Instalando o pacote openvpn"
            sudo apt update > /dev/null 2>&1 && sudo apt install -y openvpn network-manager-openvpn network-manager-openvpn-gnome > /dev/null 2>&1
        fi
        if [[ $DISTRO == *"fedora"* ]]; then
            printf "Instalando o pacote openvpn"
            sudo dnf install -y openvpn NetworkManager-openvpn NetworkManager-openvpn-gnome > /dev/null 2>&1
        fi
    fi
}

vpn_install(){
    if [[ ! -d ~/.local/bin/vpn ]]; then
        mkdir -p ~/.local/bin/vpn
    fi
    if [[ ! -f ~/.local/bin/vpn ]]; then
        rm ~/.local/vpn.sh > /dev/null
        cp $PWD/vpn.sh ~/.local/vpn.sh > /dev/null
        ln -s ~/.local/vpn.sh ~/.local/bin/vpn > /dev/null
    fi

    VAR1=$(ls | grep ovpn | wc -l)
    if [ $VAR1 -gt "1" ]; then
        printf "Estes são os arquivos de configuração encontrados: \n\n"
        ls | grep ovpn
        printf "\nDigite o nome do arquivo de configuração será instalado: "
        read ARCHIVEOVPN
        rm ~/.local/bin/vpn/$ARCHIVEOVPN > /dev/null 2>&1
        nmcli conn del $(ls $ARCHIVEOVPN | cut -d"." -f 1,2) > /dev/null 2>&1
        cp $ARCHIVEOVPN ~/.local/bin/vpn/
    fi
    if [ $VAR1 -eq "1" ]; then
        ARCHIVEOVPN=$(ls | grep ovpn)
        rm ~/.local/bin/vpn/$ARCHIVEOVPN > /dev/null 2>&1
        nmcli con del $(ls $ARCHIVEOVPN | cut -d"." -f 1,2) > /dev/null
        cp $ARCHIVEOVPN ~/.local/bin/vpn/
    fi
    if [[ $DISTRO == *"fedora"* ]]; then
        if [[ *"$VERSION_ID"* == *"33"* ]]; then
            echo "tls-version-min 1.0" >> ~/.local/bin/vpn/$ARCHIVEOVPN
        fi
    fi
}

vpn_configure(){
    VPNCONF=$(ls $ARCHIVEOVPN | grep ovpn | cut -d"." -f 1,2)
    VPNUSER=$(ls $ARCHIVEOVPN | grep ovpn | awk -F"_" '{ print $1 }')

    if [[ ! -f /etc/NetworkManager/system-connections/"$VPNCONF".nmconnection ]]; then
        printf "Configurando a VPN\n\n"
        sed -i '6s/^/;/' $ARCHIVEOVPN
        sudo nmcli conn import type openvpn file $ARCHIVEOVPN
        nmcli conn modify $VPNCONF ipv4.dns-search $URL
        nmcli conn modify $VPNCONF ipv4.never-default true
        sudo nmcli conn modify $VPNCONF connection.permission "$(echo $USER)"
        sudo sed -i 's/password-flags=./password-flags=1/' /etc/NetworkManager/system-connections/"$VPNCONF".nmconnection
        nmcli conn modify $VPNCONF vpn.user-name $VPNUSER
        printf "Configuração OK\n\n"
    fi
}

vpn_up(){
    VAR1=$(nmcli con show | egrep -i __ssl_vpn_config | awk -F" " '{ print $1 }' | wc -l)
    if [ $VAR1 -gt "1" ]; then
        nmcli con show | egrep -i __ssl_vpn_config | awk -F" " '{ print $1 }'
        printf "\nDigite o nome da conexão para \e[32mconectar: \e[0m"
        read VPNCONN
    else
        VPNCONN=$(nmcli con show | egrep -i __ssl_vpn_config | awk -F" " '{ print $1 }')
    fi
    nmcli conn up $VPNCONN --ask
}

vpn_down(){
    VAR1=$(nmcli con show --active | egrep -i __ssl_vpn_config | awk -F" " '{ print $1 }' | wc -l)
    if [ $VAR1 -gt "1" ]; then
        nmcli conn show --active | grep __ssl_vpn_config | awk -F" " '{ print $1}'
        printf "\nDigite o nome da conexão para \e[31mdesconectar: \e[0m"
        read VPNCONN
    else
        VPNCONN=$(nmcli conn show --active | grep __ssl_vpn_config | awk -F" " '{ print $1}')
    fi
    nmcli conn down $VPNCONN
}

vpn_delete(){
    VAR1=$(nmcli con show | egrep -i __ssl_vpn_config | awk -F" " '{ print $1 }' | wc -l)
    if [ $VAR1 -gt "1" ]; then
        nmcli con show | egrep -i __ssl_vpn_config | awk -F" " '{ print $1 }'
        printf "\nDigite o nome da conexão para \e[33mdeletar: \e[0m"
        read VPNCONN
    else
        VPNCONN=$(nmcli con show | egrep -i __ssl_vpn_config | awk -F" " '{ print $1 }')
    fi
        read -p "Tem certeza que deseja deletar a conexão $VPNCONN? (y/N): " ANSWER
    case $ANSWER in
        y|Y|yes|Yes|YES )
        nmcli conn del $VPNCONN > /dev/null
        rm ~/.local/bin/vpn/$VPNCONN.ovpn > /dev/null
        echo "Conexão deletada";;
        *|n|N|No|NO )
        echo "Conexão não deletada";;
    esac
}

vpn_check(){
    QTDVPNCONN=$(nmcli con show --active | egrep -i __ssl_vpn_config | awk -F" " '{ print $1 }' | wc -l)
    VPNCONN=$(nmcli con show --active | egrep -i __ssl_vpn_config | awk -F" " '{ print $1 }')
    if [[ $QTDVPNCONN -gt "0" ]]; then
        printf "Conexões ativas: \n$VPNCONN \n"
    else
        printf "\e[31mNenhuma conexão ativa \e[0\n"
    fi
}

if [[ $INPUT == "1" ]]; then
    vpn_up
fi

if [[ $INPUT == "2" ]]; then
    vpn_down
fi

if [[ $INPUT == "3" ]]; then
    vpn_check
fi

if [[ $INPUT == "4" ]]; then
    pkg_install
    vpn_install
    vpn_configure
    read -p "Deseja conectar na VPN agora? (Y/n): " ANSWER
    case $ANSWER in
        *|y|Y|yes|Yes|YES )
            vpn_up;;
        n|N|No|NO )
            echo ""
    esac 
    printf "\nAgora você pode iniciar a conexão executando o comando \e[32m"vpn"\e[0m ou acessando as configurações do sistema\n"
fi

if [[ $INPUT == "5" ]]; then
   vpn_delete
fi