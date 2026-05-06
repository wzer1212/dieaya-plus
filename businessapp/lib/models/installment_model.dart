

class InstallmentWay {
  final int id;
  final String nameAr;
  final String nameEn;
  final String image;
  final int status;
  final String? createdAt;
  final String? updatedAt;

  InstallmentWay({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.image,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory InstallmentWay.fromJson(Map<String, dynamic> json) {
    return InstallmentWay(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      image: json['image'] as String,
      status: json['status'] as int,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
      'image': image,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

