// main.dart
import 'package:flutter/material.dart';
import 'screens/base_screen.dart';
import 'screens/game_base_screen.dart'; // Import the GameBaseScreen
import 'models/base.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Investoria Base',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(), // Start with HomeScreen
    );
  }
}

class HomeScreen extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/castle.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          // Dark Overlay
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.5),
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 30),
                    // Logo Section
                    Image.asset(
                      'assets/crown.png',
                      height: 200,
                      width: 200,
                    ),
                    Transform.translate(
                      offset: const Offset(0, -20), // Move text up by 20 pixels
                      child: const Text(
                        "Investoria",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'CinzelDecorative',
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 254, 212, 1),
                          shadows: [
                            Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 3.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Your journey to financial success awaits",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color.fromARGB(255, 220, 173, 4),
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 2.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Username Field
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        hintStyle:
                            TextStyle(color: Colors.black.withOpacity(0.6)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Password Field
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle:
                            TextStyle(color: Colors.black.withOpacity(0.6)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.lock_outline),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Login Button
                    Center(
                      child: SizedBox(
                        width: 200, // Fixed width for login button
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GameBaseScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
