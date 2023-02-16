
# Connect to OpenVPN

Este repositório contém um script para se conectar a um servidor OpenVPN.

## Requisitos

Antes de executar o script, certifique-se de ter o OpenVPN instalado em sua máquina.

Caso ainda não tenha instalado, você pode instalar o OpenVPN em sua distribuição Linux com o seguinte comando:


  ```bash
  # Debian e Ubuntu
  sudo apt-get update && sudo apt-get install openvpn -y
  
  # Fedora e RHEL
  sudo dnf update && sudo dnf install openvpn -y
  ```

Para instalar o OpenVPN em outras distribuições Linux ou em sistemas operacionais Windows e macOS, consulte a [documentação oficial do OpenVPN](https://openvpn.net/community-resources/installing-openvpn/).

## Como usar

Para conectar a um servidor OpenVPN, execute o seguinte comando no terminal:

  ```bash
  ./connect.sh [ARQUIVO_DE_CONFIGURACAO] [CERTIFICADO] [CHAVE_PRIVADA] [USUARIO] [SENHA]
  ```

Substitua `[ARQUIVO_DE_CONFIGURACAO]` pelo caminho do arquivo de configuração `.ovpn`, `[CERTIFICADO]` pelo caminho do arquivo de certificado `.crt`, `[CHAVE_PRIVADA]` pelo caminho do arquivo de chave privada `.key`, `[USUARIO]` pelo nome de usuário e `[SENHA]` pela senha para se conectar ao servidor OpenVPN.

O arquivo de configuração é obrigatório. Os demais parâmetros são opcionais. Caso não seja fornecido um parâmetro, o script solicitará que você digite o caminho do arquivo ou a informação em questão.

Por exemplo, para se conectar a um servidor OpenVPN com um arquivo de configuração `vpn-config.ovpn`, execute o seguinte comando:

  ```bash
  ./connect.sh vpn-config.ovpn
  ```

O script irá solicitar os demais parâmetros que não foram fornecidos na linha de comando.

### Opções adicionais

O script oferece algumas opções adicionais:

-   `-h` ou `--help`: exibe uma mensagem de ajuda.
-   `-v` ou `--version`: exibe a versão do script.
-   `-c` ou `--config`: exibe o conteúdo do arquivo de configuração sem se conectar ao servidor.
-   `-k` ou `--keepalive`: define o intervalo em segundos para enviar pacotes Keepalive. O valor padrão é `10`.

Por exemplo, para exibir o conteúdo do arquivo de configuração `vpn-config.ovpn` sem se conectar ao servidor, execute o seguinte comando:

  ```bash
  ./connect.sh vpn-config.ovpn -c
  ```

## Contribuindo

Se você encontrar um bug ou tiver alguma sugestão para o script, fique à vontade para criar uma issue ou um pull request neste repositório. Sua contribuição é muito bem-vinda!
