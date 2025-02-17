import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'quizzes_dashbord.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(202, 76, 243, 54),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Image instead of CustomPainter
            Image.asset(
              'assets/images/wmonster.png', // replace with your image path
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 40),
            // Text elements
            Text(
              'Good, You got all\ncaught up 🔥',
              textAlign: TextAlign.center,
              style: GoogleFonts.irishGrover(
                fontSize: 36,
                color: Colors.black87,
              ),
            ),
            Text(
              'Let’s see how your\ndashbord looks like',
              textAlign: TextAlign.center,
              style: GoogleFonts.irishGrover(
                fontSize: 36,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizzesDashbordScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 204, 204, 204),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Let’s go ',
                            style: GoogleFonts.irishGrover(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                          TextSpan(
                            text: '🏃‍♀️💨',
                            style: GoogleFonts.notoColorEmoji(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
