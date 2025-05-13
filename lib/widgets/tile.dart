import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tak_toe/constants/app_constants.dart';
import 'package:tic_tak_toe/providers/game_provider.dart';

class Tile extends StatefulWidget {
  final int index;
  final double tileSize;

  const Tile({super.key, required this.index, required this.tileSize});

  @override
  TileState createState() => TileState();
}

class TileState extends State<Tile> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late AnimationController _glowController;
  late Animation<Color?> _glowAnimation;
  Color? _currentGlowColor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));

    _glowController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _glowAnimation = ColorTween(begin: Colors.transparent, end: Colors.transparent).animate(CurvedAnimation(parent: _glowController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _onTap(GameProvider provider) {
    if (provider.board.tiles[widget.index] == null && provider.board.winner == null) {
      provider.makeMove(widget.index);
      _currentGlowColor = provider.board.tiles[widget.index] == 'X' ? AppConstants.xColor.withOpacity(0.5) : AppConstants.oColor.withOpacity(0.5);
      _glowAnimation = ColorTween(begin: Colors.transparent, end: _currentGlowColor).animate(CurvedAnimation(parent: _glowController, curve: Curves.easeInOut));
      _glowController.forward();
      _controller.forward();
    }
  }

  void resetGlow() {
    _glowController.reset();
    _currentGlowColor = Colors.transparent;
    _glowAnimation = ColorTween(begin: Colors.transparent, end: Colors.transparent).animate(CurvedAnimation(parent: _glowController, curve: Curves.easeInOut));
    _glowController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<GameProvider, String?>(
      selector: (context, provider) => provider.board.tiles[widget.index],
      builder: (context, marker, child) {
        return GestureDetector(
          onTap: () => _onTap(context.read<GameProvider>()),
          child: AnimatedBuilder(
            animation: Listenable.merge([_controller, _glowController]),
            builder: (context, child) {
              return Container(width: widget.tileSize, height: widget.tileSize, decoration: BoxDecoration(color: AppConstants.tileColor, borderRadius: BorderRadius.circular(widget.tileSize * 0.1), boxShadow: [BoxShadow(color: _glowAnimation.value ?? Colors.black.withOpacity(0.3), blurRadius: 10, spreadRadius: 2)]), child: Center(child: Transform.scale(scale: _scaleAnimation.value, child: Text(marker ?? '', style: TextStyle(fontSize: widget.tileSize * 0.4, fontWeight: FontWeight.bold, color: marker == 'X' ? AppConstants.xColor : AppConstants.oColor)))));
            },
          ),
        );
      },
    );
  }
}
