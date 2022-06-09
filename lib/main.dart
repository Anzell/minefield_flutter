import 'package:flutter/material.dart';
import 'package:minefield/di/injector.dart';
import 'package:minefield/presenters/app/app_widget.dart';

void main() {
  initDependencies();
  runApp(const AppWidget());
}
