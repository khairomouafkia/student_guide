import 'package:flutter_test/flutter_test.dart';
import 'package:student_guide/features/admin/pages/students_tools.dart';

void main() {
  test('parses header + rows, trims cells', () {
    final r = parseCsv('email,fullName,registrationNumber\n a@u.dz , Ali B ,2024-0001\nb@u.dz,Sara,2024-0002\n');
    expect(r.length, 2);
    expect(r[0], {'email': 'a@u.dz', 'fullName': 'Ali B', 'registrationNumber': '2024-0001'});
  });

  test('handles quotes, commas inside quotes, CRLF, BOM and semicolons', () {
    final r = parseCsv('\uFEFFemail;fullName\r\n"a@u.dz";"Benali, Ali"\r\n"b@u.dz";"He said ""hi"""\r\n');
    expect(r[0]['fullName'], 'Benali, Ali');
    expect(r[1]['fullName'], 'He said "hi"');
  });

  test('ignores blank lines; header-only or empty input gives no rows', () {
    expect(parseCsv('email,fullName\n\n\n').length, 0);
    expect(parseCsv('').length, 0);
    expect(parseCsv('email,fullName\na@u.dz,Ali').length, 1); // no trailing newline
  });
}
