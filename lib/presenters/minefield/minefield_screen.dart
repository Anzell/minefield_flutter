import 'package:flutter/material.dart';
import 'package:minefield/core/constants/game_dificulties.dart';

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
            return GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: minefield.length),
              itemCount: minefield.length,
              itemBuilder: (context, indexX) => SizedBox(
                width: MediaQuery.of(context).size.width,
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: minefield[indexX].length),
                    scrollDirection: Axis.horizontal,
                    itemCount: minefield[indexX].length,
                    itemBuilder: (context, indexY) {
                      Color cardColor = Colors.white30;
                      if (minefield[indexX][indexY] != null) {
                        if (minefield[indexX][indexY] != -1) {
                          cardColor = Colors.green;
                        } else {
                          cardColor = Colors.red;
                        }
                      }
                      return GestureDetector(
                        onTap: () async => await controller.revealField(x: indexX, y: indexY),
                        child: GridTile(
                          child: Card(
                            color: cardColor,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("${minefield[indexX][indexY] ?? ''}"),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            );
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
        Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
      }
    });
  }
}

class MinefieldScreenParams {
  final GameDificulties dificulty;

  MinefieldScreenParams({required this.dificulty});
}
