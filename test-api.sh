#!/bin/bash

# Script para testar API REST Serverless
# Roteiro de demonstração em sala de aula

API_URL="http://localhost:4566/restapis"

echo "🧪 Testando API REST Serverless..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Aguardar um pouco
sleep 2

# Descobrir o API Gateway ID
echo "🔍 Descobrindo API Gateway ID..."
API_ID=$(aws --endpoint-url=http://localhost:4566 apigateway get-rest-apis | grep -o '"id": "[^"]*' | head -1 | grep -o '[^"]*$')

if [ -z "$API_ID" ]; then
    echo "❌ API Gateway não encontrado"
    echo "Execute primeiro: npm run deploy"
    exit 1
fi

echo "✅ API ID: $API_ID"
BASE_URL="http://localhost:4566/restapis/$API_ID/local/_user_request_"
echo "📍 Base URL: $BASE_URL"
echo ""

# Teste 1: CREATE
echo "1️⃣ TEST: CREATE Item"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ITEM_ID=$(curl -s -X POST "$BASE_URL/items" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Comprar leite",
    "description": "Ir ao mercado comprar leite integral",
    "priority": "high"
  }' | jq -r '.item.id')

echo "✅ Item criado: $ITEM_ID"
echo "📢 Verifique os logs do subscriber para ver a notificação SNS"
echo ""
sleep 2

# Teste 2: LIST
echo "2️⃣ TEST: LIST Items"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
curl -s -X GET "$BASE_URL/items" | jq
echo ""
sleep 2

# Teste 3: GET ONE
echo "3️⃣ TEST: GET Item por ID"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
curl -s -X GET "$BASE_URL/items/$ITEM_ID" | jq
echo ""
sleep 2

# Teste 4: UPDATE
echo "4️⃣ TEST: UPDATE Item"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
curl -s -X PUT "$BASE_URL/items/$ITEM_ID" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Comprar leite e pão",
    "completed": true
  }' | jq
echo "📢 Verifique os logs do subscriber para ver a notificação SNS"
echo ""
sleep 2

# Teste 5: DELETE
echo "5️⃣ TEST: DELETE Item"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
curl -s -X DELETE "$BASE_URL/items/$ITEM_ID" | jq
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Todos os testes concluídos!"
echo ""
echo "💡 Comandos úteis:"
echo "  - Ver logs SNS subscriber: docker logs localstack | grep '📬'"
echo "  - Ver tabela DynamoDB: aws --endpoint-url=http://localhost:4566 dynamodb scan --table-name task-manager-serverless-items-local"
echo "  - Ver tópicos SNS: aws --endpoint-url=http://localhost:4566 sns list-topics"
