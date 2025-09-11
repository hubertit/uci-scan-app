import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../data/models/ticket_scan_request.dart';
import '../../data/models/ticket_scan_response.dart';
import '../../data/services/ticket_scan_service.dart';

class TicketDetailsScreen extends ConsumerStatefulWidget {
  final String ticketId;

  const TicketDetailsScreen({
    super.key,
    required this.ticketId,
  });

  @override
  ConsumerState<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends ConsumerState<TicketDetailsScreen> {
  bool isLoading = true;
  TicketScanResponse? scanResponse;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTicketData();
  }

  Future<void> _fetchTicketData() async {
    try {
      // Validate ticket code format
      if (!TicketScanService.isValidTicketCode(widget.ticketId)) {
        setState(() {
          errorMessage = 'Invalid ticket code format. Expected format: UCI-XXXXXX';
          isLoading = false;
        });
        return;
      }

      // Create scan request
      final request = TicketScanRequest(
        ticketCode: widget.ticketId,
        scannedBy: 'Scanner App', // You can make this configurable
        scanLocation: 'Mobile Scanner', // You can make this configurable
        scanDeviceId: 'MOBILE-001', // You can make this configurable
      );

      // Call the API
      final response = await TicketScanService.scanTicket(request);
      
      setState(() {
        scanResponse = response;
        isLoading = false;
        if (!response.success) {
          errorMessage = response.error ?? response.message;
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch ticket data: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Ticket Details'),
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                ),
              )
            : errorMessage != null
                ? _buildErrorState()
                : scanResponse != null
                    ? _buildTicketDetails()
                    : const SizedBox(),
      ),
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacing24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppTheme.errorColor,
          ),
          const SizedBox(height: AppTheme.spacing16),
          Text(
            'Error',
            style: AppTheme.headlineSmall.copyWith(
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            errorMessage!,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacing24),
          PrimaryButton(
            label: 'Try Again',
            onPressed: () {
              setState(() {
                isLoading = true;
                errorMessage = null;
                scanResponse = null;
              });
              _fetchTicketData();
            },
            icon: Icons.refresh,
          ),
        ],
      ),
    );
  }

  Widget _buildTicketDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ticket ID Card
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing20),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                  ),
                  child: const Icon(
                    Icons.qr_code,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppTheme.spacing16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ticket ID',
                        style: AppTheme.titleMedium.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing4),
                      Text(
                        scanResponse?.ticket?.ticketCode ?? widget.ticketId,
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textPrimaryColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppTheme.spacing16),
          
          // Package & Date Card
          if (scanResponse?.package != null) _buildPackageCard(),
          
          const SizedBox(height: AppTheme.spacing16),
          
          // Ticket Type Indicator
          _buildTicketTypeIndicator(),
          
          const SizedBox(height: AppTheme.spacing16),
          
          // Area Indicator
          if (scanResponse?.ticket?.seatArea != null) _buildAreaIndicator(),
          
          const SizedBox(height: AppTheme.spacing16),
          
          // Ticket Information
          Text(
            'Ticket Information',
            style: AppTheme.titleLarge.copyWith(
              color: AppTheme.textPrimaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spacing16),
          
          _buildInfoCard(),
          
          const SizedBox(height: AppTheme.spacing16),
          
          // Actions
          PrimaryButton(
            label: 'Scan Another Ticket',
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icons.qr_code_scanner,
          ),
          
          const SizedBox(height: AppTheme.spacing8),
          
          PrimaryButton(
            label: 'Back to Home',
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            backgroundColor: AppTheme.surfaceColor,
            textColor: AppTheme.primaryColor,
            icon: Icons.home,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
        border: Border.all(
          color: AppTheme.borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          if (scanResponse?.customer?.name != null)
            _buildInfoRow('Attendee', scanResponse!.customer!.name),
          if (scanResponse?.customer?.email != null)
            _buildInfoRow('Email', scanResponse!.customer!.email),
          if (scanResponse?.order?.orderCode != null)
            _buildInfoRow('Order Code', scanResponse!.order!.orderCode),
          if (scanResponse?.ticket?.ticketStatus != null)
            _buildInfoRow('Status', scanResponse!.ticket!.ticketStatus.toUpperCase()),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: Text(
              value,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketTypeIndicator() {
    final ticketType = scanResponse?.ticket?.ticketStatus == 'active' ? 'ACTIVE' : 'USED';
    final frameColor = scanResponse?.ticket?.ticketStatus == 'active' 
        ? AppTheme.successColor 
        : AppTheme.errorColor;
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      decoration: BoxDecoration(
        color: frameColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
        border: Border.all(
          color: frameColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: frameColor,
              borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
            ),
            child: const Icon(
              Icons.confirmation_number,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: AppTheme.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ticket Status',
                  style: AppTheme.titleMedium.copyWith(
                    color: frameColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing4),
                Text(
                  ticketType,
                  style: AppTheme.bodyLarge.copyWith(
                    color: AppTheme.textPrimaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing4),
                Text(
                  scanResponse?.ticket?.ticketStatus == 'active' 
                      ? 'This ticket is valid and ready to use'
                      : 'This ticket has already been used',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaIndicator() {
    final area = scanResponse?.ticket?.seatArea ?? 'Unknown';
    final isSales = area.toLowerCase() == 'sales';
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      decoration: BoxDecoration(
        color: isSales 
            ? Colors.blue.withOpacity(0.1) 
            : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
        border: Border.all(
          color: isSales 
              ? Colors.blue.withOpacity(0.3) 
              : Colors.green.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSales ? Colors.blue : Colors.green,
              borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
            ),
            child: Icon(
              isSales ? Icons.shopping_cart : Icons.business,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: AppTheme.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seating Area',
                  style: AppTheme.titleMedium.copyWith(
                    color: isSales ? Colors.blue : Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing4),
                Text(
                  area,
                  style: AppTheme.bodyLarge.copyWith(
                    color: AppTheme.textPrimaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing4),
                Text(
                  isSales 
                      ? 'General admission seating area'
                      : 'VIP and premium seating area',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageCard() {
    final package = scanResponse!.package!;
    final isUsed = scanResponse?.ticket?.ticketStatus == 'used';
    final cardColor = isUsed ? AppTheme.errorColor : AppTheme.successColor;
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
        border: Border.all(
          color: cardColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                ),
                child: const Icon(
                  Icons.event,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppTheme.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Event Package',
                      style: AppTheme.titleMedium.copyWith(
                        color: cardColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing4),
                    Text(
                      package.packageTitle,
                      style: AppTheme.bodyLarge.copyWith(
                        color: AppTheme.textPrimaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing16),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing12),
            decoration: BoxDecoration(
              color: cardColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
              border: Border.all(
                color: cardColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: cardColor,
                  size: 20,
                ),
                const SizedBox(width: AppTheme.spacing8),
                Text(
                  'Event Date',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: AppTheme.spacing8),
                Expanded(
                  child: Text(
                    package.eventDate,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textPrimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTicketColor() {
    final package = scanResponse?.package;
    final seatArea = scanResponse?.ticket?.seatArea;
    
    if (package?.eventDate == null) {
      return AppTheme.primaryColor; // Default color
    }

    // Parse the date (assuming format like "2025-09-28" or "28/09/2025")
    final eventDate = package!.eventDate;
    String dayMonth = '';
    
    // Handle different date formats
    if (eventDate.contains('/')) {
      // Format: "28/09/2025" -> extract "28/9"
      final parts = eventDate.split('/');
      if (parts.length >= 2) {
        dayMonth = '${int.parse(parts[0])}/${int.parse(parts[1])}';
      }
    } else if (eventDate.contains('-')) {
      // Format: "2025-09-28" -> extract "28/9"
      final parts = eventDate.split('-');
      if (parts.length >= 3) {
        dayMonth = '${int.parse(parts[2])}/${int.parse(parts[1])}';
      }
    }

    // Check if it's a parking ticket (ignore as requested)
    if (package.packageTitle.toLowerCase().contains('parking')) {
      return AppTheme.primaryColor; // Default blue for parking
    }

    // Color logic based on date and seat area
    switch (dayMonth) {
      case '21/9':
        return Colors.yellow;
      
      case '22/9':
        return Colors.red;
      
      case '23/9':
        return Colors.blue;
      
      case '24/9':
        return Colors.green;
      
      case '25/9':
        return Colors.black;
      
      case '26/9':
        return Colors.blue;
      
      case '27/9':
        if (seatArea?.toLowerCase().contains('uci') == true || 
            seatArea?.toLowerCase().contains('loc') == true) {
          return Colors.red;
        } else if (seatArea?.toLowerCase().contains('sales') == true) {
          return Colors.yellow;
        }
        return Colors.blue;
      
      case '28/9':
        if (seatArea?.toLowerCase().contains('uci') == true || 
            seatArea?.toLowerCase().contains('loc') == true) {
          return Colors.green;
        } else if (seatArea?.toLowerCase().contains('sales') == true) {
          return Colors.black;
        }
        return Colors.blue;
      
      default:
        return AppTheme.primaryColor; // Default blue
    }
  }

}
