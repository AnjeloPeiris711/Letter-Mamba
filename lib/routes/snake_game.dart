import 'package:flutter/material.dart';
import 'package:vocabulary/routes/game_screen.dart';

class SnakeSplashScreen extends StatelessWidget {
  const SnakeSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFB5E6B5), Color(0xFFE8F5E8)],
              ),
            ),
          ),

          // Bottom Snake Image
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/snake.png',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              fit: BoxFit.cover,
            ),
          ),

          // Main Content
          Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // Coin Display
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF90EE90).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Image.asset('assets/images/coin.png', height: 20),
                            const SizedBox(width: 4),
                            const Text('0', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Heart Display
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.favorite,
                                color: Colors.red, size: 20),
                            const SizedBox(width: 4),
                            const Text('0', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40), // Moves Logo Higher

              // Snake Logo
              Center(
                child: Image.asset(
                  'assets/images/snakelogo.png',
                  height: MediaQuery.of(context).size.height *
                      0.25, // Slightly smaller
                  fit: BoxFit.contain,
                ),
              ),

              const Spacer(), // Pushes Button Down

              // Start Button (Lower on the screen)
              Padding(
                padding: const EdgeInsets.only(
                    top: 10), // Changed from bottom to top
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LetterMambaScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD2691E),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 48, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 10, // Adds shadow for more visibility
                  ),
                  child: const Text(
                    'Start',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

// Settings Button
              IconButton(
                onPressed: () {
                  // Add settings logic here
                },
                icon: const Icon(Icons.settings, size: 32, color: Colors.brown),
              ),

              const SizedBox(
                  height:
                      350), // Ensures spacing at bottom// Ensures spacing at bottom
            ],
          ),
        ],
      ),
    );
  }
}
