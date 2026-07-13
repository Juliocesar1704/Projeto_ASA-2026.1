# 🌐 NexusTech - Provedor de Serviços de Internet (ISP) em Microserviços
## 🚀 Projeto Final de Administração de Sistemas Abertos (ASA)

Este repositório contém a especificação e implementação completas da infraestrutura de rede para o provedor de serviços de internet **NexusTech** e de seus três clientes corporativos. Toda a arquitetura foi desenhada usando a filosofia de **Infraestrutura como Código (IaC)** com **Docker** e **Docker Compose**, garantindo o isolamento de rede, resiliência e alta modularidade.

---

## 🛠️ Arquitetura Geral do Sistema

A infraestrutura é subdividida em 4 domínios de rede distintos rodando sob o mesmo host/servidor virtual, compostos por **17 contêineres Docker** no total:

```
                            +----------------------------------------+
                            |            HOST PRINCIPAL              |
                            |                                        |
                            |             Rede: isp_net              |
                            |                                        |
 +--------------------------+--+        +--------------------------+ |
 |   Portas: 25/587/993     |  |        |      Portas: 80/443      | |
 |   [Serviço de Correio]   |  |        |     [Proxy Reverso]      | |
 |        email-ISP         |  |        |         proxyISP         | |
 +--------------------------+  |        +------------+-------------+ |
                               |                     |               |
 +-----------------------------+                     |               |
 |         Rede: DNS           |                     |               |
 |       [PowerDNS BIND]       |<--------------------+ (Roteamento   |
 |           DNSISP            |                       baseado no    |
 +-----------------------------+                       Header Host)  |
                                                                     |
                                                                     |
                   +----------------------------------+----------------------------------+
                   |                                  |                                  |
                   v                                  v                                  v
     +---------------------------+     +---------------------------+     +---------------------------+
     |    Rede: cliente1_net     |     |    Rede: cliente2_net     |     |    Rede: cliente3_net     |
     |                           |     |                           |     |                           |
     | +-----------------------+ |     | +-----------------------+ |     | +-----------------------+ |
     | |      Proxy Local      | |     | |      Proxy Local      | |     | |      Proxy Local      | |
     | |    proxy-cliente1     | |     | |       proxy-c2        | |     | |    proxy-cliente3     | |
     | +-----------+-----------+ |     | +-----------+-----------+ |     | +-----------+-----------+ |
     |             |             |     |             |             |     |             |             |
     |   +---------+---------+   |     |        +----+----+        |     |        +----+----+        |
     |   v         v         v   |     |        v         v        |     |        v         v        |
     | [Portal] [Hotsite] [Sign] |     |     [Portal]   [CMS]      |     |     [Portal]   [CMS]      |
     |                           |     |             (WordPress)   |     |             (WordPress)   |
     +---------------------------+     +---------------------------+     +---------------------------+
```

---

## 📦 Detalhamento de Serviços por Domínio

### 1. Domínio NexusTech ISP (Rede `isp_net`)

Responsável pela gerência central de tráfego, resolução de nomes, portal corporativo e envio/recebimento de e-mails.

*   **`DNSISP` (PowerDNS + BIND backend)**:
    *   **Função**: Servidor de nomes autoritativo para todo o ambiente.
    *   **Portas**: `53/tcp` e `53/udp`.
    *   **Funcionamento**: Carrega as zonas declarativas de domínio via backend BIND através do arquivo principal `named.conf`. Ele responde de forma autoritativa para `nexustech.com.br`, `salesfilho.com.br`, `cliente2.com.br` e `cliente3.com.br`, resolvendo todos os subdomínios para o IP virtual do laboratório.
*   **`proxyISP` (Nginx Gateway)**:
    *   **Função**: Ponto de entrada único para requisições HTTP e HTTPS externas.
    *   **Portas**: `80` (redireciona para HTTPS) e `443` (HTTPS seguro).
    *   **Funcionamento**: Inicia e gera dinamicamente um certificado SSL autoassinado multodomínio (SAN) cobrindo todos os clientes corporativos caso não haja um certificado emitido. Ele lê os cabeçalhos `Host` de cada requisição e repassa o tráfego de forma reversa para o portal ISP correspondente ou para as redes internas dos clientes.
*   **`site-ISP` (Portal NexusTech)**:
    *   **Função**: Site corporativo do provedor de internet.
    *   **Funcionamento**: Servidor Nginx que entrega as páginas estáticas institucionais da NexusTech de forma otimizada.
*   **`email-ISP` (Debian + Postfix + Dovecot)**:
    *   **Função**: Servidor de e-mails corporativo.
    *   **Portas**: `25` (SMTP), `587` (SMTP Submission), `993` (IMAPS).
    *   **Funcionamento**: Configurado com caixas de correio virtuais armazenadas em `/var/mail/vhosts`. O Postfix atua como MTA processando conexões SMTP/STARTTLS na porta 587, enquanto o Dovecot atua como MDA fornecendo protocolo IMAP criptografado com TLSv1.3 na porta 993. A autenticação de contas é feita através do arquivo `/etc/dovecot/users`.
*   **`webmailISP` (Nextcloud Frontend)**:
    *   **Função**: Portal webmail para leitura e gerenciamento de caixas de correio.
    *   **Funcionamento**: Servidor Apache que executa a aplicação Nextcloud, integrada com o cliente de e-mail e persistida em banco de dados.
*   **`nextcloud-db` (MariaDB)**:
    *   **Função**: Banco de dados relacional para a aplicação do Nextcloud/Webmail.
    *   **Funcionamento**: Instância MariaDB isolada com checagem de saúde (`healthcheck`) ativa para garantir a integridade da conexão.

---

### 2. Domínio Cliente 1 - `salesfilho.com.br` (Redes `isp_net` e `cliente1_net`)

Infraestrutura dedicada ao Cliente 1, contendo portais estáticos e um sistema completo de assinatura de documentos digitais.

*   **`proxy-cliente1` (Nginx)**:
    *   **Função**: Roteamento interno e isolamento do Cliente 1.
    *   **Funcionamento**: Recebe o tráfego vindo da rede central `isp_net` e repassa para a rede privada `cliente1_net`. Possui resolução dinâmica de DNS para evitar falhas se os containers internos estiverem offline.
*   **`portal-cliente1`**: Site institucional estático básico do cliente.
*   **`hotsite-cliente1`**: Landing page para campanhas promocionais do cliente.
*   **`sign-app-cliente1`**: Interface SPA (Single Page Application) que permite aos usuários fazer login e assinar documentos.
*   **`sign-api-cliente1`**: Backend REST API em Node.js/Python que gerencia o fluxo de assinaturas e se conecta ao banco de dados.
*   **`sign-db-cliente1` (PostgreSQL)**: Armazena dados de usuários, arquivos PDF e logs de auditoria de assinaturas.

---

### 3. Domínio Cliente 2 - `cliente2.com.br` e Cliente 3 - `cliente3.com.br` (Redes privadas correspondentes)

Portais estáticos institucionais associados a um sistema dinâmico de Gestão de Conteúdo (CMS).

*   **`proxy-cliente2` / `proxy-cliente3` (Nginx)**: Roteadores de gateway locais que recebem tráfego externo e separam as rotas para o portal estático corporativo ou para o CMS do WordPress.
*   **`portal-cliente2` / `portal-cliente3`**: Sites estáticos das empresas.
*   **`cms-app-cliente2` / `cms-app-cliente3` (WordPress)**:
    *   **Função**: Portal de notícias e blogs dinâmicos.
    *   **Funcionamento**: Contêiner oficial do WordPress configurado com persistência de volumes e comunicação direta com o banco de dados dedicado.
*   **`cms-db-cliente2` / `cms-db-cliente3` (MariaDB)**: Bancos de dados dedicados para cada WordPress, isolados individualmente nas redes dos respectivos clientes.

---

## 🔒 Segurança e Isolamento de Rede

1.  **Redes Virtuais Isoladas**:
    *   `isp_net`: Conecta todos os contêineres principais do provedor e as interfaces públicas dos proxies dos clientes (`proxy-cliente1`, `proxy-cliente2`, `proxy-cliente3`).
    *   `cliente1_net`, `cliente2_net`, `cliente3_net`: Redes bridge completamente independentes e privadas. Um contêiner na rede `cliente1_net` **não consegue** se comunicar nem mesmo pingar nenhum contêiner na rede `cliente2_net` ou `cliente3_net`.
2.  **Criptografia SSL/TLS no Nginx**:
    *   Todo o tráfego HTTP porta 80 é automaticamente redirecionado com cabeçalho `301 Moved Permanently` para a porta HTTPS 443. Os handshakes suportam exclusivamente protocolos modernos e seguros: **TLSv1.2 e TLSv1.3**.
3.  **Segurança Let's Encrypt**:
    *   O script auxiliar `letsencrypt-helper.sh` sob `ISP/proxy/` permite solicitar certificados públicos válidos da Let's Encrypt para todos os domínios mapeados caso a infraestrutura seja implantada em um servidor real com IP público exposto.
4.  **Criptografia no E-mail (IMAPS & SMTP Submission)**:
    *   Dovecot e Postfix utilizam o padrão TLSv1.3 com as cifras recomendadas de mercado. Conexões sem criptografia na porta IMAP comum são rejeitadas, obrigando a utilização de canais seguros.

---

## 🔄 Fluxo de Resolução e Roteamento de Pacotes

Ao acessar o domínio `http://cms.cliente2.com.br` no navegador:

```
Navegador --(Porta 53)--> DNSISP (PowerDNS) -> Retorna o IP 10.25.2.190
Navegador --(Porta 80)--> proxyISP (Gateway ISP) -> Redireciona 301 para https://cms.cliente2.com.br
Navegador --(Porta 443)--> proxyISP (Gateway ISP) -> Analisa Header Host: cms.cliente2.com.br
   |
   +---(Encaminha via rede central isp_net)---> proxy-cliente2 (Proxy do Cliente 2)
                                                     |
                                                     +---(Encaminha via cliente2_net)---> cms-app-cliente2 (WordPress)
```

---

## 🚀 Como Executar e Validar o Ambiente

### Pré-requisitos
*   Docker & Docker Compose (v2 ou superior) instalados na máquina.
*   Portas `80`, `443`, `53` (TCP/UDP), `25`, `587` e `993` desocupadas no host.

### 1. Inicializar toda a Infraestrutura
A orquestração de múltiplos arquivos `compose.yaml` permite subir todos os contêineres e redes isoladas de uma única vez. Execute o comando a partir do diretório raiz do projeto:

```bash
docker compose -f ISP/compose.yaml \
               -f ISP/clientes/cliente1/compose.yaml \
               -f ISP/clientes/cliente2/compose.yaml \
               -f ISP/clientes/cliente3/compose.yaml \
               up -d --build
```

### 2. Validação da Resolução de Nomes (DNS)
Aponte suas consultas DNS locais para o IP do seu host (127.0.0.1) para testar o PowerDNS:
```powershell
nslookup nexustech.com.br 127.0.0.1
nslookup salesfilho.com.br 127.0.0.1
nslookup cms.cliente2.com.br 127.0.0.1
nslookup cms.cliente3.com.br 127.0.0.1
```

### 3. Validação do Tráfego HTTPS e Proxy
Execute requisições curl forçando os cabeçalhos de host para simular o redirecionamento de DNS:
```powershell
# Teste de redirecionamento HTTP -> HTTPS
curl.exe -s -I -H "Host: nexustech.com.br" http://localhost

# Teste do Portal NexusTech
curl.exe -s -k -I -H "Host: nexustech.com.br" https://localhost

# Teste do WordPress do Cliente 2
curl.exe -s -k -I -H "Host: cms.cliente2.com.br" https://localhost
```

### 4. Validação de Criptografia no E-mail (Handshake TLSv1.3)
Utilize o utilitário `s_client` do OpenSSL embutido para certificar a criptografia dos canais de correio:
```bash
# Testar IMAPS (Porta 993)
docker exec email-ISP openssl s_client -connect localhost:993 -brief

# Testar SMTP Submission (Porta 587)
docker exec email-ISP openssl s_client -connect localhost:587 -starttls smtp -brief
```

---

## 🤖 Pipeline de Validação CI/CD (GitHub Actions)

A cada commit na branch `main` ou `dev`, o workflow localizado em `.github/workflows/main.yml` realiza automaticamente:
1.  **Validação Estrutural**: Executa o parser do Docker Compose em todos os arquivos de composição associados para checar caminhos e variáveis.
2.  **Linter de Zonas BIND9**: Executa o `named-checkzone` para atestar a conformidade sintática dos arquivos de zona carregados pelo PowerDNS.
3.  **Linter do Nginx**: Monta as configurações dinâmicas em containers temporários oficiais do Nginx e executa `nginx -t` para validar todas as diretivas de proxy reverso e TLS.