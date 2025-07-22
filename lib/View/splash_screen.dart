import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weather_app/View/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;
  @override
  void initState() {
    _timer = Timer(Duration(seconds: 6), () {
      //check if the widget is still mounted before navigating
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WeatherAppHomeScreen()),
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Column(
            children: [
              Center(
                child: Text(
                  textAlign: TextAlign.center,
                  "Discover The\n Weather In Your City",
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    height: 1.2,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              Spacer(),
              Image.asset(
                "assets/images/sunny.png",
                height: 350,
                fit: BoxFit.cover,
              ),
              Spacer(),
              Center(
                child: Text(
                  textAlign: TextAlign.center,
                  "Get to Know your Weather maps and\nradar precipitations forecast ",
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () {
                    //cancel the timer when the button is pressed to prevent the timer navigation
                    _timer.cancel();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WeatherAppHomeScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50.0,
                      vertical: 15.0,
                    ),
                    child: Text(
                      "Get Start",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
