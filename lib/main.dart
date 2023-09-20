import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/src/themes/color_schemas.dart';
import 'package:weather_app/src/views/search_page.dart';
import 'package:weather_app/src/views/weather_page.dart';
import 'package:weather_repository/weather_repository.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<WeatherRepository>(
      create: (context) => WeatherRepository(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        home: const WeatherPage(),
        routes: {
          '/search': (context) => SearchPage(),
        },
      ),
    );
  }
}
