import 'package:flutter/material.dart';

class LandingViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();

  void onCreateInvoicePressed() {
    debugPrint('Create new invoice tapped');
  }

  void onSearchPressed() {
    debugPrint('Search tapped for: ${searchController.text}');
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
