import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_guide/app.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: StudentGuideApp(flavor: AppFlavor.student)));
    expect(find.byType(StudentGuideApp), findsOneWidget);
  });
}
