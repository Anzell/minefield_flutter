import 'package:flutter/material.dart';
import 'package:minefield/core/constants/game_dificulties.dart';
import 'package:minefield/presenters/minefield/minefield_screen.dart';
import 'package:minefield/presenters/shared/custom_button.dart';
import 'package:minefield/presenters/shared/custom_spacer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Campo Minado")),
      body: LayoutBuilder(
        builder: (context, constraints) => SizedBox(
          width: constraints.maxWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Selecione a dificuldade"),
              const Space(),
              CustomButton(
                  onPressed: () => Navigator.pushNamed(context, "/minefield",
                      arguments: MinefieldScreenParams(dificulty: GameDificulties.easy)),
                  label: "Fácil"),
              CustomButton(
                  onPressed: () => Navigator.pushNamed(context, "/minefield",
                      arguments: MinefieldScreenParams(dificulty: GameDificulties.normal)),
                  label: "Normal"),
              CustomButton(
                  onPressed: () => Navigator.pushNamed(context, "/minefield",
                      arguments: MinefieldScreenParams(dificulty: GameDificulties.expert)),
                  label: "Díficil"),
            ],
          ),
        ),
      ),
    );
  }
}
