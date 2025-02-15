import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'welcome.dart';

class AgeSelectionScreen extends StatefulWidget {
  const AgeSelectionScreen({super.key});

  @override
  AgeSelectionScreenState createState() => AgeSelectionScreenState();
}

class AgeSelectionScreenState extends State<AgeSelectionScreen> {
  int? selectedAge; // To track selected age

  // Function to handle age selection
  void selectAge(int age) {
    setState(() {
      selectedAge = age; // Set the selected age
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.centerLeft,
            colors: [
              const Color.fromARGB(255, 255, 255, 255),
              const Color.fromARGB(255, 237, 255, 143),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Image instead of CustomPainter
              Image.asset(
                'assets/images/amonster.png', // replace with your image path
                height: 200,
                width: 200,
              ),
              const SizedBox(height: 40),
              // Title
              Text(
                'Select Age Category',
                textAlign: TextAlign.center,
                style: GoogleFonts.irishGrover(
                  fontSize: 36,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                child: Column(
                  children: [
                    // Age buttons 4-7
                    ...List.generate(4, (index) {
                      final age = 4 + index; // Generating ages 4, 5, 6, 7
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ElevatedButton(
                          onPressed: () => selectAge(age),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedAge == age
                                ? const Color.fromARGB(
                                    255, 237, 163, 248) // Purple when selected
                                : const Color.fromARGB(
                                    255, 255, 255, 255), // Default white
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            'age $age',
                            style: GoogleFonts.irishGrover(
                              fontSize: 20,
                              color: selectedAge == age
                                  ? const Color.fromARGB(255, 10, 10, 10)
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              // Navigate button
              if (selectedAge !=
                  null) // Only show navigate button if an age is selected
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WelcomeScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Proceed',
                      style: GoogleFonts.irishGrover(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
