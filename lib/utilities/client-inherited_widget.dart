

import 'package:flutter/material.dart';

class ClientInheritedWidget extends InheritedWidget {

  final clients = [];

  ClientInheritedWidget(Widget child) : super(child: child);

  static ClientInheritedWidget of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(
        ClientInheritedWidget) as ClientInheritedWidget);
  }

  @override
  bool updateShouldNotify(ClientInheritedWidget oldWidget) {
    return oldWidget.clients != clients;
  }
}