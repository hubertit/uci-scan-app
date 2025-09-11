class TicketScanRequest {
  final String ticketCode;
  final String scannedBy;
  final String scanLocation;
  final String? scanDeviceId;

  const TicketScanRequest({
    required this.ticketCode,
    required this.scannedBy,
    required this.scanLocation,
    this.scanDeviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'ticket_code': ticketCode,
      'scanned_by': scannedBy,
      'scan_location': scanLocation,
      if (scanDeviceId != null) 'scan_device_id': scanDeviceId,
    };
  }
}
