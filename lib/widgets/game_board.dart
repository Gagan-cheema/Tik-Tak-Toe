import 'package:flutter/material.dart';
import 'package:tic_tak_toe/constants/app_constants.dart';
import 'package:tic_tak_toe/widgets/tile.dart';

// Game board with staggered tile animations

class GameBoard extends StatefulWidget {
  final double boardSize;

  const GameBoard({super.key, required this.boardSize});

  @override
  GameBoardState createState() => GameBoardState();
}

class GameBoardState extends State<GameBoard> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<double>> _scaleAnimations;
  final List<GlobalKey<TileState>> _tileKeys = List.generate(9, (_) => GlobalKey<TileState>());

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(9, (index) => AnimationController(vsync: this, duration: const Duration(milliseconds: 500)));

    _fadeAnimations =
        _controllers.map((controller) {
          return Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));
        }).toList();

    _scaleAnimations =
        _controllers.map((controller) {
          return Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: controller, curve: Curves.elasticOut));
        }).toList();

    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void resetGlowAnimations() {
    for (var key in _tileKeys) {
      if (key.currentState != null) {
        key.currentState!.resetGlow();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tileSpacing = widget.boardSize * 0.02;
    final tileSize = (widget.boardSize - tileSpacing * 2) / 3;

    return Container(
      width: widget.boardSize,
      height: widget.boardSize,
      padding: EdgeInsets.all(tileSpacing),
      decoration: BoxDecoration(color: AppConstants.boardColor, borderRadius: BorderRadius.circular(15)),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: tileSpacing, mainAxisSpacing: tileSpacing),
        itemCount: 9,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _controllers[index],
            builder: (context, child) {
              return Opacity(opacity: _fadeAnimations[index].value, child: Transform.scale(scale: _scaleAnimations[index].value, child: Tile(key: _tileKeys[index], index: index, tileSize: tileSize)));
            },
          );
        },
      ),
    );
  }
}
