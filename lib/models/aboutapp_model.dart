// Response model for About Us and Privacy Policy APIs
class SettingsResponse {
  final bool? status;
  final int? code;
  final String? message;
  final String? data;

  SettingsResponse({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  factory SettingsResponse.fromJson(Map<String, dynamic> json) {
    return SettingsResponse(
      status: json['status'] as bool?,
      code: json['code'] as int?,
      message: json['message'] as String?,
      data: json['data'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'message': message,
      'data': data,
    };
  }
}