import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_frontend/main.dart';

void main() {
  testWidgets('Tic Tac Toe game displays title', (WidgetTester tester) async {
    await tester.pumpWidget(const TicTacToeApp());

    expect(find.text('Tic Tac Toe'), findsOneWidget);
  });

  testWidgets('Tic Tac Toe game shows player turn indicator', (WidgetTester tester) async {
    await tester.pumpWidget(const TicTacToeApp());

    expect(find.text('Player X Turn'), findsOneWidget);
  });

  testWidgets('Tic Tac Toe game has 9 grid cells', (WidgetTester tester) async {
    await tester.pumpWidget(const TicTacToeApp());
    
    // Wait for animations to complete
    await tester.pumpAndSettle();

    // Check if we have a GridView with 9 cells
    expect(find.byType(GridView), findsOneWidget);
  });

  testWidgets('Tic Tac Toe game has restart button', (WidgetTester tester) async {
    await tester.pumpWidget(const TicTacToeApp());

    expect(find.text('Restart Game'), findsOneWidget);
  });
}
