import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/app_config.dart';
import '../models/ticket_scan_request.dart';
import '../models/ticket_scan_response.dart';

class TicketScanService {
  static const String _baseUrl = AppConfig.baseUrl;
  static const String _scanEndpoint = AppConfig.scanEndpoint;

  /// Scan a ticket using the API
  static Future<TicketScanResponse> scanTicket(TicketScanRequest request) async {
    try {
      final url = Uri.parse('$_baseUrl$_scanEndpoint');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      ).timeout(AppConfig.apiTimeout);

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return TicketScanResponse.fromJson(responseData);
      } else {
        // Handle error responses
        return TicketScanResponse(
          success: false,
          message: responseData['error'] ?? 'Unknown error occurred',
          error: responseData['error'],
        );
      }
    } catch (e) {
      // Handle network errors, timeouts, etc.
      return TicketScanResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
        error: e.toString(),
      );
    }
  }

  /// Validate ticket code format (UCI-XXXXXX)
  static bool isValidTicketCode(String ticketCode) {
    final regex = RegExp(r'^UCI-\d{6}$');
    return regex.hasMatch(ticketCode);
  }
}
