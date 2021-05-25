import 'package:http/http.dart' as http;

class AccountApi {
  Future<void> getData() async {
    var client = http.Client();
    try {
      // https://wallet.elrosado.com:5479/api/AcercaDe
      var uriResponse = await client.get(Uri.parse('https://reqres.in/api/users?page=2'));
      print(uriResponse.body);
      } finally {
        client.close();
      }
  }
}