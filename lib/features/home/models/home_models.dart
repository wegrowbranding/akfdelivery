class Category {
  final int id;
  final String categoryName;
  final String? bannerImage;
  final String? logoImage;

  Category({
    required this.id,
    required this.categoryName,
    this.bannerImage,
    this.logoImage,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        categoryName: json['category_name'] ?? '',
        bannerImage: json['banner_image'],
        logoImage: json['logo_image'],
      );
  
  Map<String, dynamic> toJson() => {
        'id': id,
        'category_name': categoryName,
        'banner_image': bannerImage,
        'logo_image': logoImage,
      };
}

class ProductMedia {
  final int id;
  final String fileName;
  final String fileUrl;
  final String fileType;
  final bool isPrimary;

  ProductMedia({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.fileType,
    required this.isPrimary,
  });

  factory ProductMedia.fromJson(Map<String, dynamic> json) => ProductMedia(
        id: json['id'],
        fileName: json['file_name'] ?? '',
        fileUrl: json['file_url'] ?? '',
        fileType: json['file_type'] ?? 'image',
        isPrimary: json['pivot'] != null && (json['pivot']['is_primary'] == 1),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'file_name': fileName,
        'file_url': fileUrl,
        'file_type': fileType,
        'pivot': {'is_primary': isPrimary ? 1 : 0},
      };
}

class Product {
  final int id;
  final String productCode;
  final String productName;
  final int categoryId;
  final String price;
  final double stockQuantity;
  final String? description;
  final Category? category;
  final List<ProductMedia> media;

  Product({
    required this.id,
    required this.productCode,
    required this.productName,
    required this.categoryId,
    required this.price,
    required this.stockQuantity,
    this.description,
    this.category,
    required this.media,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final mediaList = json['media'] as List? ?? [];
    return Product(
      id: json['id'],
      productCode: json['product_code'] ?? '',
      productName: json['product_name'] ?? '',
      categoryId: json['category_id'] ?? 0,
      price: json['price']?.toString() ?? '0.00',
      stockQuantity: (json['stock_quantity'] ?? 0).toDouble(),
      description: json['description'],
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : null,
      media: mediaList.map((m) => ProductMedia.fromJson(m)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_code': productCode,
        'product_name': productName,
        'category_id': categoryId,
        'price': price,
        'stock_quantity': stockQuantity,
        'description': description,
        'category': category?.toJson(),
        'media': media.map((m) => m.toJson()).toList(),
      };

  String? get primaryImageUrl {
    if (media.isEmpty) {
      return null;
    }
    final primary = media.firstWhere(
      (m) => m.isPrimary,
      orElse: () => media.first,
    );
    return primary.fileUrl;
  }
}
