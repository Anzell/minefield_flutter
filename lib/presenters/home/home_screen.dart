import 'package:flutter/material.dart';
import 'package:minefield/core/constants/game_dificulties.dart';
import 'package:minefield/di/injector.dart';
import 'package:minefield/domain/entities/custom_dificulty.dart';
import 'package:minefield/presenters/home/controller/home_controller.dart';
import 'package:minefield/presenters/minefield/minefield_screen.dart';
import 'package:minefield/presenters/shared/custom_button.dart';
import 'package:minefield/presenters/shared/custom_spacer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final _widthLController = TextEditingController();
  final _widthCController = TextEditingController();
  final _bombsNumberController = TextEditingController();

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
              const Text("Selecione o tamanho do tabuleiro"),
              const Space(),
              CustomButton(onPressed: () => Navigator.pushNamed(context, "/minefield", arguments: MinefieldScreenParams(dificulty: GameDificulties.easy)), label: "3x3"),
              const Space(),
              CustomButton(onPressed: () => Navigator.pushNamed(context, "/minefield", arguments: MinefieldScreenParams(dificulty: GameDificulties.normal)), label: "5x5"),
              const Space(),
              CustomButton(onPressed: () => Navigator.pushNamed(context, "/minefield", arguments: MinefieldScreenParams(dificulty: GameDificulties.expert)), label: "10x10"),
              const Space(),
              const Space(),
              const Space(),
              const Text("Personalizado"),
              SizedBox(
                width: constraints.maxWidth / 1.1,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(child: TextFormField(controller: _widthCController, decoration: InputDecoration(label: Text("Colunas")))),
                    const SizedBox(width: 20),
                    Expanded(child: TextFormField(controller: _widthLController, decoration: InputDecoration(label: Text("Linhas")))),
                    const SizedBox(width: 20),
                    Expanded(child: TextFormField(controller: _bombsNumberController, decoration: InputDecoration(label: Text("Numero de bombas")))),
                  ],
                ),
              ),
              const Space(),
              CustomButton(
                onPressed: () {
                  final controller = getIt<HomeController>();
                  final convertedDificulty = controller.validateGameDificulty(
                    widthL: _widthLController.text,
                    widthC: _widthCController.text,
                    numberBombs: _bombsNumberController.text,
                  );
                  if (controller.failure.isNone()) {
                    return Navigator.pushNamed(
                      context,
                      "/minefield",
                      arguments: MinefieldScreenParams(dificulty: GameDificulties.custom, customDificulty: convertedDificulty!),
                    );
                  } else {
                    controller.failure.map(
                      (a) => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Text(a.toString()),
                        ),
                      ),
                    );
                  }
                },
                label: "Criar",
              )
            ],
          ),
        ),
      ),
    );
  }
}
