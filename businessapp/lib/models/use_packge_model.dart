import 'dart:convert';

class PackageUsageResponse {
  final bool status;
  final int code;
  final String message;
  final List<PackageUsage> data;

  PackageUsageResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory PackageUsageResponse.fromJson(Map<String, dynamic> json) {
    return PackageUsageResponse(
      status: json['status'] as bool,
      code: json['code'] as int,
      message: json['message'] as String,
      data: (json['data'] ['usages']as List<dynamic>)
          .map((item) => PackageUsage.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class PackageUsage {
  final String tag;
  final int? remaining;
  final bool isNone; // Flag to distinguish "none" from null


  PackageUsage({required this.tag, this.remaining, this.isNone = false});


  factory PackageUsage.fromJson(Map<String, dynamic> json) {
    // Parse remaining, handling String or int from API
    final remainingValue = json['remaining'];
    int? parsedRemaining;
    bool isNone = false;
    if (remainingValue is int) {
      parsedRemaining = remainingValue;
    } else if (remainingValue is String) {
      if (remainingValue.toLowerCase() == 'none') {
        parsedRemaining = null;
        isNone = true; // Mark as "none"
      } else {
        parsedRemaining = int.tryParse(remainingValue);
      }
    }
    print('Parsing PackageUsage: tag=${json['tag']}, remaining=$remainingValue, parsed=$parsedRemaining, isNone=$isNone');
    return PackageUsage(
      tag: json['tag'] as String,
      remaining: parsedRemaining,
      isNone: isNone,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tag': tag,
      'remaining': remaining,
    };
  }
}