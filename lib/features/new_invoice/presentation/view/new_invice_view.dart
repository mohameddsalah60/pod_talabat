import 'package:flutter/material.dart';
import 'package:pod_talabat/core/widgets/scaffold_background.dart';

class NewInviceView extends StatelessWidget {
  const NewInviceView({super.key});
  static const routeName = '/create-invoice';
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [ScaffoldBackground()]));
  }
}
