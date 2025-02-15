import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/grid_widget.dart';

class LetterMambaScreen extends StatefulWidget {
  final int initialLevel;

  const LetterMambaScreen({super.key, this.initialLevel = 1});

  @override
  _LetterMambaScreenState createState() => _LetterMambaScreenState();
}

class _LetterMambaScreenState extends State<LetterMambaScreen> {
  static const int _rowCount = 20;
  static const int _colCount = 20;
  static const int _initialSnakeLength = 5;

  List<int> snake = [];
  int food = Random().nextInt(_rowCount * _colCount);
  String direction = 'right';
  Timer? gameLoop;
  bool isGameOver = false;
  bool isPaused = false;
  int score = 0;
  int level = 1;

  // Snake speed per level
  final List<Duration> levelSpeeds = [
    const Duration(milliseconds: 400), // Level 1
    const Duration(milliseconds: 300), // Level 2
    const Duration(milliseconds: 200), // Level 3
    const Duration(milliseconds: 150), // Level 4
    const Duration(milliseconds: 100), // Level 5
  ];

  @override
  void initState() {
    super.initState();
    level = widget.initialLevel;
    _startGame();
  }

  void _startGame() {
    snake = List.generate(_initialSnakeLength, (index) => index);
    direction = 'right';
    isGameOver = false;
    isPaused = false;
    score = 0;

    _restartGameLoop();
  }

  void _restartGameLoop() {
    gameLoop?.cancel();
    gameLoop = Timer.periodic(levelSpeeds[level - 1], (_) => _updateGame());
  }

  void _pauseResumeGame() {
    setState(() {
      if (isPaused) {
        isPaused = false;
        _restartGameLoop();
      } else {
        isPaused = true;
        gameLoop?.cancel();
      }
    });
  }

  void _updateGame() {
    if (isPaused || isGameOver) return;

    setState(() {
      int newHead;

      // Calculate new head position
      switch (direction) {
        case 'up':
          newHead = snake.last - _colCount;
          if (newHead < 0) newHead += _rowCount * _colCount;
          break;
        case 'down':
          newHead = snake.last + _colCount;
          if (newHead >= _rowCount * _colCount)
            newHead -= _rowCount * _colCount;
          break;
        case 'left':
          newHead = (snake.last % _colCount == 0)
              ? snake.last + _colCount - 1
              : snake.last - 1;
          break;
        case 'right':
        default:
          newHead = (snake.last % _colCount == _colCount - 1)
              ? snake.last - _colCount + 1
              : snake.last + 1;
          break;
      }

      // Check for collision with itself
      if (snake.contains(newHead)) {
        isGameOver = true;
        gameLoop?.cancel();
        return;
      }

      snake.add(newHead);

      // Check if the snake eats the food
      if (newHead == food) {
        score++;
        food = _generateFood();

        // Level up based on score
        if (score % 5 == 0 && level < 5) {
          level++;
          _restartGameLoop();
        }
      } else {
        snake.removeAt(0); // Remove the tail
      }
    });
  }

  int _generateFood() {
    int newFood;
    do {
      newFood = Random().nextInt(_rowCount * _colCount);
    } while (snake.contains(newFood));
    return newFood;
  }

  void _changeDirection(String newDirection) {
    if ((direction == 'up' && newDirection == 'down') ||
        (direction == 'down' && newDirection == 'up') ||
        (direction == 'left' && newDirection == 'right') ||
        (direction == 'right' && newDirection == 'left')) {
      return; // Prevent 180-degree turns
    }
    direction = newDirection;
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height to make the game responsive
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Calculate grid size dynamically based on screen size
    double gridWidth = screenWidth * 0.8;
    double gridHeight = screenHeight * 0.5;

    // Calculate grid cell size
    double cellSize = gridWidth / _colCount;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Score and Level Display with SVG background
          Expanded(
            flex: 2,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/score_bg.svg', // Path to your background SVG
                  fit: BoxFit.scaleDown,
                  width: double.infinity,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Score: $score',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Level: $level',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Game Grid with responsive layout
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.delta.dy < 0) _changeDirection('up');
                    if (details.delta.dy > 0) _changeDirection('down');
                  },
                  onHorizontalDragUpdate: (details) {
                    if (details.delta.dx < 0) _changeDirection('left');
                    if (details.delta.dx > 0) _changeDirection('right');
                  },
                  child: GridWidget(
                    rowCount: _rowCount,
                    colCount: _colCount,
                    snake: snake,
                    food: food,
                    cellSize: cellSize, // Pass the dynamic cell size
                  ),
                ),
                // Show overlay only if the game is over, not when paused
                if (isGameOver)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black
                          .withOpacity(0.5), // Overlay with reduced opacity
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/game_over.svg',
                          height: 150,
                          width: 150,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Show Pause/Play button only when the game is not over
          if (!isGameOver)
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _pauseResumeGame,
                    child: Image.asset(
                      isPaused
                          ? 'assets/images/play.png'
                          : 'assets/images/pause.png',
                      height: 70,
                      width: 70,
                    ),
                  ),
                ],
              ),
            ),
          // Show Restart button only when the game is over
          if (isGameOver)
            Expanded(
              flex: 1,
              child: Center(
                child: GestureDetector(
                  onTap: _startGame, // Action to restart the game
                  child: Image.asset(
                    'assets/images/restart.png', // Path to your restart PNG image
                    fit: BoxFit
                        .contain, // Ensures the image fits within the button space
                    height: 100, // Set the height of the image
                    width: 100, // Set the width of the image
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    gameLoop?.cancel();
    super.dispose();
  }
}
