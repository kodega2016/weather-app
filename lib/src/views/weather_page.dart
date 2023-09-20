import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/src/cubit/weather_cubit.dart';
import 'package:weather_repository/weather_repository.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: const WeatherView(),
      create: (_) => WeatherCubit(
        weatherRepository: context.read<WeatherRepository>(),
      ),
    );
  }
}

class WeatherView extends StatelessWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text("Weather App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final city =
                  await Navigator.of(context).pushNamed('/search') as String;

              if (context.mounted) {
                await context.read<WeatherCubit>().fetchWeather(city);
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) {
          return BlocBuilder<WeatherCubit, WeatherState>(
            builder: (context, state) {
              if (state.status == WeatherStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.status == WeatherStatus.failure) {
                return const Center(child: Text("Something went wrong"));
              } else if (state.status == WeatherStatus.success) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.weather.condition.toEmoji,
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontSize: 64,
                                ),
                      ),
                      Text(
                        state.weather.location,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        state.weather.temperature.toString(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '''Last Updated at ${TimeOfDay.fromDateTime(state.weather.lastUpdated).format(context)}''',
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: Text("Please select a location"));
              }
            },
          );
        },
      ),
    );
  }
}

extension on WeatherCondition {
  String get toEmoji {
    switch (this) {
      case WeatherCondition.clear:
        return '☀️';
      case WeatherCondition.rainy:
        return '🌧️';
      case WeatherCondition.cloudy:
        return '☁️';
      case WeatherCondition.snowy:
        return '🌨️';
      case WeatherCondition.unknown:
        return '❓';
    }
  }
}
