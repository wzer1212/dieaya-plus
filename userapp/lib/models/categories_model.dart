class kCategory {
  final int id;
  final String nameAr;
  final String nameEn;
  final String image;
  final int sort;

  kCategory({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.image,
    required this.sort,
  });

  factory kCategory.fromJson(Map<String, dynamic> json) {
    return kCategory(
      id: json['id'] ?? 0,
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      image: json['image'] ?? '',
      sort: json['sort'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
      'image': image,
      'sort': sort,
    };
  }
}