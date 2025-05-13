// Game screen with board, UI, and winning animation
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tak_toe/constants/app_constants.dart';
import 'package:tic_tak_toe/providers/game_provider.dart';
import 'package:tic_tak_toe/widgets/game_board.dart';
import 'package:tic_tak_toe/widgets/winner_animation.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  static final GlobalKey<WinnerAnimationState> _winnerAnimationKey = GlobalKey<WinnerAnimationState>();
  static final GlobalKey<GameBoardState> _gameBoardKey = GlobalKey<GameBoardState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            final isTabletOrWeb = screenWidth > 600;
            final scaleFactor = screenWidth / 360;
            final padding = AppConstants.basePadding * scaleFactor.clamp(1.0, 2.0);
            final fontSize = AppConstants.baseFontSize * scaleFactor.clamp(1.0, 1.5);
            final buttonHeight = AppConstants.baseButtonHeight * scaleFactor.clamp(1.0, 1.5);
            final maxBoardSize = (screenWidth * 0.8).clamp(300.0, isTabletOrWeb ? 600.0 : 400.0);
            final boardSize = (maxBoardSize < (screenHeight - padding * 4 - buttonHeight) * 0.6 ? maxBoardSize : (screenHeight - padding * 4 - buttonHeight) * 0.6);

            return Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Consumer<GameProvider>(
                        builder: (context, provider, child) {
                          return Text(
                            provider.board.winner != null
                                ? provider.board.winner == 'Draw'
                                    ? 'It\'s a Draw!'
                                    : '${provider.board.winner} Wins!'
                                : 'Player ${provider.board.currentPlayer}\'s Turn',
                            style: TextStyle(color: Colors.white, fontSize: fontSize * 1.5, fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                      SizedBox(height: padding),
                      GameBoard(key: _gameBoardKey, boardSize: boardSize),
                      SizedBox(height: padding),
                      ElevatedButton(
                        onPressed: () {
                          if (_winnerAnimationKey.currentState != null) {
                            _winnerAnimationKey.currentState!.resetGlowAnimation();
                          }
                          if (_gameBoardKey.currentState != null) {
                            _gameBoardKey.currentState!.resetGlowAnimations();
                          }
                          context.read<GameProvider>().resetGame();
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppConstants.boardColor, padding: EdgeInsets.symmetric(horizontal: padding * 2, vertical: padding * 0.5), minimumSize: Size(150 * scaleFactor.clamp(1.0, 1.5), buttonHeight), elevation: 8),
                        child: Text('Reset Game', style: TextStyle(color: Colors.white, fontSize: fontSize)),
                      ),
                    ],
                  ),
                ),
                Consumer<GameProvider>(
                  builder: (context, provider, child) {
                    if (provider.showWinningAnimation) {
                      return IgnorePointer(child: Align(alignment: Alignment.center, child: WinnerAnimation(key: _winnerAnimationKey, winner: provider.board.winner!, maxSize: boardSize)));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
