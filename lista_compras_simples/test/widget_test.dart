// Teste básico do widget Flutter

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lista_compras_simples/main.dart';

void main() {
  testWidgets('Teste de adição de item na lista', (WidgetTester tester) async {
    // Constrói o app e dispara um frame
    await tester.pumpWidget(const MeuApp());

    // Verifica que a lista começa vazia
    expect(find.text('Sua lista está vazia!\nAdicione o primeiro item.'), findsOneWidget);
    expect(find.text('Total de itens: 0'), findsOneWidget);

    // Digita um item no campo de texto
    await tester.enterText(find.byType(TextField), 'Arroz');
    await tester.tap(find.text('Adicionar'));
    await tester.pump();

    // Verifica que o item foi adicionado
    expect(find.text('Arroz'), findsOneWidget);
    expect(find.text('Total de itens: 1'), findsOneWidget);
  });
}
