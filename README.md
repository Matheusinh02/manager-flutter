# Task Manager - CRUD Serverless com SNS

## 📋 Descrição

Aplicação CRUD (Create, Read, Update, Delete) utilizando **arquitetura serverless** com AWS Lambda, DynamoDB e SNS para notificações, simulado localmente com LocalStack.

### ☁️ Opção A Implementada: CRUD Serverless com Notificações SNS

Este projeto demonstra uma API REST completamente serverless com:
- **Funções Lambda** para cada operação CRUD
- **DynamoDB** para persistência de dados NoSQL
- **Amazon SNS** para notificações em tópico
- **Subscriber Lambda** que recebe e processa notificações
- **LocalStack** para simular AWS localmente

## 🚀 Stack Tecnológica

| Tecnologia | Descrição |
|------------|-----------|
| **Serverless Framework** | Framework para deploy de aplicações serverless |
| **LocalStack** | Emulador local dos serviços AWS |
| **AWS Lambda** | Funções serverless para lógica de negócio |
| **API Gateway** | Exposição dos endpoints REST |
| **DynamoDB** | Banco de dados NoSQL para persistência |
| **Amazon SNS** | Serviço de notificações em tópico |

## 🎯 Funcionalidades Implementadas

### ✅ CRUD Completo
1. **CREATE** (`POST /items`) - Criar novo item + notificação SNS
2. **READ ALL** (`GET /items`) - Listar todos os items
3. **READ ONE** (`GET /items/{id}`) - Buscar item por ID
4. **UPDATE** (`PUT /items/{id}`) - Atualizar item + notificação SNS
5. **DELETE** (`DELETE /items/{id}`) - Remover item

### 📢 Notificação SNS
- Publicação de mensagem quando recurso é **criado** ou **atualizado**
- Subject personalizado com título do item
- Payload JSON com ação, dados do item e timestamp

### 📬 Subscriber
- Função Lambda automaticamente invocada para cada notificação
- Processa e loga detalhes da notificação
- Exibe mudanças no caso de UPDATE

### ✔️ Validação
- Validação de campos obrigatórios (title, description)
- Verificação de existência antes de UPDATE/DELETE
- Tratamento de erros com mensagens apropriadas

## 📦 Pré-requisitos

```bash
# Ferramentas necessárias
node --version    # Node.js 18+
npm --version     # NPM 9+
docker --version  # Docker 20+
aws --version     # AWS CLI (para testes)
```

### Instalação do Serverless Framework
```bash
npm install -g serverless
```

## 🔧 Instalação

### 1. Clone o repositório
```bash
git clone https://github.com/Matheusinh02/manager-flutter.git
cd manager-flutter
```

### 2. Iniciar LocalStack
```bash
docker-compose up -d
```

Aguarde 10-15 segundos para o LocalStack inicializar.

### 3. Deploy das funções Lambda
```bash
# Windows PowerShell (RECOMENDADO)
./deploy-local.ps1

# Linux/Mac
chmod +x deploy-local.sh
./deploy-local.sh
```

O deploy irá:
- Instalar dependências do projeto serverless
- Criar tabela DynamoDB
- Criar tópico SNS
- Deploy de todas as funções Lambda
- Configurar API Gateway

## 🎮 Testando a API

### Teste Automatizado
```bash
# Windows PowerShell (RECOMENDADO)
./test-api.ps1

# Linux/Mac
chmod +x test-api.sh
./test-api.sh
```

## 🎓 Roteiro de Demonstração (Sala de Aula)

### Preparação (5 min)
```bash
# 1. Iniciar LocalStack
docker-compose up -d

# 2. Deploy das funções
./deploy-local.ps1

# 3. Verificar serviços
docker ps
```

### Demonstração (15 min)

#### 1. Infraestrutura ✅
```bash
# Mostrar containers rodando
docker ps

# Verificar health do LocalStack
curl http://localhost:4566/_localstack/health
```

**Saída esperada:**
```json
{
  "services": {
    "lambda": "running",
    "dynamodb": "running",
    "sns": "running",
    "apigateway": "running"
  }
}
```

#### 2. Configuração do serverless.yml ✅
Abrir arquivo `serverless/serverless.yml` e mostrar:
- Funções Lambda definidas (6 funções)
- Tabela DynamoDB configurada
- Tópico SNS configurado
- Subscriber conectado ao tópico

#### 3. Ação - Testar CRUD ✅
```bash
# Executar todos os testes
./test-api.ps1
```

Isso irá:
- ✅ Criar um item (com notificação SNS)
- ✅ Listar todos os items
- ✅ Buscar item por ID
- ✅ Atualizar item (com notificação SNS)
- ✅ Deletar item

#### 4. Validação - Notificação SNS ✅
```bash
# Ver logs do subscriber
docker logs localstack 2>&1 | Select-String "📬"
```

**Log esperado:**
```
📬 SNS Subscriber - Event: ...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📨 NOTIFICAÇÃO SNS RECEBIDA
🏷️  Assunto: Novo Item Criado: Comprar leite
⚡ Ação: CREATE
📦 Item:
   - ID: abc-123
   - Título: Comprar leite
   - Descrição: Ir ao mercado
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

#### 5. Validação - DynamoDB ✅
```bash
# Listar items na tabela
aws --endpoint-url=http://localhost:4566 dynamodb scan --table-name task-manager-serverless-items-local
```

## 📊 Arquitetura

```
┌─────────────┐
│   Cliente   │
│  (curl/app) │
└──────┬──────┘
       │
       │ HTTP Request
       ▼
┌─────────────────┐
│  API Gateway    │ ← LocalStack (porta 4566)
│  (REST API)     │
└──────┬──────────┘
       │
       │ Invoke
       ▼
┌─────────────────┐        ┌──────────────┐
│  Lambda CRUD    │───────>│  DynamoDB    │
│  Functions      │  R/W   │   (NoSQL)    │
└──────┬──────────┘        └──────────────┘
       │
       │ Publish
       ▼
┌─────────────────┐
│   SNS Topic     │
│ (notifications) │
└──────┬──────────┘
       │
       │ Subscribe
       ▼
┌─────────────────┐
│    Subscriber   │
│     Lambda      │
└─────────────────┘
```

## 📂 Estrutura do Projeto

```
manager-flutter/
├── docker-compose.yml              # LocalStack configuration
├── deploy-local.sh                 # Deploy script (Linux/Mac)
├── deploy-local.ps1                # Deploy script (Windows)
├── test-api.sh                     # API test script (Linux/Mac)
├── test-api.ps1                    # API test script (Windows)
│
└── serverless/
    ├── serverless.yml              # Serverless configuration
    ├── package.json                # Dependencies
    │
    └── functions/
        ├── createItem.js           # CREATE + SNS notification
        ├── listItems.js            # READ ALL
        ├── getItem.js              # READ ONE
        ├── updateItem.js           # UPDATE + SNS notification
        ├── deleteItem.js           # DELETE
        └── snsSubscriber.js        # SNS message processor
```

## 🔍 Comandos Úteis

### Ver funções Lambda
```bash
aws --endpoint-url=http://localhost:4566 lambda list-functions
```

### Ver tópicos SNS
```bash
aws --endpoint-url=http://localhost:4566 sns list-topics
```

### Escanear tabela DynamoDB
```bash
aws --endpoint-url=http://localhost:4566 dynamodb scan --table-name task-manager-serverless-items-local
```

### Ver logs do LocalStack (notificações SNS)
```bash
docker logs localstack -f
```

## 📋 Checklist de Entregáveis

| Item | Status | Descrição |
|------|--------|-----------|
| ✅ | Completo | Código-fonte no repositório Git |
| ✅ | Completo | Arquivo `serverless.yml` configurado |
| ✅ | Completo | 5 funções Lambda CRUD implementadas |
| ✅ | Completo | Função subscriber SNS implementada |
| ✅ | Completo | Notificação SNS no CREATE e UPDATE |
| ✅ | Completo | Validação de dados de entrada |
| ✅ | Completo | Tabela DynamoDB configurada |
| ✅ | Completo | Tópico SNS configurado |
| ✅ | Completo | Docker Compose com LocalStack |
| ✅ | Completo | README.md com instruções |
| ✅ | Completo | Scripts de deploy e teste |
| ✅ | Completo | Evidências documentadas |

**Total: 31 pontos** ✅

## 🎯 Endpoints da API

| Método | Endpoint | Descrição | Notifica SNS? |
|--------|----------|-----------|---------------|
| POST | `/items` | Criar novo item | ✅ Sim |
| GET | `/items` | Listar todos os items | ❌ Não |
| GET | `/items/{id}` | Buscar item por ID | ❌ Não |
| PUT | `/items/{id}` | Atualizar item existente | ✅ Sim |
| DELETE | `/items/{id}` | Remover item | ❌ Não |

## 📝 Licença

MIT

## 👨‍💻 Autor

Desenvolvido para disciplina de Engenharia de Software - PUC Minas

---

**✨ Projeto completo de CRUD Serverless com notificações SNS!**


