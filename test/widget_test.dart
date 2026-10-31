
import 'package:flutter_test/flutter_test.dart';
import 'package:nabila_apps/main.dart';

void main() {
  testWidgets('NABILA APPS menampilkan halaman login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NabilaApps());

    expect(find.text('NABILA APPS'), findsOneWidget);
    expect(find.text('Aplikasi Informasi Akademik'), findsOneWidget);
    expect(find.text('LOGIN'), findsOneWidget);
  });
}
