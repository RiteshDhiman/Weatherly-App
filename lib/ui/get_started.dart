import 'package:flutter/material.dart';
import 'package:weather_app_final/ui/home_page.dart';

// import '../models/constants.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {

    // Constants myConstants = Constants();

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(

        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/1234.jpg'),
            fit: BoxFit.fill,
            opacity: 0.7
          )
        ),
          width: size.width,
          height: size.height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/sun.gif'),
                // Lottie.asset('animations/sunny.json'),
        
                const SizedBox(
                  height: 30,
                ),
                
                const Text('Weatherly',
                  style: TextStyle(
                    fontSize: 65,
                    color: Color.fromARGB(255, 6, 68, 119),
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                  ),
                ),
        
                const SizedBox(
                  height: 40,
                ),
                
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Home()));
                  },
                  child: Container(
                    height: 70,
                    width: size.width * 0.7,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 18, 94, 155),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: const Center(
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 20,
                          fontFamily: 'BebasNeue',
                          ),
                        // textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
  }
}
