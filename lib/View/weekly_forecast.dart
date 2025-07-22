import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyForecast extends StatefulWidget {
  final Map<String, dynamic> currentValue;
  final String city;
  final List<dynamic> pastWeek;
  final List<dynamic> next7Days;
  const WeeklyForecast({
    super.key,
    required this.city,
    required this.currentValue,
    required this.pastWeek,
    required this.next7Days,
  });

  @override
  State<WeeklyForecast> createState() => _WeeklyForecastState();
}

class _WeeklyForecastState extends State<WeeklyForecast> {
  String formatApiData(String dataString) {
    DateTime date = DateTime.parse(dataString);
    return DateFormat('d MMMM, EEEE').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      widget.city,
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
                      '${widget.currentValue['temp_c']}℃',
                      style: TextStyle(
                        fontSize: 45.0,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.currentValue['condition']['text']}',
                      style: TextStyle(
                        fontSize: 45.0,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    Image.network(
                      'https:${widget.currentValue['condition']?['icon'] ?? ''}',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              //Next 7 days forecast
              SizedBox(height: 20.0),
              Text(
                "Next 7 days forecast",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              SizedBox(height: 10),
              ...widget.next7Days.map((day) {
                final data = day['date'] ?? '';
                final condition = day['day']?['condition']?['text'] ?? '';
                final icon = day['day']?['condition']?['icon'] ?? '';
                final maxTemp = day['day']?['maxTemp_c'] ?? '';
                final minTemp = day['day']?['minTemp_c'] ?? '';

                return ListTile(
                  leading: Image.network("https:$icon", width: 40.0),
                  title: Text(
                    formatApiData(data),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  subtitle: Text(
                    "$condition $minTemp℃ - $maxTemp℃",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                );
              }),

              //Previous 7 days forecast
              SizedBox(height: 20.0),
              Text(
                "Previous 7 days forecast",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              SizedBox(height: 10),
              ...widget.pastWeek.map((day) {
                final forecastDay = day['forecast']?['forecastday'];
                if (forecastDay == null || forecastDay.isEmpty) {
                  return SizedBox.shrink();
                }
                final forecast = forecastDay[0];
                final data = forecast['date'] ?? '';
                final condition = forecast['day']?['condition']?['text'] ?? '';
                final icon = forecast['day']?['condition']?['icon'] ?? '';
                final maxTemp = forecast['day']?['maxTemp_c'] ?? '';
                final minTemp = forecast['day']?['minTemp_c'] ?? '';

                return ListTile(
                  leading: Image.network("https:$icon", width: 40.0),
                  title: Text(
                    formatApiData(data),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  subtitle: Text(
                    "$condition $minTemp℃ - $maxTemp℃",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
