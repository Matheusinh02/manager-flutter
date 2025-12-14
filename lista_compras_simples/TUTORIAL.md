# 📱 Tutorial: App Lista de Compras em Flutter

Um guia completo e passo a passo para criar seu primeiro aplicativo Flutter funcional.

---

## 📋 Índice

1. [Pré-requisitos](#pré-requisitos)
2. [Criar Projeto](#criar-projeto)
3. [Construir o App](#construir-o-app)
4. [Adicionar Melhorias](#adicionar-melhorias)
5. [Como Rodar](#como-rodar)
6. [Funcionalidades](#funcionalidades)
7. [Próximos Passos](#próximos-passos)

---

## 🔧 Pré-requisitos

Certifique-se de ter instalado:

- ✅ Flutter SDK (3.0 ou superior)
- ✅ Visual Studio Code
- ✅ Extensão Flutter para VS Code
- ✅ Chrome ou outro navegador

Verificar instalação:
```bash
flutter doctor
```

---

## 🚀 PASSO 1: Criar Projeto

### Pelo Terminal:
```bash
flutter create lista_compras_simples
cd lista_compras_simples
code .
```

### Ou pelo VS Code:
1. Pressione `Ctrl + Shift + P`
2. Digite: `Flutter: New Project`
3. Selecione: `Application`
4. Escolha a pasta e nome do projeto

---

## 💻 PASSO 2: Código Principal

### Substituir `lib/main.dart`:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const PaginaInicial(),
    );
  }
}

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  List<String> itensCompra = [];
  List<bool> itensComprados = [];
  TextEditingController controladorTexto = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Lista de Compras'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: limparLista,
            tooltip: 'Limpar lista',
          ),
        ],
      ),
      
      body: Column(
        children: [
          // Campo de entrada
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controladorTexto,
                    decoration: const InputDecoration(
                      hintText: 'Digite um item para comprar...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.add_shopping_cart),
                    ),
                    onSubmitted: (texto) => adicionarItem(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: adicionarItem,
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          // Estatísticas
          if (itensCompra.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _criarEstatistica('Total', '${itensCompra.length}', Icons.list, Colors.blue),
                  _criarEstatistica('Comprados', '${itensComprados.where((c) => c).length}', Icons.check_circle, Colors.green),
                  _criarEstatistica('Restantes', '${itensComprados.where((c) => !c).length}', Icons.pending, Colors.orange),
                ],
              ),
            ),
          
          // Lista de itens
          Expanded(
            child: itensCompra.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        const Text('Sua lista está vazia!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const Text('Adicione itens para começar suas compras', style: TextStyle(fontSize: 16, color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: itensCompra.length,
                    itemBuilder: (context, indice) {
                      bool foiComprado = itensComprados[indice];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          leading: Checkbox(
                            value: foiComprado,
                            onChanged: (valor) => marcarComoComprado(indice, valor ?? false),
                          ),
                          title: Text(
                            itensCompra[indice],
                            style: TextStyle(
                              decoration: foiComprado ? TextDecoration.lineThrough : null,
                              color: foiComprado ? Colors.grey : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => mostrarConfirmacaoRemocao(indice),
                          ),
                          tileColor: foiComprado ? Colors.green[50] : null,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _criarEstatistica(String titulo, String valor, IconData icone, Color cor) {
    return Column(
      children: [
        Icon(icone, color: cor, size: 24),
        const SizedBox(height: 4),
        Text(valor, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: cor)),
        Text(titulo, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  void adicionarItem() {
    String novoItem = controladorTexto.text.trim();
    if (novoItem.isNotEmpty) {
      if (itensCompra.contains(novoItem)) {
        _mostrarMensagem('Este item já está na sua lista!');
        return;
      }
      setState(() {
        itensCompra.add(novoItem);
        itensComprados.add(false);
        controladorTexto.clear();
      });
      _mostrarMensagem('Item "$novoItem" adicionado!');
    }
  }

  void removerItem(int indice) {
    String itemRemovido = itensCompra[indice];
    setState(() {
      itensCompra.removeAt(indice);
      itensComprados.removeAt(indice);
    });
    _mostrarMensagem('Item "$itemRemovido" removido!');
  }

  void marcarComoComprado(int indice, bool comprado) {
    setState(() {
      itensComprados[indice] = comprado;
    });
    _mostrarMensagem(comprado ? 'Item comprado!' : 'Item desmarcado!');
  }

  void limparLista() {
    if (itensCompra.isEmpty) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Limpar Lista'),
          content: const Text('Tem certeza que deseja remover todos os itens?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  itensCompra.clear();
                  itensComprados.clear();
                });
                Navigator.of(context).pop();
                _mostrarMensagem('Lista limpa!');
              },
              child: const Text('Limpar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void mostrarConfirmacaoRemocao(int indice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remover Item'),
          content: Text('Remover "${itensCompra[indice]}" da lista?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                removerItem(indice);
                Navigator.of(context).pop();
              },
              child: const Text('Remover', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), duration: const Duration(seconds: 2)),
    );
  }

  @override
  void dispose() {
    controladorTexto.dispose();
    super.dispose();
  }
}
```

---

## ▶️ PASSO 3: Como Rodar o App

### Método 1: Terminal
```bash
# Ver dispositivos disponíveis
flutter devices

# Rodar no Chrome
flutter run -d chrome

# Rodar no Windows
flutter run -d windows

# Rodar no Edge
flutter run -d edge
```

### Método 2: VS Code
1. Pressione **F5**
2. Ou vá em `Run > Start Debugging`

### Método 3: Paleta de Comandos
1. `Ctrl + Shift + P`
2. Digite: `Flutter: Select Device`
3. Escolha o dispositivo
4. Digite: `Flutter: Run Flutter Application`

---

## ✨ Funcionalidades do App

### ✅ Adicionar Itens
- Digite o nome do item
- Clique em "Adicionar" ou pressione Enter
- Recebe notificação de confirmação

### ✅ Marcar como Comprado
- Clique na checkbox ao lado do item
- Item fica riscado e com fundo verde
- Estatísticas atualizam automaticamente

### ✅ Remover Itens
- Clique no ícone 🗑️ vermelho
- Confirme a remoção no diálogo
- Item é removido da lista

### ✅ Limpar Lista
- Clique no ícone no AppBar (canto superior direito)
- Confirme para remover todos os itens

### ✅ Estatísticas em Tempo Real
- **Total**: Quantidade total de itens
- **Comprados**: Itens marcados como comprados
- **Restantes**: Itens ainda não comprados

### ✅ Validações
- Impede adicionar itens duplicados
- Mostra mensagens de feedback
- Confirmações antes de ações destrutivas

---

## 🎯 Comandos Úteis Durante Execução

No terminal onde o app está rodando:

| Tecla | Ação |
|-------|------|
| `r` | Hot Reload (recarregar código) |
| `R` | Hot Restart (reiniciar app) |
| `q` | Quit (fechar app) |
| `h` | Help (lista de comandos) |
| `d` | Detach (desanexar mas manter rodando) |
| `c` | Clear (limpar console) |

---

## 🐛 Solução de Problemas

### Erro ao rodar no Chrome?
```bash
flutter config --enable-web
flutter clean
flutter pub get
flutter run -d chrome
```

### Erro ao rodar no Windows?
```bash
flutter doctor
# Instale o Visual Studio se necessário
```

### Erro de compilação?
```bash
flutter clean
flutter pub get
flutter run
```

### Atualizar dependências:
```bash
flutter pub upgrade
```

---

## 📚 Conceitos Flutter Aprendidos

### Widgets Utilizados:
- `MaterialApp` - App base com Material Design
- `Scaffold` - Estrutura básica da página
- `AppBar` - Barra superior
- `Column` & `Row` - Layout vertical e horizontal
- `ListView.builder` - Lista rolável
- `Card` - Cartões com elevação
- `ListTile` - Item de lista
- `TextField` - Campo de texto
- `ElevatedButton` - Botão elevado
- `IconButton` - Botão com ícone
- `Checkbox` - Caixa de seleção
- `AlertDialog` - Diálogo de confirmação
- `SnackBar` - Notificação temporária

### Conceitos:
- **StatefulWidget** - Widget com estado mutável
- **setState()** - Atualizar interface
- **TextEditingController** - Controlar input
- **List** - Estrutura de dados dinâmica
- **Navigator** - Navegação entre telas
- **BuildContext** - Contexto do widget

---

## 🚀 Próximos Passos

### Melhorias Possíveis:

1. **Persistência de Dados**
   ```bash
   flutter pub add shared_preferences
   ```
   - Salvar lista localmente
   - Manter dados após fechar o app

2. **Editar Itens**
   - Adicionar botão de editar
   - Permitir renomear itens

3. **Categorias**
   - Organizar por categorias (Frutas, Laticínios, etc.)
   - Filtros e ordenação

4. **Quantidade**
   - Adicionar campo de quantidade
   - Calcular total de itens

5. **Compartilhar Lista**
   ```bash
   flutter pub add share_plus
   ```
   - Compartilhar via WhatsApp, email, etc.

6. **Dark Mode**
   - Adicionar tema escuro
   - Alternar entre temas

7. **Busca**
   - Campo de busca na lista
   - Filtrar itens em tempo real

8. **Backup na Nuvem**
   ```bash
   flutter pub add firebase_core
   ```
   - Sincronizar com Firebase
   - Acessar de múltiplos dispositivos

---

## 📝 Estrutura do Projeto

```
lista_compras_simples/
├── lib/
│   └── main.dart          # Código principal do app
├── test/
│   └── widget_test.dart   # Testes automatizados
├── android/               # Configuração Android
├── ios/                   # Configuração iOS
├── web/                   # Configuração Web
├── windows/               # Configuração Windows
├── pubspec.yaml           # Dependências do projeto
└── README.md              # Documentação
```

---

## 🎓 Recursos para Aprender Mais

### Documentação Oficial:
- [Flutter.dev](https://flutter.dev)
- [Dart.dev](https://dart.dev)
- [API Reference](https://api.flutter.dev)

### Tutoriais:
- [Flutter Codelabs](https://flutter.dev/docs/codelabs)
- [Flutter Cookbook](https://flutter.dev/docs/cookbook)
- [Widget of the Week](https://www.youtube.com/playlist?list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG)

### Comunidade:
- [Flutter Community](https://flutter.dev/community)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- [Reddit r/FlutterDev](https://reddit.com/r/FlutterDev)

---

## 📄 Licença

Este projeto é livre para uso educacional e comercial.

---

## 👨‍💻 Autor

Criado como projeto educacional para aprender Flutter.

**Data:** 13 de dezembro de 2025

---

## 🎉 Parabéns!

Você criou seu primeiro app Flutter completo! 🚀

Continue praticando e explorando as possibilidades do Flutter!
