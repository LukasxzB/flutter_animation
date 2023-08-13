import 'package:flutter/material.dart';
import 'package:flutter_animation/src/widgets/cat.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomePage> with TickerProviderStateMixin {
  late Animation<double> catAnimation;
  late AnimationController catController;

  late Animation<double> boxAnimation;
  late AnimationController boxController;

  @override
  void initState() {
    super.initState();

    catController = AnimationController(
        duration: const Duration(milliseconds: 350), vsync: this);

    // animação começa em 0 e vai até 100 (altura da tela)
    catAnimation = Tween(
      begin: -35.0,
      end: -80.0,
    ).animate(
      CurvedAnimation(
        parent: catController,
        curve: Curves.easeInOutSine,
      ), // aceleção da animação, easeIn = aceleração
    );

    boxController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 185),
    );

    boxAnimation = Tween(
      begin: pi * 0.6,
      end: pi * 0.65,
    ).animate(
      CurvedAnimation(
        parent: boxController,
        curve: Curves.easeInOutSine,
      ),
    );

    boxController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        boxController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        boxController.forward();
      }
    });

    boxController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation!'),
      ),
      body: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              buildCatAnimation(),
              buildBox(),
              buildLeftFlap(),
              buildRightFlap(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      child: const Cat(),
      builder: (context, child) {
        return Positioned(
          top: catAnimation.value,
          right: 0,
          left: 0,
          child: child!,
        );
      },
    );
  }

  void onTap() {
    if (catController.status == AnimationStatus.completed ||
        catController.status == AnimationStatus.forward) {
      catController.reverse();
      boxController.forward();
    } else if (catController.status == AnimationStatus.dismissed ||
        catController.status == AnimationStatus.reverse) {
      catController.forward();
      boxController.stop();
    }
  }

  Widget buildBox() {
    return Container(
      height: 200.0,
      width: 200.0,
      color: const Color.fromARGB(255, 163, 125, 111),
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
      left: 3,
      child: AnimatedBuilder(
        animation: boxAnimation,
        builder: (context, child) {
          return Transform.rotate(
            alignment: Alignment.topLeft,
            angle: boxAnimation.value,
            child: child,
          );
        },
        child: Container(
          height: 15,
          width: 120,
          color: const Color.fromARGB(255, 163, 125, 111),
        ),
      ),
    );
  }

  Widget buildRightFlap() {
    return Positioned(
      right: 3,
      child: AnimatedBuilder(
        animation: boxAnimation,
        builder: (context, child) {
          return Transform.rotate(
            alignment: Alignment.topRight,
            angle: -boxAnimation.value,
            child: child,
          );
        },
        child: Container(
          height: 15,
          width: 120,
          color: const Color.fromARGB(255, 163, 125, 111),
        ),
      ),
    );
  }
}
