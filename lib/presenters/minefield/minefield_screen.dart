import 'package:flutter/material.dart';
import 'package:minefield/core/constants/game_dificulties.dart';
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
    controller.initializeMinefield(dificulty: _params.dificulty);
    _initReactionLost(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Jogo")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder<List<List<int?>>>(
          initialData: const [],
          stream: controller.getMinefieldStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) return const SizedBox();
            final minefield = snapshot.data!;
            return LayoutBuilder(
              builder: (context, constraints) => GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: constraints.maxHeight / constraints.maxWidth, crossAxisCount: minefield.length),
                  scrollDirection: Axis.horizontal,
                  itemCount: minefield.length * minefield.length,
                  itemBuilder: (context, index) {
                    final indexL = index % minefield.length;
                    final indexC = index ~/ minefield.length;
                    final cardInfo = minefield[indexL][indexC] != null && minefield[indexL][indexC] != 0
                        ? "${minefield[indexL][indexC]}"
                        : '';
                    final widget = minefield[indexL][indexC] == null
                        ? _AvailableField(
                            onTap: () async => await controller.revealField(x: indexL, y: indexC),
                          )
                        : _RevealedField(isBomb: minefield[indexL][indexC] == -1, label: cardInfo);
                    return AnimatedSwitcher(
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          final rotate = Tween(begin: pi, end: 0.0).animate(animation);
                          return AnimatedBuilder(
                              animation: rotate,
                              child: child,
                              builder: (BuildContext context, Widget? child) {
                                final angle = (ValueKey(widget is _AvailableField) != widget.key)
                                    ? min(rotate.value, pi / 2)
                                    : rotate.value;
                                return Transform(
                                  transform: Matrix4.rotationY(angle),
                                  child: child,
                                  alignment: Alignment.center,
                                );
                              });
                        },
                        duration: const Duration(milliseconds: 400),
                        child: widget);
                  } //
                  ),
            ); //
          },
        ),
      ),
    );
  }

  void _initReactionLost(BuildContext context) {
    controller.getLostStream().listen((lost) async {
      if (lost) {
        await showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Text("KABUM"),
          ),
        );
        //Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
      }
    });
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
  const _RevealedField({Key? key, required this.isBomb, required this.label}) : super(key: key);

  final String label;
  final bool isBomb;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => GridTile(
        child: Card(
          color: isBomb ? Colors.red : Colors.green,
          child: Align(
            alignment: Alignment.center,
            child: !isBomb
                ? Text(label)
                : Image.asset(
                    "assets/bomb.png",
                    width: constraints.maxWidth / 2,
                  ),
          ),
        ),
      ),
    );
  }
}

class MinefieldScreenParams {
  final GameDificulties dificulty;

  MinefieldScreenParams({required this.dificulty});
}
