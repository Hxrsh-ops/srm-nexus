import 'package:flutter_test/flutter_test.dart';
import 'package:srm_nexus/main.dart';

void main() {
  testWidgets('SRM Nexus smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SRMNexusApp());
  });
}
