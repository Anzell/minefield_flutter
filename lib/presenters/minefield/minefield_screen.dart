import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:minefield/core/constants/game_dificulties.dart';
import 'package:minefield/domain/entities/custom_dificulty.dart';
import 'dart:math';
import 'package:minefield/presenters/minefield/controller/minefield_controller.dart';

class MinefieldScreen extends StatelessWidget {
  MinefieldScreen({Key? key, required MinefieldScreenParams params})
      : _params = params,
        super(key: key);

  final MinefieldScreenParams _params;
  final controller = MinefieldController();

  @override
  Widget build(BuildContext context) {
    controller.initializeMinefield(dificulty: _params.dificulty, customDificulty: _params.customDificulty);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jogo"),
        actions: [
          TextButton(
            onPressed: () => controller.initializeMinefield(dificulty: _params.dificulty, customDificulty: _params.customDificulty),
            child: const Text(
              "Reiniciar",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder<List<List<int?>>>(
          initialData: const [],
          stream: controller.getMinefieldStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) return const SizedBox();
            final minefield = snapshot.data!;
            return LayoutBuilder(
              builder: (context, constraints) => Stack(
                children: [
                  GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: constraints.maxHeight / constraints.maxWidth,
                        crossAxisCount: minefield[0].length,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: minefield.length * minefield[0].length,
                      itemBuilder: (context, index) {
                        final indexL = index % minefield.length;
                        final indexC = index ~/ minefield.length;
                        final bombsAround = minefield[indexL][indexC] ?? 0;
                        final widget = minefield[indexL][indexC] == null
                            ? _AvailableField(
                                onTap: () async => await controller.revealField(x: indexL, y: indexC),
                              )
                            : _RevealedField(isBomb: minefield[indexL][indexC] == -1, bombsAround: bombsAround);
                        return AnimatedSwitcher(
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            final rotate = Tween(begin: pi, end: 0.0).animate(animation);
                            return AnimatedBuilder(
                                animation: rotate,
                                child: child,
                                builder: (BuildContext context, Widget? child) {
                                  final angle = (ValueKey(widget is _AvailableField) != widget.key) ? min(rotate.value, pi / 2) : rotate.value;
                                  return Transform(
                                    transform: Matrix4.rotationY(angle),
                                    child: child,
                                    alignment: Alignment.center,
                                  );
                                });
                          },
                          duration: const Duration(milliseconds: 400),
                          child: widget,
                        );
                      } //
                      ),
                  StreamBuilder<bool>(
                      stream: controller.getLostStream(),
                      builder: (context, snapshot) {
                        if(!snapshot.hasData || !snapshot.data!){
                          return SizedBox();
                        }

                        return Container(
                          color: Colors.white38,
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          child: LottieBuilder.asset('assets/explosion.json'),
                        );
                      },)
                ],
              ),
            ); //
          },
        ),
      ),
    );
  }

}

class _AvailableField extends StatelessWidget {
  const _AvailableField({Key? key, required this.onTap}) : super(key: key);

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) => GridTile(
          child: Card(
            child: SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
            ),
          ),
        ),
      ),
    );
  }
}

class _RevealedField extends StatelessWidget {
  const _RevealedField({Key? key, required this.isBomb, required this.bombsAround}) : super(key: key);

  final int bombsAround;
  final bool isBomb;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => GridTile(
        child: Card(
          color: _getColor(),
          child: Align(
            alignment: Alignment.center,
            child: !isBomb
                ? Text(
                    bombsAround > 0 ? "$bombsAround" : '',
                    style: TextStyle(fontFamily: "Defused", fontSize: constraints.maxWidth / 4),
                  )
                : Image.asset(
                    "assets/bomb.png",
                    width: constraints.maxWidth / 2,
                  ),
          ),
        ),
      ),
    );
  }

  Color _getColor() {
    Color colorCard = isBomb ? Colors.red : Colors.green;
    if (!isBomb) {
      colorCard = Color.fromRGBO(217, 175, 255 - (bombsAround * 50), 1);
    }
    colorCard = bombsAround == 0 ? Colors.white54 : colorCard;
    return colorCard;
  }
}

class MinefieldScreenParams {
  final GameDificulties dificulty;
  final CustomDificulty? customDificulty;

  MinefieldScreenParams({required this.dificulty, this.customDificulty});
}
