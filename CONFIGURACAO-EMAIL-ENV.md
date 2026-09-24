# Configuração de e-mail via `.env` (DSpace 7)

Este guia explica como rodar o projeto e fazer as variáveis de e-mail do
`local.cfg` funcionarem a partir de um arquivo `.env`.

---

## 1. Como funciona (entenda antes de rodar)

O DSpace **não lê arquivos `.env` diretamente**. O que acontece é:

1. O `local.cfg` referencia as configurações de e-mail com placeholders, por
   exemplo `mail.server.password = ${mail_server_password}`.
2. O DSpace resolve esses `${...}` a partir de **variáveis de ambiente** do
   container.
3. Quem carrega o `.env` e transforma cada linha em variável de ambiente é o
   **docker-compose**, através da diretiva `env_file`.

Convenção das chaves: os pontos das propriedades do DSpace viram underscores.

| Propriedade no `local.cfg`   | Variável no `.env`         |
| ---------------------------- | -------------------------- |
| `mail.server`                | `mail_server`              |
| `mail.server.username`       | `mail_server_username`     |
| `mail.server.password`       | `mail_server_password`     |
| `mail.server.port`           | `mail_server_port`         |
| `mail.from.address`          | `mail_from_address`        |
| `feedback.recipient`         | `feedback_recipient`       |
| `mail.admin`                 | `mail_admin`               |
| `alert.recipient`            | `alert_recipient`          |
| `registration.notify`        | `registration_notify`      |
| `mail.charset`               | `mail_charset`             |

---

## 2. Onde ficam os arquivos

- **`./.env`** (raiz do projeto) — **fonte da verdade**. É aqui que você
  preenche os dados reais. Não é versionado (está no `.gitignore`).
- **`./.env.EXAMPLE`** (raiz) — modelo sem segredos, versionado. Serve de base.
- **`dspace-install-dir/config/.env`** — cópia gerada durante o build. É o
  arquivo que o docker-compose lê. Você **não** edita este diretamente; ele é
  criado a partir do `./.env` da raiz.
- **`dspace-install-dir/config/local.cfg`** — arquivo lido pelo DSpace dentro
  do container (montado como volume).
- **`local.cfg`** (raiz) — modelo do `local.cfg` usado pelo build/upgrade.

---

## 3. Passo a passo para rodar

### Passo 1 — Criar e preencher o `.env` da raiz

Se ainda não existe, copie o modelo:

```bash
cp .env.EXAMPLE .env
```

Edite o `./.env` e preencha os dados reais, principalmente a senha:

```
mail_server=smtp.gmail.com
mail_server_username=publicacoes@ifba.edu.br
mail_server_password=SUA_SENHA_APP_DO_GMAIL_AQUI
mail_server_port=587
mail_from_address=repositorio@ifba.edu.br
feedback_recipient=repositorio@ifba.edu.br
mail_admin=repositorio@ifba.edu.br
alert_recipient=
registration_notify=repositorio@ifba.edu.br
mail_charset=UTF-8
```

> **Gmail:** o `mail_server_password` deve ser um **App Password** (senha de app),
> não a senha normal da conta. Gere em: https://myaccount.google.com/apppasswords

### Passo 2 — Rodar o build/upgrade

Rode o script de upgrade normalmente (precisa de Docker rodando e root):

```bash
sudo ./upgrade-to-dspace7.sh
```

Durante o build, o `backend_build.sh` copia automaticamente o `./.env` da raiz
para `dspace-install-dir/config/.env`. Não é preciso copiar nada manualmente.

### Passo 3 — Verificar

Depois que o container `dspace7` subir, confirme que as variáveis foram
injetadas:

```bash
docker exec dspace7 printenv | grep mail_
```

Você deve ver `mail_server`, `mail_server_username`, etc. com os valores do
`.env`.

---

## 4. Só reiniciar o backend (sem rebuild completo)

Se você só mudou o `.env` e quer aplicar sem refazer todo o upgrade:

1. Atualize o `./.env` da raiz.
2. Copie para o config da instalação:
   ```bash
   cp ./.env dspace-install-dir/config/.env
   ```
3. Recrie o container:
   ```bash
   ./restart-backend.sh
   ```

O restart é necessário porque o `env_file` só é lido quando o container é
(re)criado. Editar o `.env` com o container já rodando não tem efeito sozinho.

---

## 5. Testar fora do Docker (opcional)

Para rodar comandos do `dspace` no host lendo o `.env`:

```bash
set -a; source dspace-install-dir/config/.env; set +a
```

Isso exporta as variáveis na sessão atual do shell, e o DSpace passa a
resolvê-las.

---

## 6. Sobre a senha do PostgreSQL (importante)

A senha do Postgres **não** vem do `.env`. Ela é **gerada automaticamente** pelo
`backend_build.sh` (via `openssl rand`) a cada instalação e injetada de forma
sincronizada no `local.cfg` gerado, no docker-compose e no script de criação do
banco. Não coloque `db.password` no `.env`: isso quebraria essa sincronização.
Você encontra a senha gerada em `dspace-install-dir/config/local.cfg` após o
build.

---

## 7. Segurança

- Nunca faça commit do `./.env` nem do `dspace-install-dir/config/.env`. Ambos
  já estão no `.gitignore`.
- Apenas o `./.env.EXAMPLE` (sem segredos) é versionado.
- Se a senha do Gmail já foi exposta em algum lugar, revogue o App Password e
  gere um novo.

---

## 8. Resumo rápido (checklist)

- [ ] `./.env` existe na raiz e está com a senha real preenchida
- [ ] Rodar `sudo ./upgrade-to-dspace7.sh` (ou `./restart-backend.sh` para só reiniciar)
- [ ] Conferir `docker exec dspace7 printenv | grep mail_`
- [ ] Enviar um e-mail de teste pela interface do DSpace para validar
