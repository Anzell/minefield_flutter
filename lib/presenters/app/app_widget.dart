import 'package:flutter/material.dart';
import 'package:minefield/core/constants/app_routes.dart';
import 'package:minefield/presenters/home/home_screen.dart';
import 'package:minefield/presenters/minefield/minefield_screen.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case AppRoutes.home:
            return MaterialPageRoute(builder: (_) => HomeScreen());
          case (AppRoutes.minefield):
            return MaterialPageRoute(
                builder: (_) => MinefieldScreen(params: (settings.arguments as MinefieldScreenParams)));
          default:
            return MaterialPageRoute(builder: (_) => const _InvalidRouteScreen());
        }
      },
    );
  }
}

class _InvalidRouteScreen extends StatelessWidget {
  const _InvalidRouteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text("Rota inválida"),
      ),
    );
  }
}
