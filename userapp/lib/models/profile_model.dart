class ProfileResponse {
  final bool status;
  final int code;
  final String message;
  final CustomerProfile? data; // Made nullable since it might be null in JSON

  ProfileResponse({
    required this.status,
    required this.code,
    required this.message,
    this.data, // Changed to optional since it might be null
  });

  factory ProfileResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw FormatException('JSON cannot be null');
    }
    return ProfileResponse(
      status: json['status'] as bool? ?? false, // Default to false if null
      code: json['code'] as int? ?? 0, // Default to 0 if null
      message: json['message'] as String? ?? '', // Default to empty string if null
      data: json['data'] != null
          ? CustomerProfile.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'message': message,
      'data': data?.toJson(), // Handle null data
    };
  }
}

class CustomerProfile {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? image;
  final int isActive;
  final int block;
  final String createdAt;
  final String updatedAt;
  final int verified;
  final bool whatsappNotification;

  CustomerProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.image,
    required this.isActive,
    required this.block,
    required this.createdAt,
    required this.updatedAt,
    required this.verified,
    required this.whatsappNotification,
  });

  factory CustomerProfile.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw FormatException('JSON cannot be null');
    }
    return CustomerProfile(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      image: json['image'] as String?,
      isActive: json['is_active'] as int? ?? 0,
      block: json['block'] as int? ?? 0,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      verified: json['verified'] as int? ?? 0,
      whatsappNotification: json['whatsapp_notification'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
      'is_active': isActive,
      'block': block,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'verified': verified,
      'whatsapp_notification': whatsappNotification,
    };
  }
}