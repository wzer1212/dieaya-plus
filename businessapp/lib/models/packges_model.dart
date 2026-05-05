class PackageResponse {
  final bool? status;
  final int? code;
  final String? message;
  final List<Package>? data;

  PackageResponse({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  factory PackageResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return PackageResponse();
    }
    return PackageResponse(
      status: json['status'] as bool?,
      code: json['code'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => Package.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (status != null) 'status': status,
      if (code != null) 'code': code,
      if (message != null) 'message': message,
      if (data != null) 'data': data!.map((item) => item.toJson()).toList(),
    };
  }
}

class Package {
  final int? id;
  final String? nameAr;
  final String? nameEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final String? price;
  final String? IAPPackageId;
  final String? discount;
  final String? image;
  final String? days;
  final List<BoquetItem>? boquetItems;

  Package({
    this.days,
    this.IAPPackageId,
    this.id,
    this.nameAr,
    this.nameEn,
    this.descriptionAr,
    this.descriptionEn,
    this.price,
    this.discount,
    this.image,
    this.boquetItems,
  });

  factory Package.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Package();
    }
    return Package(
      IAPPackageId: json['apple_product_id'],
      id: json['id'] as int?,
      nameAr: json['name_ar'] as String?,
      nameEn: json['name_en'] as String?,
      descriptionAr: json['description_ar'] as String?,
      descriptionEn: json['description_en'] as String?,
      price: json['price'] as String?,
      discount: json['discount'] as String?,
      days: json['days'] as String?,
      image: json['image'] as String?,
      boquetItems: json['boquet_items'] != null
          ? (json['boquet_items'] as List)
              .map((item) => BoquetItem.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameEn != null) 'name_en': nameEn,
      if (descriptionAr != null) 'description_ar': descriptionAr,
      if (descriptionEn != null) 'description_en': descriptionEn,
      if (price != null) 'price': price,
      if (discount != null) 'discount': discount,
      if (image != null) 'image': image,
      if (boquetItems != null)
        'boquet_items': boquetItems!.map((item) => item.toJson()).toList(),
    };
  }
}

class BoquetItem {
  final String? nameAr;
  final String? nameEn;
  final int? quantity;

  BoquetItem({
    this.nameAr,
    this.nameEn,
    this.quantity,
  });

  factory BoquetItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return BoquetItem();
    }
    return BoquetItem(
      nameAr: json['name_ar'] as String?,
      nameEn: json['name_en'] as String?,
      quantity: json['quantity'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (nameAr != null) 'name_ar': nameAr,
      if (nameEn != null) 'name_en': nameEn,
      if (quantity != null) 'quantity': quantity,
    };
  }
}
