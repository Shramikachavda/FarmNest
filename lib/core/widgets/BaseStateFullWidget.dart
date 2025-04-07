import 'package:flutter/material.dart';

abstract class BaseStatefulWidget extends StatefulWidget {
  const BaseStatefulWidget({super.key});

  /// Must be overridden: route name
  String get routeName;

  /// Must be overridden: route builder
  Route<dynamic> buildRoute();

  Route<T> materialRoute<T>() {
    return MaterialPageRoute<T>(
      builder: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
        return this; // This works because this is already a Widget
      },
      settings: RouteSettings(name: routeName),
    );
  }
}
