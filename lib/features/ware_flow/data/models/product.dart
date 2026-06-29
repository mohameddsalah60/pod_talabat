import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({
    required this.sku,
    required this.name,
    required this.barcode,
  });

  final String sku;
  final String name;
  final String barcode;

  factory Product.fromJsonEntry(String sku, Map<String, dynamic> json) {
    return Product(
      sku: sku,
      name: json['n'] as String? ?? '',
      barcode: json['b'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [sku, name, barcode];
}
