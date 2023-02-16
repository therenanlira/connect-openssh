# Connect OpenVPN

Este repositório contém um script Bash para automatizar a conexão ao OpenVPN. O script requer um arquivo `.ovpn` com as configurações da conexão.

## Requisitos

- Linux
- openvpn

## Uso

1. Clone o repositório: `git clone https://github.com/therenanlira/connect-openvpn.git`
2. Entre no diretório: `cd connect-openvpn`
3. Copie o arquivo `.ovpn` para o diretório: `cp /caminho/para/arquivo.ovpn .`
4. Torne o arquivo executável: `chmod +x connect-openvpn.sh`
5. Execute o script: `./connect-openvpn.sh`

O script irá solicitar o nome do arquivo `.ovpn` e o nome do usuário do OpenVPN. Em seguida, a conexão será estabelecida.

## Licença

Este projeto está licenciado sob a licença MIT. Consulte o arquivo LICENSE para obter mais informações.
