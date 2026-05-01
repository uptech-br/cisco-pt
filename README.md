# Cisco Packet Tracer no Docker

Imagem Docker para executar o Cisco Packet Tracer via navegador, usando a base Kasm Workspaces (`kasmweb/core-ubuntu-noble:1.18.0`).

A imagem instala o Cisco Packet Tracer a partir do pacote `.deb` local e deixa o acesso noVNC sem usuário/senha.

## Requisitos

- Docker instalado.
- Pacote do Cisco Packet Tracer em `assets/CiscoPacketTracer_64bit.deb`.

## Build

Execute:

```bash
docker build --build-arg TZ=America/Recife -t cisco-pt .
```

## Execução

Execute:

```bash
./run.sh
```

O container será iniciado com:

- Porta web publicada em `6901`.
- Volume Docker `cisco-pt` montado em `/backup`.
- `/dev/fuse` habilitado para o AppImage do Packet Tracer.
- Bloqueio local de `www.cisco.com` e `cisco.com` via `--add-host`.

Acesse no navegador:

```text
https://127.0.0.1:6901
```

O certificado HTTPS é autoassinado, então o navegador pode exibir um aviso de segurança.

## Login no noVNC

O `Dockerfile` define:

```dockerfile
ENV VNCOPTIONS="${VNCOPTIONS} -DisableBasicAuth"
```

Com isso, o noVNC abre diretamente, sem solicitar usuário e senha. O `VNC_PW` ainda aparece no `run.sh` porque alguns serviços internos da imagem Kasm usam essa variável, mas a autenticação básica do acesso web fica desabilitada.

## Observações de segurança

Esta imagem foi configurada para acesso direto pelo navegador, sem usuário e senha no noVNC. Use apenas em ambiente local, laboratório ou rede confiável.

O `run.sh` também usa `--privileged`, publica a porta `6901` e concede recursos ampliados ao container. Evite expor essa porta diretamente para redes públicas.

## Licença e pacote Cisco

Este repositório não substitui os termos de uso do Cisco Packet Tracer. O pacote `.deb` deve ser obtido por meios autorizados pela Cisco e usado conforme a licença do software.
