class MarketVisitModel {
  final bool status;
  final int code;
  final String message;
  final MarketVisitDataModel data;

  MarketVisitModel({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory MarketVisitModel.fromJson(Map<String, dynamic> json) {
    return MarketVisitModel(
      status: json['status'] as bool,
      code: json['code'] as int,
      message: json['message'] as String,
      data: MarketVisitDataModel.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class MarketVisitDataModel {
  final String marketId;
  final DateTime updatedAt;
  final DateTime createdAt;
  final int id;

  MarketVisitDataModel({
    required this.marketId,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory MarketVisitDataModel.fromJson(Map<String, dynamic> json) {
    return MarketVisitDataModel(
      marketId: json['market_id'] as String,
      updatedAt: DateTime.parse(json['updated_at']),
      createdAt: DateTime.parse(json['created_at']),
      id: json['id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'market_id': marketId,
      'updated_at': updatedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'id': id,
    };
  }
}
