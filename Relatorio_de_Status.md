# 📋 Relatório de Status do Projeto: Provedor de Internet (ISP) em Microsserviços

Este relatório compara o estado atual da implementação no repositório com os requisitos especificados nos slides do **Projeto Final de Administração de Sistemas Abertos (ASA)**.

---

## 1. O que já foi Implementado (Status Atual)

A estrutura base do provedor de internet e do **Cliente 1** está bem avançada. O fluxo de desenvolvimento foi iniciado no branch `Dev` e a infraestrutura está modularizada utilizando Docker Compose.

### A. Infraestrutura do Provedor (ISP)
- **Serviço de DNS**: Configurado utilizando **PowerDNS** (em vez de Bind9) no diretório `ISP/powerdns`.
  - Zona principal `nexustech.com.br` configurada com registros A, CNAME e MX apontando para os serviços internos.
  - Zonas dos clientes (`salesfilho.com.br`, `cliente2.com.br`, `cliente3.com.br`) mapeadas no arquivo `named.conf` apontando para arquivos de zona específicos de cada cliente.
- **Serviço de Proxy Reverso**: Nginx configurado em `ISP/proxy` atuando como gateway na porta 80.
  - Roteia tráfego para o Portal do ISP (`site-ISP`), Webmail (`webmailISP`) e encaminha o tráfego dos domínios dos clientes para seus respectivos proxies internos via wildcard (`*.salesfilho.com.br`, etc.).
- **Portal do ISP**: Servidor Nginx estático em `ISP/portal` servindo a página institucional da **NexusTech**.
- **Serviço de E-mail**: Configurado com Postfix (SMTP) e Dovecot (IMAP/POP3) sob Debian em `ISP/email`.
  - Banco de usuários virtuais básicos configurado no Dovecot (`dovecot/users`).
  - Script de inicialização (`mail.sh`) que cria os diretórios de caixas de correio virtuais para o domínio `nexustech.com.br` (`admin_nx`, `suporte_nx`, `financeiro_nx`, `contato_nx`).
- **Webmail**: Instalação base do Nextcloud (versão `34-apache`) integrada com banco de dados MariaDB.

### B. Infraestrutura dos Clientes
- **Cliente 1 (`salesfilho.com.br`)**: Totalmente implementado conforme o diagrama.
  - **Proxy Reverso**: Nginx local que distribui o tráfego interno do cliente.
  - **Portal**: Site institucional estático.
  - **Hotsite**: Página estática adicional de campanha/aplicativo.
  - **Sign (Assinador de Documentos)**: Aplicação de assinatura eletrônica composta por três serviços: frontend (`sign-app-cliente1`), backend API (`sign-api-cliente1`) e banco de dados PostgreSQL (`sign-db-cliente1`).
  - **Isolamento**: Todos os serviços do Cliente 1 estão isolados na rede privada `cliente1_net`, comunicando-se com o ISP apenas através do container de proxy que possui duas interfaces (`isp_net` e `cliente1_net`).

---

## 2. Correções Necessárias (Mismatches com a Especificação)

Durante a análise, identificamos inconsistências importantes entre os arquivos do repositório e o projeto especificado no PDF:

### ⚠️ Inconsistência Crítica na Infraestrutura dos Clientes 2 e 3
- **O Problema**: No repositório atual, as pastas `cliente2` e `cliente3` são **cópias exatas do Cliente 1**. Elas contêm e tentam inicializar o serviço **Sign** (com Postgres, API e App) e o **Hotsite**.
- **O Requisito do Slide 8**: De acordo com a arquitetura oficial, o **Cliente 2** e o **Cliente 3** devem possuir apenas **Portal**, **Proxy Reverso** e um **CMS** (como WordPress, Drupal ou Joomla). Eles não devem conter o aplicativo "Sign" nem o "Hotsite".
- **Correção Necessária**: 
  1. Remover as pastas e referências do serviço `sign` e `hotsite` dos diretórios de `cliente2` e `cliente3`.
  2. Implementar um serviço de **CMS** (ex: imagem oficial do `wordpress:latest` ou similar com banco MySQL/MariaDB) em rede privada nos arquivos de compose do Cliente 2 e Cliente 3.
  3. Atualizar as configurações dos proxies locais de Nginx (`ISP/clientes/cliente2/proxy/default.conf` e `ISP/clientes/cliente3/proxy/default.conf`) para apontar para o CMS (`cms.cliente2.com.br`) em vez de apontar para os serviços de assinatura (`sign.*` e `app.*`).

### ⚙️ Outras Correções e Mismatch de Tecnologias
- **PowerDNS vs Bind9**: O slide de objetivos SMART (pág. 5) exige explicitamente **Bind9** para o DNS do provedor. No entanto, o código atual utiliza **PowerDNS**. Caso a exigência do professor por Bind9 seja rígida, este serviço precisará ser reescrito utilizando a imagem `ubuntu/bind9` ou `internetsystemsconsortium/bind9`. Se o uso de PowerDNS for aceito, a documentação e o slide de apresentação devem ser ajustados para justificar a escolha do PowerDNS.
- **Caminhos de Certificado do Postfix/Dovecot**: No arquivo `main.cf` do Postfix, o certificado SSL está apontado para `/etc/dovecot/dovecot.pem`, mas a chave está em `/etc/dovecot/private/dovecot.key`. No Dovecot (`10-ssl.conf`), ambos estão apontados para o diretório `/etc/dovecot/private/`. É necessário sincronizar esses caminhos para evitar falhas na inicialização do STARTTLS.

---

## 3. O que Ainda Falta Implementar (Requisitos Pendentes)

Com base no escopo do projeto, os seguintes itens ainda não foram codificados/configurados:

### 🔒 1. Segurança SSL/TLS (HTTPS) no Proxy do Provedor (Slide 5)
- O proxy reverso do ISP (`proxyISP` no `compose.yaml`) expõe apenas a porta 80.
- Falta configurar a porta **443** e obter/configurar os certificados SSL (o slide menciona via **Let's Encrypt**).
- Como o ambiente será validado em laboratório local (IFRN), podemos implementar certificados autoassinados gerados localmente ou usar um container secundário do **Certbot** em modo de simulação, ou ainda utilizar o **Nginx Proxy Manager / Traefik** para automatizar esse gerenciamento.

### 📧 2. E-mail Multidomínio no Provedor
- Atualmente, o servidor de correio só está configurado para o domínio do provedor (`nexustech.com.br`).
- O slide 4 diz: *"A rede do provedor deve oferecer serviço de DNS, Correio Eletrônico e proxy reverso HTTP com garantia de segurança SSL para todos os seus clientes."*
- É necessário adaptar o Postfix e o Dovecot para aceitarem múltiplos domínios virtuais de correio (`salesfilho.com.br`, `cliente2.com.br`, `cliente3.com.br`) e criar contas de teste para os mesmos.

### 🌐 3. Integração do Webmail (Nextcloud) com o Servidor de E-mail
- O container do Nextcloud está rodando, mas não há configuração que o conecte ao servidor Postfix/Dovecot.
- É necessário habilitar ou configurar o aplicativo de **Mail** (ou usar uma alternativa dedicada e leve como o **Roundcube**) configurado para se conectar aos protocolos SMTP (porta 587 ou 465) e IMAP (porta 143 ou 993) da infraestrutura.

### 🧪 4. Validação e Testes Automatizados (Slide 6)
- Não existe uma pipeline de CI/CD (ex: `.github/workflows`) ou scripts locais de teste no repositório.
- **A Fazer**: Criar scripts simples em Bash (como `test-connectivity.sh`) para validar se:
  - O DNS resolve os nomes corretamente.
  - As portas de E-mail (25, 143, 587, 993) respondem.
  - Os proxies direcionam o tráfego corretamente.
  - O isolamento de rede Docker está funcionando (impedindo ping direto entre `cliente1_net` e `cliente2_net`).

### 📑 5. Artefatos de Gerenciamento & Apresentação (Slides 9 e 10)
- Faltam atas de reuniões, controle detalhado de Issues do GitHub que mostrem a execução do Scrum, o relatório de métricas de desempenho (latência/disponibilidade) e o manual de implantação em vídeo.

---

## 4. Sugestões de Melhorias Técnicas

Para obter uma nota de destaque no projeto (além de meramente cumprir a tabela de requisitos), sugerimos as seguintes melhorias:

1. **Centralização de Certificados SSL (Let's Encrypt / Certbot)**:
   - Configurar um container do Certbot integrado com o Nginx para renovação automática de certificados SSL. Alternativamente, substituir o Nginx do ISP por **Traefik**, que faz o gerenciamento de certificados SSL da Let's Encrypt automaticamente para todos os subdomínios dos clientes.
2. **Centralização de Logs (Observabilidade)**:
   - Adicionar um container leve de coleta de logs (como o Grafana Loki ou o Nginx Amplify) para centralizar os logs de acessos e erros de todos os proxies de clientes e do ISP. Isso facilita muito a depuração e monitoramento exigidos no relatório técnico.
3. **Autenticação Segura no E-mail**:
   - Implementar regras de SPF, DKIM e DMARC no DNS do ISP para os domínios configurados, garantindo que o servidor de e-mail adote as melhores práticas de entrega e segurança modernas.
4. **Substituição do Nextcloud por Roundcube/Rainloop (Se desejado)**:
   - O Nextcloud é excelente, mas é muito pesado (banco de dados próprio, consumo de memória elevado para VMs de laboratório). Se o objetivo for puramente "Webmail", um container do **Roundcube** ou **Rainloop** seria muito mais leve e rápido de configurar.
