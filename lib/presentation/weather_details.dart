import 'package:agri_flutter/core/image.dart';
import 'package:agri_flutter/customs_widgets/custom_app_bar.dart';
import 'package:agri_flutter/customs_widgets/custom_icon.dart';
import 'package:agri_flutter/providers/api_provider/weather_provider.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:agri_flutter/utils/navigation/navigation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = themeColor(context: context);

    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorScheme.primaryContainer, colorScheme.surface],
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
              return Center(
                child: Text(
                  viewModel.errorMessage!,
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              );
            }

            if (viewModel.dailyForecast == null ||
                viewModel.dailyForecast!.isEmpty) {
              return Center(
                child: Text(
                  'No forecast data available.',
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              );
            }

            return Center(
              // Center the entire content vertically
              child: ListView.builder(
                shrinkWrap: true, // Prevent ListView from taking full height
                physics:
                    const NeverScrollableScrollPhysics(), // Disable scrolling for centered layout
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: BorderSide(
                        color: themeColor().outlineVariant,
                        width: 2,
                      ),
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
                          color: colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        "$description • $temp°C",
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
