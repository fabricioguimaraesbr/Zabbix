# Aplicação demonstrativa com OpenTelemetry e Zabbix

Esta composição separada executa uma aplicação de login em `http://localhost:8080`, um OpenTelemetry Collector e um proxy Zabbix que recebe OTLP gRPC. O Collector encaminha logs, traces e métricas para o proxy na porta 4317. Como a imagem oficial `alpine-trunk` não inclui o receptor APM, o Compose compila localmente um proxy com `--with-apm`.

## Inicialização

1. Inicie a composição principal para criar o Zabbix e a rede compartilhada:

   ```sh
   docker compose -f Docker/docker-compose.yml up -d
   ```

2. Crie o arquivo de ambiente da demonstração e substitua os valores de exemplo:

   ```sh
   cp Docker/.env.example Docker/.env
   ```

3. Registre no frontend do Zabbix um proxy **ativo** chamado `zabbix-apm-proxy`. Esse nome deve corresponder a `ZBX_HOSTNAME` no Compose.

4. Inicie a aplicação e a coleta:

   ```sh
   docker compose --env-file Docker/.env -f Docker/docker-compose-app.yml up -d --build
   ```

O banco SQLite do proxy fica em `/Users/fabricio/VSCode/docker-volume/zabbix-apm-proxy`. A aplicação demonstrativa usa o usuário definido por `APP_USERNAME` e a senha definida por `APP_PASSWORD`.

## Exibir a telemetria no Zabbix

No frontend, crie um host para a aplicação, associe-o ao proxy `zabbix-apm-proxy` e importe/aplique o template oficial **Generic OpenTelemetry by OTLP**. O template depende do suporte a APM/OTLP do Zabbix 8.0 ou superior. A imagem `alpine-trunk` usada aqui precisa conter esse suporte.

Faça login e logout em `http://localhost:8080` para gerar tráfego. O SDK envia traces, métricas HTTP e métricas de login, além de logs de tentativas de autenticação. A atualização dos itens no Zabbix segue os intervalos configurados no template.

Este exemplo é para desenvolvimento local. Não o exponha à internet sem adicionar TLS, proteção CSRF, armazenamento de sessão apropriado e credenciais fortes.
