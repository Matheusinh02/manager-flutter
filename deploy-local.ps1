# Script PowerShell para deploy no LocalStack

Write-Host "🚀 Iniciando deploy do Serverless no LocalStack..." -ForegroundColor Cyan
Write-Host ""

# Verificar se LocalStack está rodando
Write-Host "1️⃣ Verificando LocalStack..." -ForegroundColor Yellow
try {
    $health = Invoke-RestMethod -Uri "http://localhost:4566/_localstack/health" -Method Get -ErrorAction Stop
    Write-Host "✅ LocalStack está rodando" -ForegroundColor Green
} catch {
    Write-Host "❌ LocalStack não está rodando!" -ForegroundColor Red
    Write-Host "Execute: docker-compose up -d" -ForegroundColor Yellow
    exit 1
}

# Ir para pasta serverless
Set-Location serverless

# Instalar dependências
Write-Host ""
Write-Host "2️⃣ Instalando dependências..." -ForegroundColor Yellow
npm install

# Deploy
Write-Host ""
Write-Host "3️⃣ Fazendo deploy das funções Lambda..." -ForegroundColor Yellow
npm run deploy

Write-Host ""
Write-Host "✅ Deploy concluído!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Próximos passos:" -ForegroundColor Cyan
Write-Host "  1. Teste os endpoints com: ./test-api.ps1"
Write-Host "  2. Veja os logs com: serverless logs -f createItem --stage local"
