import 'package:flutter/material.dart';
import 'package:pod_talabat/features/new_invoice/presentation/view/new_invice_view.dart';

import '../../landing/presentation/view/landing_view.dart';
import 'app_routes.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.landing:
        return MaterialPageRoute(builder: (context) => const LandingView());
      case AppRoutes.createInvoice:
        return MaterialPageRoute(builder: (context) => const NewInviceView());
      default:
        return MaterialPageRoute(
          builder: (context) =>
              const Scaffold(body: Center(child: Text('404 Not Found'))),
        );
    }
  }
}
