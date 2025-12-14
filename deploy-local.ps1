# Script PowerShell para deploy no LocalStack

Write-Host "Iniciando deploy do Serverless no LocalStack..." -ForegroundColor Cyan
Write-Host ""

# Verificar se LocalStack esta rodando
Write-Host "1. Verificando LocalStack..." -ForegroundColor Yellow
try {
    $health = Invoke-RestMethod -Uri "http://localhost:4566/_localstack/health" -Method Get -ErrorAction Stop
    Write-Host "[OK] LocalStack esta rodando" -ForegroundColor Green
} catch {
    Write-Host "[ERRO] LocalStack nao esta rodando!" -ForegroundColor Red
    Write-Host "Execute: docker-compose up -d" -ForegroundColor Yellow
    exit 1
}

# Ir para pasta serverless
Set-Location serverless

# Instalar dependencias
Write-Host ""
Write-Host "2. Instalando dependencias..." -ForegroundColor Yellow
npm install

# Deploy
Write-Host ""
Write-Host "3. Fazendo deploy das funcoes Lambda..." -ForegroundColor Yellow
npm run deploy

Write-Host ""
Write-Host "[OK] Deploy concluido!" -ForegroundColor Green
Write-Host ""
Write-Host "Proximos passos:" -ForegroundColor Cyan
Write-Host "  1. Teste os endpoints: .\test-api.ps1"
Write-Host "  2. Veja os logs: cd serverless; serverless logs -f createItem --stage local"
