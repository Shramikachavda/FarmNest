import 'package:http/http.dart' as http;
import 'dart:convert';

class MarketPricesRepository {
  static const String _baseUrl =
      'https://api.data.gov.in/resource/35985678-0d79-46b4-9ed6-6f13308a1d24';
  static const String _apiKey =
 '579b464db66ec23bdd0000016efb0dcc79954ce86609a7759283ee23';

  Future<List<dynamic>> fetchMarketPrices({
    String? state,
    String? commodity,
    String? dateFilter, // e.g., "01/04/2025"
  }) async {
    final queryParams = {
      'api-key': _apiKey,
      'format': 'json',
      'limit': '10',
      if (state != null) 'filters[State]': state,
      if (commodity != null) 'filters[Commodity]': commodity,
      if (dateFilter != null) 'filters[Arrival_Date]': dateFilter,
    };
    final url = Uri.parse(_baseUrl).replace(queryParameters: queryParams);

    try {
      final response = await http.get(
        url,
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('API Response: $data'); // Debug: Check the response
        return data['records'] ?? []; // Return empty list if records is null
      } else {
        print(
          'API Error: Status ${response.statusCode}, Body: ${response.body}',
        );
        return []; // Return empty list on error
      }
    } catch (e) {
      print('Exception fetching market prices: $e');
      return []; // Return empty list on exception
    }
  }
}
