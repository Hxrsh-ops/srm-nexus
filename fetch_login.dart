import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

void main() async {
  final response = await http.get(Uri.parse('https://sp.srmist.edu.in/srmiststudentportal/students/loginManager/youLogin.jsp'));
  
  var document = parser.parse(response.body);
  
  var form = document.querySelector('form');
  print('Form action: ${form?.attributes['action']}');
  
  var inputs = document.querySelectorAll('input');
  for (var input in inputs) {
    print('Input: type=${input.attributes['type']}, name=${input.attributes['name']}, value=${input.attributes['value']}');
  }

  var img = document.querySelector('#captchaImg');
  print('Captcha IMG HTML: ${img?.outerHtml}');
  
  var scripts = document.querySelectorAll('script');
  for (var script in scripts) {
    if (script.text.contains('captcha')) {
      print('Script contains captcha:\n${script.text}');
    }
  }
}
