// Basic widget test untuk aplikasi Memix
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:misix/controllers/song_controller.dart';
import 'package:misix/screens/home_screen.dart';

void main() {
  testWidgets('Memix app launches without crashing', (WidgetTester tester) async {
    // Build the app dengan provider
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => SongController(),
        child: const MaterialApp(
          home: HomeScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );

    // Tunggu sampai semua animasi selesai
    await tester.pumpAndSettle();

    // Verifikasi bahwa HomeScreen muncul (tidak error)
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}