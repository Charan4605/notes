import 'package:flutter/material.dart';

import 'home_screen.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9379f2),
      body: SafeArea(
        child: Stack(
          children: [
            // Main content column
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Empty space at top
                const SizedBox(height: 20),

                // Centered image
                Center(
                  child: Image.asset(
                    'assets/222.png', // Replace with your image path
                    height: 400,
                    width: 400,
                    fit: BoxFit.contain,

                  ),
                ),

                // App description text
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'A beautiful notes app to organize your thoughts and ideas with ease.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Spacer to push button to bottom
                const SizedBox(height: 20),

                // Made by text at very bottom
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'made by Charan',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),

            // Get Started button positioned at bottom
            Positioned(
              bottom: 60, // Adjust this value as needed
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 500),
                        pageBuilder: (_, __, ___) => HomeScreen(),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}