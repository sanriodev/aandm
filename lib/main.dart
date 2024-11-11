import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: FlappyBirdGame(),
  ));
}

class FlappyBirdGame extends StatefulWidget {
  @override
  _FlappyBirdGameState createState() => _FlappyBirdGameState();
}

class _FlappyBirdGameState extends State<FlappyBirdGame> {
  static const double gravity = 1.1;
  static const double jumpStrength = -15;
  static const double birdWidth = 50;
  static const double birdHeight = 50;
  static const double pipeWidth = 60;
  static const double pipeGap = 250;

  double birdY = 0;
  double birdVelocity = 0;
  double pipeX = 0;
  double pipeHeight = 0;
  bool gameStarted = false;
  Timer? gameTimer;

  void startGame() {
    gameStarted = true;
    birdY = 0;
    birdVelocity = 0;
    pipeX = MediaQuery.of(context).size.width;
    pipeHeight =
        Random().nextDouble() * (MediaQuery.of(context).size.height - pipeGap);
    gameTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        birdVelocity += gravity;
        birdY += birdVelocity;
        pipeX -= 2.5;

        if (pipeX < -pipeWidth) {
          pipeX = MediaQuery.of(context).size.width;
          pipeHeight = Random().nextDouble() *
              (MediaQuery.of(context).size.height - pipeGap);
        }

        if (birdY > MediaQuery.of(context).size.height - birdHeight ||
            birdY < 0) {
          gameTimer?.cancel();
          gameStarted = false;
        }
      });
    });
  }

  void jump() {
    setState(() {
      birdVelocity = jumpStrength;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            AnimatedContainer(
              alignment: Alignment(
                  0, birdY / (MediaQuery.of(context).size.height / 2)),
              duration: Duration(milliseconds: 0),
              child: Container(
                width: birdWidth,
                height: birdHeight,
                child: Image.asset('lib/assets/matteo.jpeg'),
              ),
            ),
            AnimatedContainer(
              alignment: Alignment(
                  pipeX / (MediaQuery.of(context).size.width / 2) - 1, 1),
              duration: const Duration(milliseconds: 0),
              child: Column(
                children: [
                  Container(
                    width: pipeWidth,
                    height: pipeHeight,
                    color: Colors.green,
                  ),
                  SizedBox(height: pipeGap),
                  Container(
                    width: pipeWidth,
                    height: MediaQuery.of(context).size.height -
                        pipeHeight -
                        pipeGap,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
