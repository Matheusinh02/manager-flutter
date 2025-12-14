# Script PowerShell para testar API REST Serverless

Write-Host "🧪 Testando API REST Serverless..." -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host ""

Start-Sleep -Seconds 2

# Descobrir o API Gateway ID
Write-Host "🔍 Descobrindo API Gateway ID..." -ForegroundColor Yellow
$apiInfo = aws --endpoint-url=http://localhost:4566 apigateway get-rest-apis | ConvertFrom-Json
$apiId = $apiInfo.items[0].id

if (-not $apiId) {
    Write-Host "❌ API Gateway não encontrado" -ForegroundColor Red
    Write-Host "Execute primeiro: npm run deploy" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ API ID: $apiId" -ForegroundColor Green
$baseUrl = "http://localhost:4566/restapis/$apiId/local/_user_request_"
Write-Host "📍 Base URL: $baseUrl" -ForegroundColor Cyan
Write-Host ""

# Teste 1: CREATE
Write-Host "1️⃣ TEST: CREATE Item" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
$createBody = @{
    title = "Comprar leite"
    description = "Ir ao mercado comprar leite integral"
    priority = "high"
} | ConvertTo-Json

$createResponse = Invoke-RestMethod -Uri "$baseUrl/items" -Method Post -Body $createBody -ContentType "application/json"
$itemId = $createResponse.item.id
Write-Host "✅ Item criado: $itemId" -ForegroundColor Green
Write-Host "📢 Verifique os logs do subscriber para ver a notificação SNS" -ForegroundColor Cyan
Write-Host ""
Start-Sleep -Seconds 2

# Teste 2: LIST
Write-Host "2️⃣ TEST: LIST Items" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
$listResponse = Invoke-RestMethod -Uri "$baseUrl/items" -Method Get
$listResponse | ConvertTo-Json -Depth 10
Write-Host ""
Start-Sleep -Seconds 2

# Teste 3: GET ONE
Write-Host "3️⃣ TEST: GET Item por ID" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
$getResponse = Invoke-RestMethod -Uri "$baseUrl/items/$itemId" -Method Get
$getResponse | ConvertTo-Json -Depth 10
Write-Host ""
Start-Sleep -Seconds 2

# Teste 4: UPDATE
Write-Host "4️⃣ TEST: UPDATE Item" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
$updateBody = @{
    title = "Comprar leite e pão"
    completed = $true
} | ConvertTo-Json

$updateResponse = Invoke-RestMethod -Uri "$baseUrl/items/$itemId" -Method Put -Body $updateBody -ContentType "application/json"
$updateResponse | ConvertTo-Json -Depth 10
Write-Host "📢 Verifique os logs do subscriber para ver a notificação SNS" -ForegroundColor Cyan
Write-Host ""
Start-Sleep -Seconds 2

# Teste 5: DELETE
Write-Host "5️⃣ TEST: DELETE Item" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
$deleteResponse = Invoke-RestMethod -Uri "$baseUrl/items/$itemId" -Method Delete
$deleteResponse | ConvertTo-Json -Depth 10
Write-Host ""

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host "✅ Todos os testes concluídos!" -ForegroundColor Green
Write-Host ""
Write-Host "💡 Comandos úteis:" -ForegroundColor Cyan
Write-Host "  - Ver logs SNS subscriber: docker logs localstack | Select-String '📬'"
Write-Host "  - Ver tabela DynamoDB: aws --endpoint-url=http://localhost:4566 dynamodb scan --table-name task-manager-serverless-items-local"
Write-Host "  - Ver tópicos SNS: aws --endpoint-url=http://localhost:4566 sns list-topics"
