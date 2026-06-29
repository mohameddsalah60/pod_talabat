import 'package:flutter/material.dart';

import '../../ware_flow/presentation/view/ware_flow_view.dart';
import 'app_routes.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.createInvoice:
        return MaterialPageRoute(
          builder: (context) => const WareFlowView(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) =>
              const Scaffold(body: Center(child: Text('404 Not Found'))),
        );
    }
  }
}
