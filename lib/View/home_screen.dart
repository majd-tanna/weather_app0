import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/Provider/theme_provider.dart';
import 'package:weather_app/Service/api_service.dart';
import 'weekly_forecast.dart';

class WeatherAppHomeScreen extends ConsumerStatefulWidget {
  const WeatherAppHomeScreen({super.key});

  @override
  ConsumerState<WeatherAppHomeScreen> createState() =>
      _WeatherAppHomeScreenState();
}

class _WeatherAppHomeScreenState extends ConsumerState<WeatherAppHomeScreen> {
  final _weatherService = WeatherApiService();
  String city = "nablus";
  String country = "Palestine";
  Map<String, dynamic> currentValue = {};
  List<dynamic> hourly = [];
  List<dynamic> pastWeek = [];
  List<dynamic> next7Days = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      isLoading = true;
    });
    try {
      final forecast = await _weatherService.getHourlyForecast(city);
      final past = await _weatherService.getPastSevenDaysWeather(city);
      setState(() {
        currentValue = forecast['current'] ?? {};
        hourly = forecast['forecast']?['forecastday']?[0]?['hour'] ?? [];
        // fore next 7 days forecast
        next7Days = forecast['forecast']?['forecastday'] ?? [];
        pastWeek = past;
        city = forecast['location']?['name'] ?? '';
        country = forecast['location']?['country'] ?? '';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        currentValue = {};
        hourly = [];
        pastWeek = [];
        next7Days = [];
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "City not found or invalid location . Please enter a valid city name. ",
          ),
        ),
      );
    }
  }

  String formatTime(String timeString) {
    DateTime time = DateTime.parse(timeString);
    return DateFormat.j().format(time);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);
    final notifier = ref.read(themeNotifierProvider.notifier);
    final isDark = themeMode == ThemeMode.dark;
    String iconPath = currentValue['condition']?['icon'] ?? '';
    String imageUrl = iconPath.isNotEmpty ? 'http:$iconPath' : '';
    Widget imageWidget =
        imageUrl.isNotEmpty
            ? Image.network(
              imageUrl,
              height: 170,
              width: 170,
              fit: BoxFit.cover,
            )
            : SizedBox();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          SizedBox(width: 25),
          SizedBox(
            width: 320,
            height: 50,
            child: TextField(
              style: TextStyle(color: isDark ? Colors.black : Colors.white),

              onSubmitted: (value) {
                if (value.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please Enter a city name ")),
                  );
                  return;
                }
                city = value.trim();
                _fetchWeather();
              },
              decoration: InputDecoration(
                labelText: "Search City",
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.surface,
                ),
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: notifier.toggleTheme,
            child: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? Colors.black : Colors.white,
              size: 30,
            ),
          ),
          SizedBox(width: 25),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else ...[
            if (currentValue.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$city${country.isNotEmpty ? ',$country' : ''}',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 35.0,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '${currentValue['temp_c']}℃',
                    style: TextStyle(
                      fontSize: 45.0,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${currentValue['condition']['text']}',
                    style: TextStyle(
                      fontSize: 45.0,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  imageWidget,
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: 100,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(1, 1),
                            color: Theme.of(context).colorScheme.primary,
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                "https://cdn-icons-png.flaticon.com/512/4148/4148460.png",
                                width: 30,
                                height: 30,
                              ),
                              Text(
                                "${currentValue['humidity']}%",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Humidity",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                "https://cdn-icons-png.flaticon.com/512/5918/5918654.png",
                                width: 30,
                                height: 30,
                              ),
                              Text(
                                "${currentValue['wind_kph']} km/h",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Wind",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                          //for max temperature
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                "https://cdn-icons-png.flaticon.com/512/6281/6281340.png",
                                width: 30,
                                height: 30,
                              ),
                              Text(
                                "${hourly.isNotEmpty ? hourly.map((h) => h['temp_c']).reduce((a, b) => a > b ? a : b) : "N/A"}",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Max Temp",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(40.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Today Forecast",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => WeeklyForecast(
                                            city: city,
                                            currentValue: currentValue,
                                            pastWeek: pastWeek,
                                            next7Days: next7Days,
                                          ),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Weekly Forecast",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(color: Theme.of(context).colorScheme.secondary),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 165.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: hourly.length,
                            itemBuilder: (context, index) {
                              final hour = hourly[index];
                              final now = DateTime.now();
                              final hourTime = DateTime.parse(hour['time']);
                              final isCurrentHour =
                                  now.hour == hourTime.hour &&
                                  now.day == hourTime.day;

                              return Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Container(
                                  height: 120,
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color:
                                        isCurrentHour
                                            ? Colors.orangeAccent
                                            : Colors.black38,
                                    borderRadius: BorderRadius.circular(40.0),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        isCurrentHour
                                            ? "Now"
                                            : formatTime(hour['time']),
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 5.0), // Reduced spacing
                                      Image.network(
                                        "https:${hour['condition']?['icon']}",
                                        height: 30, // Reduced image size
                                        width: 30, // Reduced image size
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(height: 5), // Reduced spacing
                                      Text(
                                        "${hour['temp_c']}℃",
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ],
      ),
    );
  }
}
