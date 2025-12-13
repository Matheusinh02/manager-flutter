# Roteiro de Demonstração - Recursos Nativos (Câmera, GPS e Sensores)

## 📋 Pré-requisitos

1. ✅ Flutter SDK 3.0+ instalado
2. ✅ Dispositivo físico Android/iOS OU Emulador
3. ✅ Permissões configuradas no AndroidManifest.xml
4. ✅ App compilado e rodando

## 🚀 Setup Inicial

```bash
# 1. Instalar dependências
flutter pub get

# 2. Rodar no dispositivo
flutter run -d <device_id>

# Para ver dispositivos disponíveis:
flutter devices
```

---

## 🎯 Cenário 1: Captura de Fotos (Câmera)

**Objetivo:** Demonstrar captura e gerenciamento de múltiplas fotos

### Passos:

1. ✅ Abrir o app e clicar em **"+ Nova Tarefa"**

2. ✅ Preencher:
   - Título: "Revisar documento"
   - Descrição: "Revisar contrato com anexos"

3. ✅ **Adicionar Primeira Foto:**
   - Clicar no botão **📷 Câmera**
   - Câmera abre em tela cheia
   - Tirar foto de um documento/objeto
   - Clicar no botão de captura (branco)
   - Foto salva e miniatura aparece

4. ✅ **Adicionar Segunda Foto:**
   - Clicar novamente em **📷 Câmera**
   - Tirar outra foto (outro ângulo)
   - Observar que agora há **2 miniaturas**

5. ✅ **Adicionar Terceira Foto:**
   - Repetir processo
   - Máximo de fotos visível em carrossel

6. ✅ **Visualizar Foto:**
   - Clicar em uma miniatura
   - Foto abre em tela cheia
   - Voltar com botão ✕

7. ✅ **Remover Foto:**
   - Clicar no ✕ vermelho na miniatura
   - Foto removida do carrossel

8. ✅ **Salvar Tarefa:**
   - Clicar em "Salvar"
   - Tarefa aparece na lista com badge **📷 3** (número de fotos)

**✅ Resultado esperado:** 
- Múltiplas fotos salvas localmente
- Badge mostra quantidade de fotos
- Console: `✅ Foto salva: /path/to/image`

---

## 🎯 Cenário 2: Galeria de Fotos

**Objetivo:** Selecionar fotos existentes da galeria

### Passos:

1. ✅ Criar nova tarefa ou editar existente

2. ✅ Clicar no botão **🖼️ Galeria**

3. ✅ **Selecionar Foto:**
   - Galeria do dispositivo abre
   - Navegar pelas pastas
   - Selecionar uma imagem

4. ✅ **Verificar:**
   - Foto aparece na lista de miniaturas
   - Badge **📷** atualizado

5. ✅ **Mesclar Câmera + Galeria:**
   - Adicionar 2 fotos da câmera
   - Adicionar 1 foto da galeria
   - Total: 3 fotos mescladas

**✅ Resultado esperado:** Fotos da câmera e galeria funcionam juntas

---

## 🎯 Cenário 3: Shake Detection (Completar Tarefa)

**Objetivo:** Usar acelerômetro para completar tarefas

### Passos:

1. ✅ **Preparar:**
   - Criar 3 tarefas pendentes (não completadas):
     - "Comprar pão"
     - "Ligar para João"
     - "Estudar Flutter"

2. ✅ **Executar Shake:**
   - Segurar o celular firmemente
   - Fazer movimento rápido de shake (chacoalhar)
   - **Intensidade:** Moderada (nem muito suave, nem muito forte)

3. ✅ **Observar:**
   - Celular vibra (feedback tátil)
   - Console mostra: `🔳 Shake! Magnitude: 18.45`
   - Dialog aparece: **"Shake detectado!"**

4. ✅ **Selecionar Tarefa:**
   - Dialog mostra até 3 tarefas pendentes
   - Clicar no ✅ verde ao lado de "Comprar pão"

5. ✅ **Verificar Resultado:**
   - Tarefa marcada como completa
   - Badge **📳 Shake** aparece (indicando foi completada por shake)
   - Console: `✅ Tarefa completada por shake: Comprar pão`

6. ✅ **Testar Novamente:**
   - Fazer shake de novo
   - Completar "Ligar para João"
   - Verificar badge **📳**

**✅ Resultado esperado:** 
- Shake detectado corretamente
- Vibração funcionando
- Tarefas completadas por shake têm badge especial

### **Calibração do Shake:**

Se shake não detectar ou detectar demais:

```dart
// Ajustar em lib/services/sensor_service.dart
static const double _shakeThreshold = 15.0;  // Padrão

// Mais sensível (detecta fácil):
static const double _shakeThreshold = 12.0;

// Menos sensível (precisa shake forte):
static const double _shakeThreshold = 20.0;
```

---

## 🎯 Cenário 4: GPS - Adicionar Localização

**Objetivo:** Capturar localização GPS e converter em endereço

### Passos:

1. ✅ Criar/editar tarefa

2. ✅ Clicar no botão **📍 Adicionar Localização**

3. ✅ **Permitir Localização:**
   - Dialog de permissão aparece (primeira vez)
   - Clicar em **"Permitir"** ou **"Permitir enquanto usa app"**

4. ✅ **Modal de Localização Abre:**
   - Botão **"📍 Usar Localização Atual"**
   - Campo de busca por endereço
   - Informações da localização

5. ✅ **Opção A: Usar GPS Atual**
   - Clicar em **"📍 Usar Localização Atual"**
   - Loading aparece
   - Coordenadas capturadas: `-19.9167, -43.9345`
   - Geocoding: `Av. Afonso Pena, 1000, Belo Horizonte - MG`
   - Clicar em **"Confirmar Localização"**

6. ✅ **Opção B: Buscar Endereço**
   - Digitar: "Praça da Liberdade, Belo Horizonte"
   - Clicar em 🔍 **Buscar**
   - Coordenadas encontradas
   - Clicar em **"Confirmar Localização"**

7. ✅ **Verificar na Tarefa:**
   - Badge **📍** aparece
   - Endereço exibido abaixo do título
   - Console: `✅ Localização salva: -19.9167, -43.9345`

8. ✅ **Salvar Tarefa:**
   - Tarefa salva com localização
   - Badge **📍** visível na lista

**✅ Resultado esperado:** 
- GPS funciona
- Geocoding converte coordenadas → endereço
- Busca converte endereço → coordenadas

---

## 🎯 Cenário 5: Filtro de Tarefas Próximas (GPS)

**Objetivo:** Encontrar tarefas próximas à localização atual

### Preparação:

1. ✅ Criar 3 tarefas com localizações diferentes:
   - "Comprar na padaria" → GPS da sua casa
   - "Reunião no escritório" → Endereço comercial
   - "Academia" → GPS de outro bairro

### Teste:

2. ✅ **Aplicar Filtro:**
   - Menu (⋮) no AppBar
   - Selecionar **"📍 Próximas"**
   - Dialog de permissão (se necessário)

3. ✅ **Observar Resultado:**
   - GPS captura localização atual
   - Calcula distância até cada tarefa
   - Filtra tarefas dentro de **5km** (raio padrão)
   - Console: `📍 5 tarefas próximas encontradas`

4. ✅ **SnackBar Mostra:**
   ```
   📍 5 tarefas próximas (raio: 5km)
   ```

5. ✅ **Verificar Lista:**
   - Apenas tarefas próximas aparecem
   - Badge de distância pode ser exibido

**✅ Resultado esperado:** Filtro geográfico funciona corretamente

---

## 🎯 Cenário 6: Fluxo Completo Integrado

**Objetivo:** Demonstrar todos recursos juntos

### Passos:

1. ✅ **Criar Tarefa Completa:**
   - Título: "Visitar cliente XYZ"
   - Descrição: "Apresentar proposta"
   - Prioridade: Alta
   - **📷 Adicionar 2 fotos:**
     - Foto 1: Documento do cliente
     - Foto 2: Mapa de localização
   - **📍 Adicionar GPS:**
     - Usar localização atual
     - Ou buscar: "Av. Exemplo, 123"
   - Data de vencimento: Amanhã
   - Salvar

2. ✅ **Verificar Card na Lista:**
   - ✅ Badge de prioridade: **🔴 Alta**
   - ✅ Badge de fotos: **📷 2**
   - ✅ Badge de localização: **📍**
   - ✅ Endereço exibido
   - ✅ Data de vencimento

3. ✅ **Completar com Shake:**
   - Fazer gesto de shake
   - Selecionar "Visitar cliente XYZ"
   - ✅ Completada com badge **📳 Shake**
   - ✅ Vibração de feedback

4. ✅ **Editar Tarefa:**
   - Clicar na tarefa
   - Adicionar mais 1 foto
   - Atualizar descrição
   - Salvar

5. ✅ **Filtrar por Localização:**
   - Menu → **Próximas**
   - Ver apenas tarefas próximas

**✅ Resultado esperado:** Todos recursos funcionam em conjunto

---

## 🎯 Cenário 7: Gerenciamento de Fotos

**Objetivo:** Testar CRUD de fotos

### Passos:

1. ✅ **Adicionar Fotos:**
   - Criar tarefa
   - Adicionar 4 fotos diferentes

2. ✅ **Visualizar Carrossel:**
   - Miniaturas aparecem em linha horizontal
   - Scroll horizontal se necessário

3. ✅ **Ampliar Foto:**
   - Tocar em uma miniatura
   - Foto abre em fullscreen
   - Pinch-to-zoom funciona
   - Voltar com ✕

4. ✅ **Remover Foto Individual:**
   - Clicar no ✕ vermelho de uma foto
   - Foto removida
   - Carrossel atualiza

5. ✅ **Deletar Tarefa com Fotos:**
   - Deletar tarefa inteira
   - Arquivos de foto também deletados do storage
   - Console: `🗑️ Foto deletada: /path/to/image`

**✅ Resultado esperado:** Gerenciamento completo de fotos funciona

---

## 🎯 Cenário 8: Permissões

**Objetivo:** Testar fluxo de permissões

### A) Primeira Vez (Permissão Não Concedida)

1. ✅ **Câmera:**
   - Clicar em 📷
   - Dialog: "O app precisa de permissão para acessar a câmera"
   - Clicar "Permitir"
   - Câmera abre

2. ✅ **GPS:**
   - Clicar em 📍
   - Dialog: "Permitir acesso à localização?"
   - Escolher "Permitir enquanto usa o app"
   - GPS captura localização

### B) Permissão Negada

3. ✅ **Negar Permissão:**
   - Instalar app novamente (ou limpar dados)
   - Clicar em 📷
   - Clicar "Negar"
   - SnackBar: "⚠️ Permissão de câmera negada"

4. ✅ **Conceder Depois:**
   - Configurações → Apps → Task Manager → Permissões
   - Ativar "Câmera"
   - Voltar ao app
   - Clicar 📷 novamente
   - Funciona!

### C) Permissão Permanentemente Negada

5. ✅ **Simular Negação Permanente:**
   - Negar permissão 2x seguidas
   - Console: `⚠️ Permissão negada permanentemente`
   - SnackBar: "Ative a permissão nas configurações"

**✅ Resultado esperado:** Fluxo de permissões robusto e claro

---

## 🎯 Cenário 9: Geocoding Bidirecional

**Objetivo:** Testar conversão coordenadas ↔ endereço

### A) Reverse Geocoding (Coordenadas → Endereço)

1. ✅ Criar tarefa
2. ✅ Adicionar localização → **Usar Localização Atual**
3. ✅ **Verificar:**
   - Coordenadas: `-19.9167, -43.9345`
   - Endereço: `Av. Afonso Pena, 1000, Belo Horizonte - MG, Brasil`
   - Console: `📍 Geocoding: Av. Afonso Pena...`

### B) Geocoding (Endereço → Coordenadas)

4. ✅ Criar outra tarefa
5. ✅ Adicionar localização → **Buscar endereço**
6. ✅ Digitar: `Praça da Liberdade, Belo Horizonte`
7. ✅ Clicar 🔍 **Buscar**
8. ✅ **Verificar:**
   - Coordenadas encontradas: `-19.9330, -43.9378`
   - Endereço exibido: `Praça da Liberdade, Funcionários...`
   - Console: `✅ Coordenadas encontradas: -19.9330, -43.9378`

**✅ Resultado esperado:** Ambas conversões funcionam

---

## 🎯 Cenário 10: Proximidade (Haversine)

**Objetivo:** Calcular distância entre localizações

### Preparação:

1. ✅ Criar 5 tarefas em locais diferentes:
   - **Casa** (localização atual)
   - **Trabalho** (5km de distância)
   - **Academia** (2km de distância)
   - **Mercado** (500m de distância)
   - **Outra Cidade** (50km de distância)

### Teste:

2. ✅ Aplicar filtro **"📍 Próximas"**

3. ✅ **Verificar Console:**
   ```
   📍 Calculando distâncias...
   ✓ Casa: 0m
   ✓ Mercado: 500m
   ✓ Academia: 2km
   ✓ Trabalho: 5km
   ✗ Outra Cidade: 50km (fora do raio)
   ```

4. ✅ **Lista Filtrada Mostra:**
   - 4 tarefas (dentro de 5km)
   - "Outra Cidade" não aparece

5. ✅ **SnackBar:**
   ```
   📍 4 tarefas próximas (raio: 5km)
   ```

**✅ Resultado esperado:** Cálculo de distância preciso

---

## 🎯 Cenário 11: Calibração de Shake

**Objetivo:** Ajustar sensibilidade do acelerômetro

### Teste de Sensibilidade:

1. ✅ **Shake Suave:**
   - Movimento leve
   - **NÃO** deve detectar
   - Threshold: 15.0 m/s²

2. ✅ **Shake Moderado:**
   - Movimento normal
   - **DEVE** detectar
   - Magnitude: 15-20 m/s²

3. ✅ **Shake Vigoroso:**
   - Movimento forte
   - **DEVE** detectar
   - Magnitude: 20-30 m/s²

### Ajustar se Necessário:

```dart
// lib/services/sensor_service.dart

// Muito sensível (detecta qualquer movimento):
static const double _shakeThreshold = 12.0;

// Padrão (recomendado):
static const double _shakeThreshold = 15.0;

// Pouco sensível (precisa shake forte):
static const double _shakeThreshold = 20.0;
```

**✅ Resultado esperado:** Detecção confiável sem falsos positivos

---

## 🎯 Cenário 12: Badges Visuais

**Objetivo:** Validar todos os indicadores visuais

### Verificar Badges nas Tarefas:

#### 1. **Badge de Fotos** 📷
   - Aparece se `task.photos.isNotEmpty`
   - Mostra número: **📷 3**
   - Cor: Azul

#### 2. **Badge de Localização** 📍
   - Aparece se `task.hasLocation`
   - Mostra endereço resumido
   - Cor: Verde

#### 3. **Badge de Shake** 📳
   - Aparece se `task.completedBy == 'shake'`
   - Texto: **"📳 Shake"**
   - Cor: Roxo

#### 4. **Badge de Prioridade**
   - 🔴 Urgente
   - 🟠 Alta
   - 🟡 Média
   - 🟢 Baixa

#### 5. **Badge de Data**
   - 📅 Data de vencimento
   - ⏰ Vencido (vermelho)

### Tarefa Completa Deve Ter:
```
┌─────────────────────────────────────────┐
│ ☑ Visitar cliente                      │
│ Apresentar proposta comercial           │
│                                         │
│ 🔴 Alta  📷 2  📍 Centro  📅 Amanhã     │
└─────────────────────────────────────────┘
```

**✅ Resultado esperado:** Todos badges visíveis e corretos

---

## 🎯 Cenário 13: Persistência de Recursos

**Objetivo:** Garantir fotos e GPS persistem

### Passos:

1. ✅ Criar tarefa com:
   - 3 fotos
   - Localização GPS
   - Prioridade Alta

2. ✅ **Fechar App Completamente:**
   - Matar processo (não apenas minimizar)
   - **Android:** Recent Apps → Fechar
   - **iOS:** Swipe up → Fechar

3. ✅ **Reabrir App:**
   - Abrir novamente
   - Tarefa ainda está lá

4. ✅ **Verificar Integridade:**
   - ✅ 3 fotos ainda carregam
   - ✅ Localização ainda presente
   - ✅ Todos badges corretos
   - ✅ Fotos podem ser visualizadas

5. ✅ **Testar Edição:**
   - Editar tarefa
   - Adicionar mais 1 foto
   - Salvar
   - Total: 4 fotos

**✅ Resultado esperado:** 
- Fotos persistem no storage local
- GPS persiste no SQLite
- Tudo recuperado após reabrir

---

## 🎯 Cenário 14: Performance

**Objetivo:** Validar performance com muitos recursos

### Teste de Carga:

1. ✅ **Criar 10 Tarefas:**
   - Todas com 3 fotos cada
   - Todas com localização GPS
   - Mix de prioridades

2. ✅ **Verificar:**
   - Lista carrega rápido (< 1s)
   - Scroll suave (60 fps)
   - Miniaturas carregam sem lag
   - Console: Tempo de carregamento

3. ✅ **Testar Shake com 10 Tarefas:**
   - Fazer shake
   - Dialog mostra 3 primeiras tarefas
   - Texto: "...e mais 7 tarefas"
   - Performance mantida

**✅ Resultado esperado:** App performático mesmo com muitos recursos

---

## 🔍 **Console Logs Esperados**

### Durante Inicialização:
```
✅ CameraService: 1 câmera(s) encontrada(s)
📱 Detecção de shake iniciada
```

### Durante Uso de Câmera:
```
✅ Foto salva: /data/user/.../images/task_1702500000.jpg
📷 Foto adicionada à tarefa
```

### Durante Uso de GPS:
```
✅ Permissão de localização concedida
📍 Localização capturada: -19.9167, -43.9345
📍 Geocoding: Av. Afonso Pena, 1000...
```

### Durante Shake:
```
🔳 Shake! Magnitude: 18.45
📳 Vibração ativada
✅ Tarefa completada por shake: Comprar pão
```

### Durante Filtro Próximas:
```
📍 Buscando tarefas próximas...
📍 Raio: 5000m
✓ Tarefa 1: 0m
✓ Tarefa 2: 1200m
✗ Tarefa 3: 8500m (fora do raio)
📍 2 tarefas próximas encontradas
```

---

## 🐛 **Troubleshooting**

### **Problema: Câmera não abre**

```bash
# Verificar permissões no AndroidManifest.xml
<uses-permission android:name="android.permission.CAMERA"/>

# Verificar inicialização no main.dart
await CameraService.instance.initialize();

# Console deve mostrar:
✅ CameraService: 1 câmera(s) encontrada(s)
```

### **Problema: Shake muito sensível/insensível**

```dart
// Ajustar threshold em lib/services/sensor_service.dart
static const double _shakeThreshold = 15.0;  // Ajustar valor
```

### **Problema: GPS não funciona**

```bash
# 1. Verificar se GPS está ativo no dispositivo
# 2. Verificar permissões
# 3. Testar em área aberta (não funciona bem em ambientes fechados)

# Console deve mostrar:
✅ Permissão de localização concedida
```

### **Problema: Fotos não aparecem após reabrir app**

```dart
// Verificar se caminhos estão sendo salvos corretamente
print('Foto salva em: $photoPath');

// Verificar se arquivo existe
final file = File(photoPath);
print('Arquivo existe: ${await file.exists()}');
```

### **Problema: Geocoding falha**

```
❌ Erro comum: Endereço muito vago
✅ Solução: Usar endereços completos

Incorreto: "perto da praça"
Correto: "Praça da Liberdade, Belo Horizonte, MG"
```

---

## ✅ **Checklist de Validação**

### Hardware:
- [ ] Câmera inicializa
- [ ] Fotos são capturadas
- [ ] Fotos são salvas no storage
- [ ] Miniaturas aparecem
- [ ] Visualização fullscreen funciona
- [ ] Galeria de fotos funciona
- [ ] Shake é detectado
- [ ] Vibração funciona
- [ ] GPS captura coordenadas
- [ ] Geocoding funciona
- [ ] Reverse geocoding funciona

### Persistência:
- [ ] Fotos persistem após fechar app
- [ ] Localizações persistem
- [ ] Deletar tarefa remove fotos

### UI/UX:
- [ ] Badges de foto aparecem
- [ ] Badges de localização aparecem
- [ ] Badge de shake aparece
- [ ] Carrossel de fotos scroll suave
- [ ] Dialog de shake bem formatado
- [ ] Loading states visíveis

### Performance:
- [ ] App não trava ao tirar foto
- [ ] Múltiplas fotos não causam lag
- [ ] GPS não bloqueia UI
- [ ] Shake detection não impacta bateria

---

## 📊 **Métricas de Sucesso**

### ✅ **PASSOU** se:
1. Todos os 3 recursos funcionam (câmera, GPS, shake)
2. Permissões são solicitadas corretamente
3. Dados persistem após fechar app
4. Performance mantida (sem lag)
5. Badges visuais corretos
6. Console logs informativos

### ❌ **FALHOU** se:
1. Câmera não abre
2. GPS não captura localização
3. Shake não detecta ou detecta demais
4. Fotos perdidas após reabrir app
5. App trava ao usar recursos
6. Permissões não funcionam

---

## 🎓 **Conceitos Demonstrados**

### 1. **Plugin Flutter**
```dart
// Comunicação Flutter ↔ Código Nativo
camera: ^0.10.5          # iOS/Android native camera
geolocator: ^10.1.0      # GPS platform channels
sensors_plus: ^4.0.2     # Sensor streams
```

### 2. **Async/Await com Hardware**
```dart
// Operações assíncronas
final position = await Geolocator.getCurrentPosition();
final photo = await CameraService.takePicture();
```

### 3. **Streams de Sensores**
```dart
// Stream contínuo de dados
accelerometerEvents.listen((event) {
  // Processar eventos em tempo real
});
```

### 4. **Sistema de Permissões**
```dart
// Runtime permissions (Android 6+, iOS sempre)
final permission = await Geolocator.requestPermission();
```

### 5. **File System**
```dart
// Storage local persistente
final appDir = await getApplicationDocumentsDirectory();
await File(image.path).copy(savePath);
```

---

## 🏆 **Exercícios Extras Implementados**

✅ **1. Galeria de Fotos** - Implementado  
✅ **2. Múltiplas Fotos** - Implementado (carrossel)  
✅ **3. Shake Detection** - Implementado  
✅ **4. GPS + Geocoding** - Implementado  
⬜ **5. Mapa Interativo** - Não implementado (opcional)  
⬜ **6. Geofencing** - Não implementado (opcional)  
⬜ **7. Filtros de Foto** - Não implementado (opcional)  

---

## 📱 **Diferenças por Plataforma**

### **Web:**
- ⚠️ Câmera usa **webcam** (não câmera traseira)
- ⚠️ Shake **não funciona** (sem acelerômetro)
- ⚠️ GPS pode ter **precisão reduzida**
- ⚠️ Vibração **não funciona**
- ✅ Galeria funciona (upload de arquivos)

### **Android:**
- ✅ **Todos recursos funcionam**
- ✅ Câmera traseira/frontal
- ✅ Shake preciso
- ✅ GPS com alta precisão
- ✅ Vibração funciona

### **iOS:**
- ✅ **Todos recursos funcionam**
- ✅ Qualidade de câmera superior
- ✅ GPS com alta precisão
- ⚠️ Permissões mais restritivas

### **Windows Desktop:**
- ✅ Webcam funciona
- ⚠️ GPS limitado (sem hardware)
- ⚠️ Shake não funciona
- ⚠️ Vibração não funciona

---

## 🎬 **Conclusão**

Este roteiro demonstra a integração completa de recursos nativos em Flutter:

✅ **Câmera:** Captura e gerenciamento de múltiplas fotos  
✅ **GPS:** Localização precisa com geocoding bidirecional  
✅ **Sensores:** Shake detection com feedback tátil  
✅ **Permissões:** Fluxo robusto de runtime permissions  
✅ **Persistência:** Todos recursos salvos localmente  
✅ **UX:** Indicadores visuais claros e intuitivos  

**RECURSOS NATIVOS 100% FUNCIONAIS!** 🎉📱✨
