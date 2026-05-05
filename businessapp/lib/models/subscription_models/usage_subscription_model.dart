class UsageResponseModel {
  final bool status;
  final int code;
  final String message;
  final UsageInfo usageInfo;

  UsageResponseModel({
    required this.status,
    required this.code,
    required this.message,
    required this.usageInfo,
  });

  factory UsageResponseModel.fromJson(Map<String, dynamic> json) {
    return UsageResponseModel(
      status: json['status'],
      code: json['code'],
      message: json['message'],
      usageInfo: UsageInfo.fromJson(json['data'])
    );
  }
}

class UsageInfo {
  final String? packageName;
  final List<UsageData> data;
  final int totalDuration;
  final int remainDurationUsage;

  UsageInfo({
    required this.packageName,
    required this.data,
    required this.totalDuration,
    required this.remainDurationUsage,
  });

  factory UsageInfo.fromJson(Map<String, dynamic> json) => UsageInfo(
    packageName: json['package_name'],
        data: (json['usages'] as List)
            .map((item) => UsageData.fromJson(item))
            .toList(),
        remainDurationUsage: json['subscription_remaining_days']??0 ,
        totalDuration: json['subscription_total_days' ]??0,
      );
}

class UsageData {
  final String tag;
  final int? remaining;
  final int? total;
  final String? titleEn;
  final String? titleAr;

  UsageData({
    required this.tag,
    required this.remaining,
    required this.total,
    this.titleAr,
    this.titleEn,
  });

  factory UsageData.fromJson(Map<String, dynamic> json) {
    return UsageData(
      total: int.tryParse(json['total'].toString()),
      tag: json['tag'],
      remaining:  int.tryParse(json['remaining'].toString()),
      titleAr: json['title_ar'],
      titleEn: json['title_en'],
    );
  }
}
