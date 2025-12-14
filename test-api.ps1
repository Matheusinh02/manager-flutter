# Script de Teste da API Serverless
# ====================================

$API_URL = "http://localhost:4566/restapis/rd4yvcwjkt/local/_user_request_"

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Testando API Serverless LocalStack" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Teste 1: CREATE Item
Write-Host "[1/5] Criando novo item..." -ForegroundColor Yellow
$createResponse = Invoke-RestMethod -Uri "$API_URL/items" -Method POST -Body (@{
    title = "Tarefa de Teste"
    description = "Criada via script de teste"
} | ConvertTo-Json) -ContentType "application/json"

Write-Host "[OK] Item criado com sucesso!" -ForegroundColor Green
$itemId = $createResponse.item.id
Write-Host "ID: $itemId" -ForegroundColor Gray
Write-Host ""

Start-Sleep -Seconds 2

# Teste 2: LIST Items
Write-Host "[2/5] Listando todos os itens..." -ForegroundColor Yellow
$listResponse = Invoke-RestMethod -Uri "$API_URL/items" -Method GET
Write-Host "[OK] Total de itens: $($listResponse.items.Count)" -ForegroundColor Green
Write-Host ""

Start-Sleep -Seconds 2

# Teste 3: GET Item
Write-Host "[3/5] Buscando item especifico..." -ForegroundColor Yellow
$getResponse = Invoke-RestMethod -Uri "$API_URL/items/$itemId" -Method GET
Write-Host "[OK] Item encontrado: $($getResponse.item.title)" -ForegroundColor Green
Write-Host ""

Start-Sleep -Seconds 2

# Teste 4: UPDATE Item
Write-Host "[4/5] Atualizando item..." -ForegroundColor Yellow
$updateResponse = Invoke-RestMethod -Uri "$API_URL/items/$itemId" -Method PUT -Body (@{
    title = "Tarefa Atualizada"
    description = "Modificada via script"
    completed = $true
} | ConvertTo-Json) -ContentType "application/json"

Write-Host "[OK] Item atualizado com sucesso!" -ForegroundColor Green
Write-Host ""

Start-Sleep -Seconds 2

# Teste 5: DELETE Item
Write-Host "[5/5] Deletando item..." -ForegroundColor Yellow
$deleteResponse = Invoke-RestMethod -Uri "$API_URL/items/$itemId" -Method DELETE
Write-Host "[OK] Item deletado com sucesso!" -ForegroundColor Green
Write-Host ""

# Verificar logs SNS
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Logs SNS Subscriber (ultimas 10)" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

docker logs localstack | Select-String 'SNS' -Context 0,1 | Select-Object -Last 10

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Testes concluidos com sucesso!" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
