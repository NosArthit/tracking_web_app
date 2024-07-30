import 'package:http/http.dart' as http;

class TrackingApiService {
  static const String _baseUrl = 'http://localhost:3000/api/tracking';

  Future<http.Response> fetchLatestData(String imei) {
    return http.get(Uri.parse('$_baseUrl/latest_data?imei=$imei'));
  }

  Future<http.Response> fetchDataByDateRange(String imei, String startDate, String endDate) {
    return http.get(Uri.parse('$_baseUrl/data_by_date_range?imei=$imei&startDate=$startDate&endDate=$endDate'));
  }
}
