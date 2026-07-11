# 📋 Relatório de Status do Projeto: Provedor de Internet (ISP) em Microsserviços

Este relatório consolida o estado atual da implementação no repositório com os requisitos especificados para o **Projeto Final de Administração de Sistemas Abertos (ASA)**.

---

## 1. O que já foi Implementado e Validado (Status Atual)

A infraestrutura completa do provedor de internet e de seus 3 clientes está **totalmente operacional** e validada localmente por meio de testes funcionais e capturas de tela.

### A. Infraestrutura do Provedor (ISP)
- **Serviço de DNS (PowerDNS)**: 
  - Zona principal `nexustech.com.br` e zonas dos clientes (`salesfilho.com.br`, `cliente2.com.br`, `cliente3.com.br`) configuradas.
  - O container `DNSISP` foi validado e resolve todos os domínios com sucesso.
- **Serviço de Proxy Reverso (Nginx)**: 
  - O container `proxyISP` atua como gateway principal na porta 80.
  - Configurado com redirecionamentos dinâmicos que encaminham as requisições baseadas em `Host` para os respectivos portais e CMS dos clientes.
- **Portal do ISP**: 
  - Site institucional estático para o provedor **NexusTech** funcional.
- **Serviço de E-mail (Debian + Postfix + Dovecot)**: 
  - Configuração de caixas de correio virtuais completada via script `mail.sh` (`admin_nx`, `suporte_nx`, `financeiro_nx`, `contato_nx`).
  - Dovecot e Postfix rodando sob o `supervisord`.
  - **Segurança SSL/TLS ativa**: Certificado autoassinado gerado no boot e validado via handshake criptografado nas portas 993 (IMAPS) e 587 (SMTP Submission) com TLSv1.3.
- **Webmail (Nextcloud + MariaDB)**: 
  - Nextcloud iniciado e integrado à base MariaDB `nextcloud-db` na rede do provedor.

### B. Infraestrutura dos Clientes
- **Cliente 1 (`salesfilho.com.br`)**:
  - **Proxy Reverso (Nginx)** local distribuindo o tráfego interno.
  - **Portal** e **Hotsite** institucionais estáticos funcionais.
  - **Sign (Assinador de Documentos)**: Frontend, API Backend e banco PostgreSQL totalmente operacionais na rede privada `cliente1_net`.
- **Cliente 2 (`cliente2.com.br`)** e **Cliente 3 (`cliente3.com.br`)**:
  - **Correção de Mismatch Concluída**: Removidas as pastas antigas que continham duplicatas do serviço de assinaturas.
  - **CMS WordPress**: Implementados os serviços oficiais do WordPress (`cms-app-cliente2`/`cms-app-cliente3`) com base MariaDB local para cada cliente, isolados em suas redes internas.
  - **Proxy local**: Nginx configurado para rotear o tráfego institucional para o Portal e subdomínio `cms.` para os respectivos instaladores do WordPress.

---

## 2. Inconsistências e Correções Efetuadas

Durante a execução e validação da infraestrutura, realizamos as seguintes correções críticas:

1. **Correção de Fim de Linha (CRLF ➔ LF)**:
   - Arquivos do Windows copiados/montados nos containers Linux (especialmente o script `mail.sh` de configuração de e-mail e os arquivos de zonas do PowerDNS como o `named.conf`) apresentavam falhas de sintaxe devido a retornos de carro (`\r`). Desenvolvemos um script automatizado que converteu todos os arquivos para a quebra de linha padrão do Unix (`\n`).
2. **Sincronização de Certificados SSL de Correio**:
   - Ajustados os caminhos no Dovecot e Postfix para utilizar o certificado `/etc/ssl/certs/mail.pem` gerado pelo setup dinamicamente no boot, permitindo a negociação segura de STARTTLS/SSL sem falhas na inicialização.
3. **Isolamento de Redes**:
   - Redes dos clientes configuradas com isolamento estrito (bridges separadas). Validamos que os portais internos dos clientes não conseguem resolver nem acessar uns aos outros diretamente, atendendo o requisito de privacidade de dados.
4. **Loop de Inicialização do Webmail (Nextcloud)**:
   - Corrigido um loop infinito no container `webmailISP` que ocorria porque as variáveis `NEXTCLOUD_ADMIN_USER` e `NEXTCLOUD_ADMIN_PASSWORD` no `compose.yaml` disparavam a instalação automática do Nextcloud (via `occ maintenance:install`), a qual falhava por ele já estar instalado no volume persistente. A remoção destas variáveis no `compose.yaml` corrigiu o problema e permitiu a inicialização correta do Apache.

---

## 3. Próximos Passos (Requisitos Opcionais / Melhorias)

- **Discussão PowerDNS vs Bind9**:
  - O DNS atual usa PowerDNS com o BIND backend. Caso o professor exija o serviço padrão do BIND9 clássico, podemos migrar a imagem para o repositório oficial do BIND9. Caso contrário, a escolha do PowerDNS está justificada no relatório de testes por sua escalabilidade e robustez.
- **SSL/TLS (HTTPS) no Proxy ISP**:
  - Para ambiente de produção real, sugere-se a adição de um container secundário de Certbot para automatizar os certificados Let's Encrypt para o gateway na porta 443.

---

## 4. Evidências de Validação

Os testes foram consolidados e estão com evidências de captura de tela de todas as aplicações (NexusTech, Nextcloud Webmail, Portal Cliente 1, Hotsite Cliente 1, Sign App Cliente 1, WordPress Cliente 2, WordPress Cliente 3):
- 🧪 **Relatório de Testes Executados**: [Relatorio_de_Testes.md](file:///c:/Users/Juju/Projeto_ASA-2026.1/Relatorio_de_Testes.md)
- 📸 **Diretório de Capturas**: [Pasta de Screenshots](file:///c:/Users/Juju/Projeto_ASA-2026.1/screenshots)
