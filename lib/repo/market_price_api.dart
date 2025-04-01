import 'package:http/http.dart' as http;
import 'dart:convert';

class MarketPricesRepository {
  static const String _baseUrl =
      'https://api.data.gov.in/resource/35985678-0d79-46b4-9ed6-6f13308a1d24';
  static const String _apiKey =
      '579b464db66ec23bdd000001cdd3946e44ce4aad7209ff7b23ac571b';

  Future<List<dynamic>> fetchMarketPrices() async {
    final url = Uri.parse('$_baseUrl?api-key=$_apiKey&format=json');

    try {
      final response = await http.get(
        url,
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print(data);
        return data['records'];
      } else {
        throw Exception(
          'Failed to load market prices: Status ${response.statusCode}',
        );
      }
    } catch (e) {
      // Log the error for debugging (you can replace print with a logging library later)
      print('Error fetching market prices: $e');
      // Re-throw the exception to let the caller (e.g., ViewModel) handle it
      throw Exception('Error fetching market prices: $e');
    }
  }
}
