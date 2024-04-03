import 'dart:convert';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:weather_app_final/ui/get_started.dart';

import '../models/constants.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final TextEditingController _cityController = TextEditingController();

  Constants myConstants = Constants();

  static String apiKey = '2cae493e96274486983111333243003';

  String location = 'Gurgaon';
  String country = 'India';
  String weatherIcon = 'cloud.png';
  double temp = 0.0;
  int windSpeed = 0;
  int humidity = 0;
  int cloud = 0;
  String currentDate = '';
  String imgURL = '';
  String last = '';


  List hourlyForecast = [];
  List dailyForecast = [];

  String currentWeatherStatus = '';

  //API CALL

  String searchWeatherAPI = 'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&days=10&q=';

  void fetchWeatherData(String location) async{
    try{
      var searchResult = await http.get(Uri.parse(searchWeatherAPI + location));

      final weatherData = Map<String, dynamic>.from(json.decode(searchResult.body));

      var locationData = weatherData['location'];

      var currentWeather = weatherData['current'];

      setState(() {
        this.location = (locationData["name"]);

        //set date and format it as well
        var parsedDate = DateTime.parse(locationData['localtime'].substring(0,10));
        var newDate = DateFormat('MMMMEEEEd').format(parsedDate);
        currentDate = newDate;
        imgURL = "https:" + currentWeather['condition']['icon'];
        last = weatherData['location']['name'];
        country = locationData['country'];


        //update weather
        temp = currentWeather['temp_c'].toDouble();
        windSpeed = currentWeather['wind_kph'].toInt();
        humidity = currentWeather['humidity'].toInt();
        cloud = currentWeather['cloud'].toInt();

        //update current weather status
        currentWeatherStatus = currentWeather['condition']['text'];
        //update icon according to weather
        weatherIcon = currentWeather['condition']['text'].replaceAll(' ','').toLowerCase() + ".png";

        //forecast data

        dailyForecast = weatherData['forecast']['forecastday'];
        hourlyForecast = dailyForecast[0]['hour'];

        // print(temp);
        // print(locationData);
      });
    }
    catch(e){
      print(e);
    }
  }


  // static String getShortLocationName(String s){
  //   List<String> wordList = s.split(" ");

  //   if(wordList.isNotEmpty){
  //     if(wordList.length>1){
  //       return wordList[0] + " " + wordList[1];
  //     }
  //     else{
  //       return wordList[0];
  //     }
  //   }
  //   else{
  //     return " ";
  //   }
  // }
  @override
  void initState() {
    // print("Starting");
    fetchWeatherData(location);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Colors.white,

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/1234.jpg'),
            fit: BoxFit.fill,
            opacity: 0.6
          )
        ),
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
        // color: myConstants.primaryColor.withOpacity(0.1),
        // color: Colors.white,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: size.height * 0.7,
              decoration: BoxDecoration(
                gradient: myConstants.linearGradientBlue,

                boxShadow: [
                  BoxShadow(
                    color: myConstants.primaryColor.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0,3),
                  ),
                ],

                borderRadius: BorderRadius.circular(20),
              ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [

                    IconButton(
                        onPressed: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GetStarted()));
                        },
                        icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                        ),
                        iconSize: 30,
                    ),

                    // Image.asset('assets/menu.png', width: 40, height: 40),

                    GestureDetector(

                      onTap: (){
                        _cityController.clear();
                        showMaterialModalBottomSheet(context: context, builder: (context)=>SingleChildScrollView(
                          controller: ModalScrollController.of(context),
                          child: Container(
                            height: size.height * 0.2,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

                            child: Column(
                              children: [
                                SizedBox(
                                    width: size.width * 0.4,
                                    child: Divider(
                                      thickness: 3.5,
                                      color: myConstants.primaryColor,
                                    )
                                ),

                                const SizedBox(height: 10,),

                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        textInputAction: TextInputAction.none,
                                        onChanged: (location) {
                                          setState(() {
                                            last = this.location;
                                          });
                                          fetchWeatherData(location);
                                        },
                                        controller: _cityController,
                                        autofocus: true,
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.search, color: myConstants.primaryColor,),
                                            suffixIcon: GestureDetector(
                                              onTap: () => _cityController.clear(),
                                              child: Icon(Icons.close, color: myConstants.primaryColor,),
                                            ),
                                            hintText: 'Search city e.g New Delhi',
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: myConstants.primaryColor,
                                              ),
                                              borderRadius: BorderRadius.circular(15),
                                            )
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ));
                      },

                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Image.asset('assets/pin.png', width: 20,),

                          const SizedBox(width: 10,),

                          Text('$location, $country', 
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            // overflow: TextOverflow.clip,
                          )),

                          const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.white,
                          ),

                        ],
                      ),
                    ),

                    // const IconButton(onPressed: null,
                    //     icon: Icon(Icons.menu , color: Colors.white70),
                    //     iconSize: 28,
                    // ),

                    PopupMenuButton(
                      icon: const Icon(Icons.menu, color: Colors.white,),
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: 'item1',
                          child: Row(
                            children: [
                              const Icon(Icons.settings),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10), // Set border radius
                                  color: Colors.grey[200], // Set background color
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Text('Settings'),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'item2',
                          child: Row(
                            children: [
                              const Icon(Icons.info),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10), // Set border radius
                                  color: Colors.grey[200], // Set background color
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Text('About us'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                SizedBox(
                  height: 130,

                  child: Image.asset('assets/' + weatherIcon),
                  // child: Image.network(imgURL, width: 150, height: 150,),
                  // child: Image.asset('assets/sun.gif'),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          temp.toString(),
                          style: const TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            // foreground: Paint()..shader = myConstants.shader,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Text(
                        'o',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          // foreground: Paint()..shader = myConstants.shader,
                          color: Colors.white,
                        ),
                      ),
                    ],
                 ),

                 Column(
                  children: [
                    Text(currentWeatherStatus ,style: const TextStyle(fontSize: 18, color: Colors.white54, fontWeight: FontWeight.w500),),
                    const SizedBox(height: 10,),
                    Text(currentDate ,style: const TextStyle(fontSize: 18, color: Colors.white54, fontWeight: FontWeight.w500),),
                  ],
                 ),

                 Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Divider(
                    color: Colors.white38,
                  ),
                 ),

                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [

                    SizedBox(
                      width: 100,
                      child: Column(
                        children: [
                          Image.asset('assets/windspeed.png', width: 50,),
                          const SizedBox(height: 10,),
                          Text(
                            windSpeed.toString() + "km/h",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          const Text('WIND SPEED',
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w500
                            ),
                          )
                          // Text("100km/h"),
                        ],
                      ),
                    ),


                    SizedBox(
                      width: 100,
                      child: Column(
                        children: [
                          Image.asset('assets/humidity.png', width: 50,),
                          const SizedBox(height: 10,),
                          Text(
                            humidity.toString() + "%",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          const Text('HUMIDITY',
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ],
                      ),
                    ),


                    SizedBox(
                      width: 100,
                      child: Column(
                        children: [
                          Image.asset('assets/cloud.png', width: 50,),
                          const SizedBox(height: 10,),
                          Text(
                            cloud.toString() + "%",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),

                          const Text('CLOUDS',
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w500
                            ),
                          )
                          ],
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.only(top: 10),
              height: size.height * 0.21,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      Text('Hourly Forecast',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  SizedBox(
                    height: 130,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: hourlyForecast.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index){
                        String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
                        String currentHour = currentTime.substring(0,2);

                        String forecastTime = hourlyForecast[index]['time'].substring(11,16);
                        String forecastHour = hourlyForecast[index]['time'].substring(11,13);

                        String forecastWeatherName = hourlyForecast[index]['condition']['text'];
                        String forecastWeatherIcon = forecastWeatherName.replaceAll(' ', '').toLowerCase() + '.png';

                        String forecastTemperature = hourlyForecast[index]['temp_c'].round().toString();

                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          margin: const EdgeInsets.only(right: 20),

                          width: currentHour == forecastHour ? 120 : 90,
                          decoration: BoxDecoration(
                            color: currentHour == forecastHour ? Colors.white : myConstants.primaryColor,
                            border: currentHour == forecastHour ? Border.all(color: Colors.black) : null,
                            borderRadius: const BorderRadius.all(Radius.circular(40)),
                            boxShadow: [
                              BoxShadow(
                                color: myConstants.primaryColor.withOpacity(0.5),
                                blurRadius: 5,
                                offset: const Offset(0,1)
                              )
                            ]
                          ),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(forecastTime,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              Image.asset('assets/'+ forecastWeatherIcon , width: 45,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(forecastTemperature,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500
                                      ),
                                    ),

                                    const Text('\u00B0',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        fontFeatures: [
                                          FontFeature.enable('sups'),
                                        ],),
                                      ),  
                                  ],
                                )
                            ],
                          ),
                        );
                      }
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
