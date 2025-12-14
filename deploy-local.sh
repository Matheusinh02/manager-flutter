#!/bin/bash

echo "🚀 Iniciando deploy do Serverless no LocalStack..."
echo ""

# Verificar se LocalStack está rodando
echo "1️⃣ Verificando LocalStack..."
if ! curl -s http://localhost:4566/_localstack/health > /dev/null; then
    echo "❌ LocalStack não está rodando!"
    echo "Execute: docker-compose up -d"
    exit 1
fi
echo "✅ LocalStack está rodando"

# Ir para pasta serverless
cd serverless

# Instalar dependências
echo ""
echo "2️⃣ Instalando dependências..."
npm install

# Deploy
echo ""
echo "3️⃣ Fazendo deploy das funções Lambda..."
npm run deploy

echo ""
echo "✅ Deploy concluído!"
echo ""
echo "📋 Próximos passos:"
echo "  1. Teste os endpoints com: ./test-api.sh"
echo "  2. Veja os logs com: serverless logs -f createItem --stage local"
