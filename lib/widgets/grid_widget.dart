import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GridWidget extends StatelessWidget {
  final int rowCount;
  final int colCount;
  final List<int> snake;
  final int food;

  const GridWidget({
    super.key,
    required this.rowCount,
    required this.colCount,
    required this.snake,
    required this.food,
    required double cellSize,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: colCount,
      ),
      itemCount: rowCount * colCount,
      itemBuilder: (context, index) {
        bool isSnake = snake.contains(index);
        bool isSnakeHead = isSnake &&
            index == snake.last; // Head is the last element in the snake list
        bool isFood = index == food;

        return Container(
          margin: const EdgeInsets.all(0.5),
          child: isSnakeHead
              ? SvgPicture.asset(
                  'assets/images/snake_head.svg', // Path to your snake head SVG
                  fit: BoxFit.fitHeight,
                )
              : isSnake
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )
                  : isFood
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        )
                      : null,
        );
      },
    );
  }
}
