import 'package:agri_flutter/customs_widgets/custom_app_bar.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/presentation/home_page_view/weather_forecast/weather_bloc.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:agri_flutter/utils/comman.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../customs_widgets/custom_form_field.dart';
import '../../../models/responses/weather_response.dart';

class ForecastScreen extends StatefulWidget {
  ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  final WeatherBloc _weatherBloc = WeatherBloc();

  final TextEditingController _textEditSearch = TextEditingController();
  final FocusNode _focusNodeSearch = FocusNode();

  Widget weatherImage(String description) {
    description = description.toLowerCase();

    if (description == 'clear sky') {
      return Icon(Icons.wb_sunny, size: 100.sp, color: Colors.orange);
    } else if (description == 'few clouds') {
      return Icon(Icons.cloud_queue, size: 50.sp, color: Colors.grey);
    } else if (description.contains('cloud')) {
      return Icon(Icons.cloud, size: 50.sp, color: Colors.grey);
    } else if (description.contains('rain')) {
      return Icon(Icons.grain, size: 50.sp, color: Colors.blue);
    } else if (description.contains('thunder')) {
      return Icon(Icons.flash_on, size: 50.sp, color: Colors.yellow.shade700);
    } else if (description.contains('snow')) {
      return Icon(Icons.ac_unit, size: 50.sp, color: Colors.lightBlueAccent);
    } else if (description.contains('mist') || description.contains('fog')) {
      return Icon(Icons.blur_on, size: 50.sp, color: Colors.blueGrey);
    } else {
      return Icon(Icons.wb_cloudy, size: 50.sp, color: Colors.blueGrey);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    await _weatherBloc.fetchWeatherData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor(context: context).surface,
      appBar: CustomAppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<Weather>(
                stream: _weatherBloc.dailyWeather,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: showLoading(context));
                  }
                  if (!snapshot.hasData || snapshot.data == null) {
                    return Center(
                      child: bodyText("No Weather data are available"),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: bodyText(
                        "Something went wrong.please try again later",
                      ),
                    );
                  }

                  //weather data
                  final today = DateTime.now();
                  Weather? weather = snapshot.data;
                  final tempData = weather?.list?.firstOrNull;
                  final date = tempData?.dtTxt ?? today;
                  final city = weather?.city?.name ?? "Unknown";
                  final description =
                      tempData?.weather?.first.description ?? "Unknown";

                  //two separate list
                  var (todayPrediction, nextPredictions) =
                      weather?.list?.separateList((element) {
                        return element.dtTxt?.format() == today.format();
                      }) ??
                      (<ListElement>[], <ListElement>[]);

                  return Center(
                    child: Column(
                      children:
                          [
                            //today's date
                            bodyMediumBoldText("Today , ${date.format()}"),

                            //search bar
                          /*  Padding(
                              padding: EdgeInsets.only(left: 24.h, right: 24.h),
                              child: CustomFormField(
                                focusNode: _focusNodeSearch,
                                hintText: 'Search City',
                                keyboardType: TextInputType.name,
                                label: 'Search',
                                textEditingController: _textEditSearch,
                                textInputAction: TextInputAction.search,
                                icon: IconButton(
                                  onPressed: () {
                                    _weatherBloc.fetchWeatherByCity(
                                      _textEditSearch.text.trim(),
                                    );
                                  },
                                  icon: Icon(Icons.search),
                                ),
                              ),
                            ),*/

                            //city
                            smallText(city),

                            //weather icon
                            weatherImage(description),

                            //temp , humidity and  air , pressure
                            todayWeatherDataWidget(tempData),

                            //today weather based on time
                            todayPredictionWidget(todayPrediction ?? []),

                            //nextDay weather
                            nextFourDayWeatherWidget(nextPredictions ?? []),
                          ].separator(SizedBox(height: 12.h)).toList(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget todayWeatherDataWidget(ListElement? tempData) {
    final temp = tempData?.main?.temp ?? 40;
    final humidity = tempData?.main?.humidity ?? 0;
    final pressure = tempData?.main?.pressure ?? 0;
    final air = tempData?.wind?.speed ?? 0;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Card(
        elevation: 4,
        child: Container(
          padding: EdgeInsets.all(12.h),
          decoration: BoxDecoration(
            color: themeColor(context: context).primaryContainer,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children:
                [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.thermostat, size: 24, color: Colors.redAccent),
                      SizedBox(width: 10.w),
                      bodySemiLargeBoldText("$temp °C"),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.water_drop, size: 24, color: Colors.blue),
                      smallText("$humidity%"),
                      SizedBox(width: 30.w),
                      Icon(Icons.air, size: 24, color: Colors.grey),

                      smallText("$air m/s"),
                      SizedBox(width: 30.w),

                      Icon(Icons.speed, size: 24, color: Colors.grey),
                      smallText("$pressure hPa "),
                    ],
                  ),
                ].separator(SizedBox(height: 8.h)).toList(),
          ),
        ),
      ),
    );
  }

  Widget todayPredictionWidget(List<ListElement>? todayPrediction) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        height: 190.h,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              [
                Padding(
                  padding: EdgeInsets.only(left: 16.w , bottom: 12),
                  child: bodyText("Hourly Forecast"),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: todayPrediction?.length,
                    itemBuilder: (context, index) {
                      final currentItem = todayPrediction?[index];
                      final temp = currentItem?.main?.temp ?? 0;
                      final time = currentItem?.dtTxt?.format("HH") ?? "";
                      final icon = currentItem?.weather?.first.icon ?? "";
                      final description =
                          currentItem?.weather?.first.description ??
                          "Unknown";
                      return todayPredictionItem(
                        temp,
                        time,
                        icon,
                        description,
                      );
                    },
                  ),
                ),
              ].separator(SizedBox(height: 5.h)).toList(),
        ),
      ),
    );
  }

  Widget todayPredictionItem(
    double? temp,
    String? time,
    String? icon,
    String description,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: themeColor(context: context).inversePrimary, // Border color
            width: 2.0, // Border width
          ),
          color: themeColor(context: context).surfaceContainer,
          borderRadius: BorderRadius.circular(12.w),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              [
                //time
                bodyText("${time.toString()} h"),

                //icon
                Image.network(
                  "https://openweathermap.org/img/wn/$icon@2x.png",
                  width: 40.w,
                  height: 40.h,
                  errorBuilder:
                      (context, error, stackTrace) => Icon(
                        Icons.cloud_off,
                        size: 50.sp,
                        color: themeColor(context: context).onSurfaceVariant,
                      ),
                ),
                bodyText("${temp.toString()} °C "),
                smallText(description),
              ].separator(SizedBox(height: 5)).toList(),
        ),
      ),
    );
  }

  Widget nextFourDayWeatherWidget(List<ListElement>? nextPredictions) {
    final distinctList =
        nextPredictions
            ?.distinctBy((element) => element.dtTxt?.format("dd"))
            .toList();
    return Padding(
      padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 12.h),
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            color: themeColor(context: context).surfaceContainer,
            borderRadius: BorderRadius.circular(20.r),
          ),
          height: 160.h,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: distinctList?.length ?? 0,
            itemBuilder: (context, index) {
              final currentItem = distinctList?[index];
              final time = currentItem?.dtTxt?.format("EEE") ?? DateTime.now();
              final icon = currentItem?.weather?.first.icon;
              final description =
                  currentItem?.weather?.first.description ?? "Unknown";
              final maxTemp = currentItem?.main?.tempMax ?? 0;
              final minTemp = currentItem?.main?.tempMin ?? 0;

              return upComingDaysWeather(
                maxTemp,
                minTemp,
                description,
                icon,
                time,
              );
            },
            separatorBuilder:
                (context, index) => VerticalDivider(
                  thickness: 1,
                  color: themeColor(context: context).inversePrimary,
                ),
          ),
        ),
      ),
    );
  }

  Widget upComingDaysWeather(
    double? maxTemp,
    double? minTemp,
    String? description,
    String? icon,
    time,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children:
            [
              bodyText(time),
              Image.network(
                "https://openweathermap.org/img/wn/$icon@2x.png",
                width: 40.w,
                height: 40.h,
                errorBuilder:
                    (context, error, stackTrace) => Icon(
                      Icons.cloud_off,
                      size: 50.sp,
                      color: themeColor(context: context).onSurfaceVariant,
                    ),
              ),
              smallText("${maxTemp.toString()} °C"),
              captionStyleText("${minTemp.toString()} °C"),
            ].separator(SizedBox(height: 5.h)).toList(),
      ),
    );
  }
}
