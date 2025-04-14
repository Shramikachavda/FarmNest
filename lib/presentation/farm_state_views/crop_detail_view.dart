import 'package:agri_flutter/core/drop_down_value.dart';
import 'package:agri_flutter/core/widgets/BaseStateFullWidget.dart';
import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:agri_flutter/customs_widgets/custom_snackbar.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/models/crop_details.dart';
import 'package:agri_flutter/providers/ai_provider.dart';
import 'package:agri_flutter/providers/api_provider/weather_provider.dart';
import 'package:agri_flutter/providers/farm_state_provider.dart/crop_details_provider.dart';
import 'package:agri_flutter/providers/location_provider.dart';
import 'package:agri_flutter/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../services/gimini_service_api.dart';

class CropAdvisorView extends BaseStatefulWidget {
  final String? existingCrop;

  const CropAdvisorView({super.key, this.existingCrop});

  @override
  State<CropAdvisorView> createState() => _CropAdvisorViewState();

  @override
  Route buildRoute() {
    return materialRoute();
  }

  static const String route = "/CropAdvisorView";

  @override
  String get routeName => route;
}

class _CropAdvisorViewState extends State<CropAdvisorView> {
  // Controllers
  final TextEditingController _cropNameController = TextEditingController();
  final TextEditingController _sowingDateController = TextEditingController();
  final TextEditingController _harvestDateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _humidityController = TextEditingController();

  // Focus nodes
  final FocusNode _focusNodeCrop = FocusNode();
  final FocusNode _focusNodeSowing = FocusNode();
  final FocusNode _focusNodeHarvest = FocusNode();
  final FocusNode _focusNodeLocation = FocusNode();
  final FocusNode _focusNodeTemp = FocusNode();
  final FocusNode _focusNodeHumidity = FocusNode();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Date format
  final dateFormat = DateFormat("dd-MM-yyyy");

  // Services
  final FirestoreService _firestoreService = FirestoreService();
  final GeminiService _geminiService = GeminiService();

  // Store fetched CropDetails
  CropDetails? _cropDetails;

  @override
  void initState() {
    super.initState();
    final cropProvider = Provider.of<CropDetailsProvider>(context, listen: false);
    if (widget.existingCrop == null) {
      cropProvider.setGrowth(GrowthStage.seedling);
      cropProvider.setFerti(FertilizerType.organic);
      cropProvider.setPesti(PesticideType.insecticide);
    } else {
      _loadCropData();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LocationProvider>(context, listen: false).getLocation();
      _loadWeather();
    });
  }

  Future<void> _loadCropData() async {
    if (widget.existingCrop == null) return;

    try {
      final cropProvider = Provider.of<CropDetailsProvider>(context, listen: false);
      final crops = await _firestoreService.getCrops();
      final crop = crops.firstWhere(
            (crop) => crop.id == widget.existingCrop,
        orElse: () => CropDetails(
          id: '',
          fertilizer: '',
          pesticide: '',
          cropName: '',
          growthStage: '',
          startDate: DateTime.now(),
          harvestDate: DateTime.now(),
        ),
      );

      if (crop.id.isNotEmpty) {
        setState(() {
          _cropDetails = crop;
          _cropNameController.text = crop.cropName;
          _sowingDateController.text = dateFormat.format(crop.startDate);
          _harvestDateController.text = dateFormat.format(crop.harvestDate);
          _locationController.text = crop.location ?? '';
          _temperatureController.text = crop.temperature ?? '30';
          _humidityController.text = crop.humidity ?? '60';
        });
        cropProvider.setGrowth(GrowthStage.values.firstWhere(
              (e) => e.name == crop.growthStage,
          orElse: () => GrowthStage.seedling,
        ));
        cropProvider.setFerti(FertilizerType.values.firstWhere(
              (e) => e.name == crop.fertilizer,
          orElse: () => FertilizerType.organic,
        ));
        cropProvider.setPesti(PesticideType.values.firstWhere(
              (e) => e.name == crop.pesticide,
          orElse: () => PesticideType.insecticide,
        ));
        if (crop.aiRecommendations != null) {
          Provider.of<AIProvider>(context, listen: false).setAiResponse(crop.aiRecommendations!);
        }
      } else {
        showCustomSnackBar(context, "Crop not found in Firestore");
      }
    } catch (e) {
      showCustomSnackBar(context, "Error loading crop data: $e");
    }
  }

  Future<void> _loadWeather() async {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    if (locationProvider.latitude != null && locationProvider.longitude != null) {
      try {
        await Provider.of<WeatherViewModel>(context, listen: false).loadWeather(
          locationProvider.latitude!,
          locationProvider.longitude!,
        );
        final weather = Provider.of<WeatherViewModel>(context, listen: false);
        if (weather.currentWeather != null) {
          setState(() {
            _temperatureController.text = weather.currentWeather!['main']?['temp']?.toString() ?? '30';
            _humidityController.text = weather.currentWeather!['main']?['humidity']?.toString() ?? '60';
          });
        }
      } catch (e) {
        showCustomSnackBar(context, "Failed to load weather data: $e");
      }
    }
  }

  DateTime? parseDate(String dateText) {
    try {
      return dateFormat.parse(dateText);
    } catch (e) {
      return null;
    }
  }

  Future<void> _getAIRecommendations() async {
    if (!_formKey.currentState!.validate()) {
      showCustomSnackBar(context, "Please fill all required fields");
      return;
    }

    final cropProvider = Provider.of<CropDetailsProvider>(context, listen: false);
    if (cropProvider.selectedStage == null ||
        cropProvider.selectedFertilizer == null ||
        cropProvider.selectedPesticide == null) {
      showCustomSnackBar(context, "Please select growth stage, fertilizer, and pesticide");
      return;
    }

    final aiProvider = Provider.of<AIProvider>(context, listen: false);
    aiProvider.setLoading(true);
    aiProvider.setShowAiResponse(true);

    try {
      final weather = Provider.of<WeatherViewModel>(context, listen: false);


      final response = await _geminiService.getCropRecommendations(
        cropName: _cropNameController.text,
        growthStage: cropProvider.selectedStage!.name,
        sowingDate: parseDate(_sowingDateController.text) ,
        harvestDate:parseDate(_harvestDateController.text) ,
        fertilizer: cropProvider.selectedFertilizer!.name,
        pesticide: cropProvider.selectedPesticide!.name,
        temperature: _temperatureController.text,
        humidity: _humidityController.text,
        location: _locationController.text.isNotEmpty ? _locationController.text : null,
      );

      aiProvider.setAiResponse(response);
      aiProvider.setLoading(false);
    } catch (e) {
      aiProvider.setAiResponse("Error generating recommendations: $e");
      aiProvider.setLoading(false);
      showCustomSnackBar(context, "Something went wrong. Try again later: $e");
    }
  }

  Future<void> _saveCropDetails() async {
    if (!_formKey.currentState!.validate()) {
      showCustomSnackBar(context, "Please fill all required fields");
      return;
    }

    final cropProvider = Provider.of<CropDetailsProvider>(context, listen: false);
    if (cropProvider.selectedStage == null ||
        cropProvider.selectedFertilizer == null ||
        cropProvider.selectedPesticide == null) {
      showCustomSnackBar(context, "Please select growth stage, fertilizer, and pesticide");
      return;
    }

    final aiProvider = Provider.of<AIProvider>(context, listen: false);
    final weather = Provider.of<WeatherViewModel>(context, listen: false);
    final cropDetails = CropDetails(
      id: _cropDetails?.id ?? const Uuid().v4(),
      cropName: _cropNameController.text,
      growthStage: cropProvider.selectedStage!.name,
      startDate: parseDate(_sowingDateController.text) ?? DateTime.now(),
      harvestDate: parseDate(_harvestDateController.text) ?? DateTime.now(),
      location: _locationController.text.isNotEmpty ? _locationController.text : null,
      fertilizer: cropProvider.selectedFertilizer!.name,
      pesticide: cropProvider.selectedPesticide!.name,
      temperature: _temperatureController.text.isNotEmpty ? _temperatureController.text : null,
      humidity: _humidityController.text.isNotEmpty ? _humidityController.text : null,

      aiRecommendations: aiProvider.aiResponse.isNotEmpty ? aiProvider.aiResponse : null,
    );

    try {
      if (_cropDetails?.id.isNotEmpty ?? false) {
        await cropProvider.updateCrop(_firestoreService.userId, cropDetails);
        showCustomSnackBar(context, "Crop updated successfully");
      } else {
        await cropProvider.addCrop(cropDetails);
        showCustomSnackBar(context, "Crop added successfully");
      }
      Navigator.pop(context);
    } catch (e) {
      showCustomSnackBar(context, "Error saving crop: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherViewModel>(context);
    final locationProvider = Provider.of<LocationProvider>(context);
    final aiProvider = Provider.of<AIProvider>(context);
    final cropDetailsProvider = Provider.of<CropDetailsProvider>(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 12.h),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!aiProvider.showAiResponse) ...[
                  _buildSection(
                    title: "Basic Information",
                    children: [
                      CustomFormField(
                        textInputAction: TextInputAction.next,
                        focusNode: _focusNodeCrop,
                        hintText: "Enter Crop Name",
                        keyboardType: TextInputType.text,
                        label: 'Crop Name',
                        textEditingController: _cropNameController,
                        icon: const Icon(Icons.grass),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter crop name";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24.h),
                      reusableDropdown<GrowthStage>(
                        label: "Growth Stage",
                        selectedValue: cropDetailsProvider.selectedStage ?? GrowthStage.seedling,
                        items: GrowthStage.values,
                        onChanged: (newValue) {
                          cropDetailsProvider.setGrowth(newValue);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  _buildSection(
                    title: "Important Dates",
                    children: [
                      CustomFormField(
                        focusNode: _focusNodeSowing,
                        textInputAction: TextInputAction.next,
                        textEditingController: _sowingDateController,
                        label: "Sowing Date",
                        hintText: "DD-MM-YYYY",
                        keyboardType: TextInputType.none,
                        isDatePicker: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select sowing date";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24.h),
                      CustomFormField(
                        focusNode: _focusNodeHarvest,
                        textInputAction: TextInputAction.next,
                        textEditingController: _harvestDateController,
                        label: "Expected Harvest Date",
                        hintText: "DD-MM-YYYY",
                        keyboardType: TextInputType.none,
                        isDatePicker: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select harvest date";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  _buildSection(
                    title: "Crop Care Details",
                    children: [
                      reusableDropdown<FertilizerType>(
                        label: "Fertilizer Used",
                        selectedValue: cropDetailsProvider.selectedFertilizer ?? FertilizerType.organic,
                        items: FertilizerType.values,
                        onChanged: (newValue) {
                          cropDetailsProvider.setFerti(newValue);
                        },
                      ),
                      SizedBox(height: 24.h),
                      reusableDropdown<PesticideType>(
                        label: "Pesticide Used",
                        selectedValue: cropDetailsProvider.selectedPesticide ?? PesticideType.insecticide,
                        items: PesticideType.values,
                        onChanged: (newValue) {
                          cropDetailsProvider.setPesti(newValue);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  _buildSection(
                    title: "Weather Conditions",
                    children: [
                      CustomFormField(
                        focusNode: _focusNodeTemp,
                        textInputAction: TextInputAction.next,
                        hintText: weatherProvider.currentWeather != null
                            ? "${weatherProvider.currentWeather!['main']?['temp']?.toString() ?? 'N/A'}°C"
                            : "Fetching temperature...",
                        keyboardType: TextInputType.number,
                        label: 'Temperature (°C)',
                        textEditingController: _temperatureController,
                        icon: const Icon(Icons.thermostat),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter temperature";
                          }
                          if (double.tryParse(value) == null) {
                            return "Please enter a valid number";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24.h),
                      CustomFormField(
                        focusNode: _focusNodeHumidity,
                        textInputAction: TextInputAction.next,
                        hintText: weatherProvider.currentWeather != null
                            ? "${weatherProvider.currentWeather!['main']?['humidity']?.toString() ?? 'N/A'}%"
                            : "Fetching humidity...",
                        keyboardType: TextInputType.number,
                        label: 'Humidity (%)',
                        textEditingController: _humidityController,
                        icon: const Icon(Icons.water_drop),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter humidity";
                          }
                          if (double.tryParse(value) == null || double.parse(value) < 0 || double.parse(value) > 100) {
                            return "Please enter a valid percentage (0-100)";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  _buildSection(
                    title: "Location",
                    children: [
                      CustomFormField(
                        focusNode: _focusNodeLocation,
                        textInputAction: TextInputAction.done,
                        hintText: locationProvider.currentAddress?.isNotEmpty == true
                            ? locationProvider.currentAddress!
                            : "Enter farm location",
                        keyboardType: TextInputType.text,
                        label: 'Farm Location',
                        textEditingController: _locationController,
                        icon: IconButton(
                          icon: Icon(
                            Icons.my_location,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () {
                            if (locationProvider.currentAddress != null) {
                              _locationController.text = locationProvider.currentAddress!;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  CustomButton(
                    onClick: _getAIRecommendations,
                    buttonName: 'Get AI Recommendations',
                  ),
                ] else ...[
                  Container(
                    padding: EdgeInsets.all(16.r),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                aiProvider.setShowAiResponse(false);
                              },
                              icon: Icon(Icons.arrow_back, size: 20.sp),
                            ),
                            Icon(
                              Icons.smart_toy,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Farm Nest AI Advisor",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Recommendations for ${_cropNameController.text.isNotEmpty ? _cropNameController.text : 'your crop'}",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Divider(height: 24.h),
                        if (aiProvider.isLoading)
                          Center(
                            child: Column(
                              children: [
                                SizedBox(height: 30.h),
                                CircularProgressIndicator(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  "Generating expert recommendations...",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                SizedBox(height: 30.h),
                              ],
                            ),
                          )
                        else
                          Html(
                            data: aiProvider.aiResponse.isEmpty
                                ? "No recommendations available"
                                : aiProvider.aiResponse,
                            style: {
                              "h3": Style(
                                fontSize: FontSize(18.sp),
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              "ul": Style(margin: Margins(bottom: Margin(8.h))),
                              "li": Style(
                                fontSize: FontSize(14.sp),
                                margin: Margins(bottom: Margin(4.h)),
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            },
                          ),
                        SizedBox(height: 24.h),
                        CustomButton(
                          onClick: _saveCropDetails,
                          buttonName: 'Save Crop & Recommendations',
                        ),
                        SizedBox(height: 12.h),
                        CustomButton(
                          onClick: () {
                            aiProvider.setShowAiResponse(false);
                          },
                          buttonName: 'Back to Form',
                        ),
                      ],
                    ),
                  ),
                ],
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(height: 12.h),
        ...children,
      ],
    );
  }

  @override
  void dispose() {
    _cropNameController.dispose();
    _sowingDateController.dispose();
    _harvestDateController.dispose();
    _locationController.dispose();
    _temperatureController.dispose();
    _humidityController.dispose();
    _focusNodeCrop.dispose();
    _focusNodeSowing.dispose();
    _focusNodeHarvest.dispose();
    _focusNodeLocation.dispose();
    _focusNodeTemp.dispose();
    _focusNodeHumidity.dispose();
    super.dispose();
  }
}