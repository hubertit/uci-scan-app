class TicketScanResponse {
  final bool success;
  final String message;
  final TicketData? ticket;
  final OrderData? order;
  final PackageData? package;
  final CustomerData? customer;
  final String? error;

  const TicketScanResponse({
    required this.success,
    required this.message,
    this.ticket,
    this.order,
    this.package,
    this.customer,
    this.error,
  });

  factory TicketScanResponse.fromJson(Map<String, dynamic> json) {
    return TicketScanResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      ticket: json['ticket'] != null ? TicketData.fromJson(json['ticket']) : null,
      order: json['order'] != null ? OrderData.fromJson(json['order']) : null,
      package: json['package'] != null ? PackageData.fromJson(json['package']) : null,
      customer: json['customer'] != null ? CustomerData.fromJson(json['customer']) : null,
      error: json['error'],
    );
  }
}

class TicketData {
  final String ticketCode;
  final String ticketStatus;
  final String scanStatus;
  final String? scannedAt;
  final String? scannedBy;
  final String? scanLocation;
  final String? scanDeviceId;
  final String? seatArea;

  const TicketData({
    required this.ticketCode,
    required this.ticketStatus,
    required this.scanStatus,
    this.scannedAt,
    this.scannedBy,
    this.scanLocation,
    this.scanDeviceId,
    this.seatArea,
  });

  factory TicketData.fromJson(Map<String, dynamic> json) {
    return TicketData(
      ticketCode: json['ticket_code'] ?? '',
      ticketStatus: json['ticket_status'] ?? '',
      scanStatus: json['scan_status'] ?? '',
      scannedAt: json['scanned_at'],
      scannedBy: json['scanned_by'],
      scanLocation: json['scan_location'],
      scanDeviceId: json['scan_device_id'],
      seatArea: json['seat_area'],
    );
  }
}

class OrderData {
  final String orderCode;

  const OrderData({
    required this.orderCode,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      orderCode: json['order_code'] ?? '',
    );
  }
}

class PackageData {
  final String packageTitle;
  final String eventDate;

  const PackageData({
    required this.packageTitle,
    required this.eventDate,
  });

  factory PackageData.fromJson(Map<String, dynamic> json) {
    return PackageData(
      packageTitle: json['package_title'] ?? '',
      eventDate: json['event_date'] ?? '',
    );
  }
}

class CustomerData {
  final String name;
  final String email;

  const CustomerData({
    required this.name,
    required this.email,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
