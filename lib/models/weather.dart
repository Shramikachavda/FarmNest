import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // Light blue background
      appBar: AppBar(title: Text("Weather Animation Test")),
      body: Center(
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🌞 Sunny Animation
                Lottie.asset(
                  "assets/image/sunny.json",
                  width: 150,
                  height: 150,
                ),

                // Temperature & City Name
                SizedBox(height: 10),
                Text(
                  "Mumbai",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  "28.5°C",
                  style: TextStyle(fontSize: 18, color: Colors.orangeAccent),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
