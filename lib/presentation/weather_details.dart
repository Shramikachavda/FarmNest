import 'package:agri_flutter/customs_widgets/custom_app_bar.dart';
import 'package:agri_flutter/providers/api_provider/weather_provider.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                isDark
                    ? [
                      const Color.fromARGB(255, 134, 155, 135),
                      const Color.fromARGB(255, 117, 211, 123),
                    ]
                    : [const Color(0xFFA5D6A7), const Color(0xFFE8F5E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Consumer<WeatherViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.errorMessage != null) {
              return Center(child: Text(viewModel.errorMessage!));
            }

            if (viewModel.dailyForecast == null ||
                viewModel.dailyForecast!.isEmpty) {
              return const Center(child: Text('No forecast data available.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: viewModel.dailyForecast!.length,
              itemBuilder: (context, index) {
                final day = viewModel.dailyForecast![index];
                final dateTime = DateTime.parse(day['dt_txt']);
                final temp = day['main']['temp'];
                final icon = day['weather'][0]['icon'];
                final description = day['weather'][0]['description'];

                final formattedDate = DateFormat(
                  'EEEE, MMM d',
                ).format(dateTime);

                return Card(
                  color: themeColor(context: context).onSecondary , 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(14),
                    leading: Image.network(
                      "https://openweathermap.org/img/wn/$icon@2x.png",
                      width: 60,
                    ),
                    title: Text(
                      formattedDate,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "$description • $temp°C",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
