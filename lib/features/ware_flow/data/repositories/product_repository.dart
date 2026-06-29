import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/product.dart';

class ProductRepository {
  ProductRepository({this.assetPath = 'assets/data/products.json'});

  final String assetPath;

  Map<String, Product>? _cache;

  bool get isLoaded => _cache != null;

  Future<void> loadProducts() async {
    if (_cache != null) return;

    final jsonString = await rootBundle.loadString(assetPath);
    final Map<String, dynamic> raw =
        json.decode(jsonString) as Map<String, dynamic>;

    _cache = raw.map(
      (sku, value) => MapEntry(
        sku,
        Product.fromJsonEntry(sku, value as Map<String, dynamic>),
      ),
    );
  }

  Product? findBySku(String sku) {
    final normalized = sku.trim();
    if (normalized.isEmpty || _cache == null) return null;
    return _cache![normalized];
  }
}
