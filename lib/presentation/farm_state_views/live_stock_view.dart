import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:agri_flutter/customs_widgets/custom_snackbar.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/core/drop_down_value.dart';
import 'package:agri_flutter/models/live_stock_detail.dart';
import 'package:agri_flutter/utils/comman.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../core/widgets/BaseStateFullWidget.dart';
import '../../providers/ai_provider.dart';
import '../../providers/farm_state_provider.dart/liveStock_provider.dart';
import '../../services/firestore.dart';
import '../../services/gimini_service_api.dart';

class LiveStockDetailView extends BaseStatefulWidget {
  final String? livestockId;

  const LiveStockDetailView({super.key, this.livestockId});

  @override
  State<LiveStockDetailView> createState() => _LiveStockDetailViewState();

  @override
  Route buildRoute() {
    return materialRoute();
  }

  static const String route = "/LiveStockDetailView";

  @override
  String get routeName => route;
}

class _LiveStockDetailViewState extends State<LiveStockDetailView> {
  // Controllers
  final TextEditingController _livestockNameController =
      TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _vaccinationDateController =
      TextEditingController();

  // Focus Nodes
  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodeAge = FocusNode();
  final FocusNode _focusNodeVaccinate = FocusNode();

  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Date Format
  final dateFormat = DateFormat("dd-MM-yyyy");

  // Services
  final FirestoreService _firestoreService = FirestoreService();
  final GeminiService _livestockAdviceService = GeminiService();

  // Store fetched LivestockDetail
  LiveStockDetail? _livestockDetails;

  @override
  void initState() {
    super.initState();
    if (widget.livestockId != null) {
      _loadLivestockData();
    }
  }

  Future<void> _loadLivestockData() async {
    if (widget.livestockId == null) return;

    try {
      final livestockList = await _firestoreService.getLiveStock();
      print("Fetched livestock list: ${livestockList.length} items");
      _livestockDetails = livestockList.firstWhere(
        (livestock) => livestock.id == widget.livestockId,
        orElse:
            () => LiveStockDetail(
              id: '',
              liveStockName: '',
              liveStockType: '',
              purpose: '',
              gender: '',
              age: 0,
              vaccinatedDate: DateTime.now(),
            ),
      );

      if (_livestockDetails?.id.isNotEmpty == true) {
        _livestockNameController.text = _livestockDetails!.liveStockName;
        _ageController.text = _livestockDetails!.age.toString();
        _vaccinationDateController.text = dateFormat.format(
          _livestockDetails!.vaccinatedDate,
        );
        final livestockProvider = Provider.of<LivestockProvider>(
          context,
          listen: false,
        );
        livestockProvider
          ..setLivestockType(
            LivestockType.values.firstWhere(
              (e) => e.name == _livestockDetails!.liveStockType,
              orElse: () => LivestockType.cow,
            ),
          )
          ..setLivestockPurpose(
            LivestockPurpose.values.firstWhere(
              (e) => e.name == _livestockDetails!.purpose,
              orElse: () => LivestockPurpose.breeding,
            ),
          )
          ..setGender(
            Gender.values.firstWhere(
              (e) => e.name == _livestockDetails!.gender,
              orElse: () => Gender.male,
            ),
          );
        if (_livestockDetails!.aiRecommendations != null) {
          Provider.of<AIProvider>(
            context,
            listen: false,
          ).setAiResponse(_livestockDetails!.aiRecommendations!);
        }
      } else {
        print("Livestock not found for ID: ${widget.livestockId}");
        showCustomSnackBar(context, "Livestock not found in Firestore");
      }
    } catch (e) {
      print("Error loading livestock data: $e");
      showCustomSnackBar(context, "Error loading livestock data: $e");
    }
  }

  DateTime? parseDate(String dateText) {
    try {
      return dateFormat.parse(dateText);
    } catch (e) {
      print("Error parsing date: $e");
      return null;
    }
  }

  Future<void> _getAIRecommendations() async {
    if (!_formKey.currentState!.validate()) {
      showCustomSnackBar(context, "Please fill all required fields");
      return;
    }

    final livestockProvider = Provider.of<LivestockProvider>(
      context,
      listen: false,
    );
    final aiProvider = Provider.of<AIProvider>(context, listen: false);
    aiProvider.setLoading(true);
    aiProvider.setShowAiResponse(true);

    try {
      final response = await _livestockAdviceService
          .getLiveStockRecommendations(
            livestockName: _livestockNameController.text,
            livestockType:
                livestockProvider.selectedLivestockType?.name ?? 'cow',
            livestockPurpose:
                livestockProvider.selectedLivestockPurpose?.name ?? 'breeding',
            gender: livestockProvider.selectedGender?.name ?? 'male',
            age: int.parse(_ageController.text),
            vaccinationDate: parseDate(_vaccinationDateController.text),
          );

      aiProvider.setAiResponse(response);
      aiProvider.setLoading(false);
    } catch (e) {
      aiProvider.setAiResponse("Error generating recommendations: $e");
      aiProvider.setLoading(false);
      showCustomSnackBar(context, "Failed to fetch recommendations: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final livestockProvider = Provider.of<LivestockProvider>(context);
    final aiProvider = Provider.of<AIProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Form(
          key: _formKey,
          child: Column(
            children:
                [
                  if (!aiProvider.showAiResponse) ...[
                    // Name
                    CustomFormField(
                      textInputAction: TextInputAction.next,
                      focusNode: _focusNodeName,
                      hintText: "Enter Livestock Name",
                      keyboardType: TextInputType.text,
                      label: 'Livestock Name',
                      textEditingController: _livestockNameController,
                      icon: Icon(Icons.pets),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter livestock name";
                        }
                        return null;
                      },
                    ),
                    // Livestock Type
                    reusableDropdown<LivestockType>(
                      label: "Livestock Type",
                      selectedValue:
                          livestockProvider.selectedLivestockType ??
                          LivestockType.cow,
                      items: LivestockType.values,
                      onChanged: (newValue) {
                        livestockProvider.setLivestockType(newValue);
                      },
                    ),
                    // Livestock Purpose
                    reusableDropdown<LivestockPurpose>(
                      label: "Livestock Purpose",
                      selectedValue:
                          livestockProvider.selectedLivestockPurpose ??
                          LivestockPurpose.breeding,
                      items: LivestockPurpose.values,
                      onChanged: (newValue) {
                        livestockProvider.setLivestockPurpose(newValue);
                      },
                    ),
                    // Gender
                    reusableDropdown<Gender>(
                      label: "Gender",
                      selectedValue:
                          livestockProvider.selectedGender ?? Gender.male,
                      items: Gender.values,
                      onChanged: (newValue) {
                        livestockProvider.setGender(newValue);
                      },
                    ),
                    // Age
                    CustomFormField(
                      textInputAction: TextInputAction.next,
                      focusNode: _focusNodeAge,
                      hintText: "Enter Age",
                      keyboardType: TextInputType.number,
                      label: 'Age',
                      textEditingController: _ageController,
                      icon: Icon(Icons.numbers),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter age";
                        }
                        if (int.tryParse(value) == null ||
                            int.parse(value) < 0) {
                          return "Please enter a valid age";
                        }
                        return null;
                      },
                    ),
                    // Vaccination Date
                    CustomFormField(
                      textInputAction: TextInputAction.done,
                      focusNode: _focusNodeVaccinate,
                      textEditingController: _vaccinationDateController,
                      label: "Vaccination Date",
                      hintText: "DD-MM-YYYY",
                      keyboardType: TextInputType.none,
                      isDatePicker: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select vaccination date";
                        }
                        return null;
                      },
                    ),
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
                            "Recommendations for ${_livestockNameController.text}",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Divider(height: 24.h),
                          if (aiProvider.isLoading)
                            Center(
                              child: Column(
                                children: [
                                  SizedBox(height: 30.h),
                                  showLoading(
                                context
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    "Generating expert recommendations...",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  SizedBox(height: 30.h),
                                ],
                              ),
                            )
                          else
                            Html(
                              data:
                                  aiProvider.aiResponse.isEmpty
                                      ? "No recommendations available"
                                      : aiProvider.aiResponse,
                              style: {
                                "h3": Style(
                                  fontSize: FontSize(18.sp),
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                "ul": Style(
                                  margin: Margins(bottom: Margin(8.h)),
                                ),
                                "li": Style(
                                  fontSize: FontSize(14.sp),
                                  margin: Margins(bottom: Margin(4.h)),
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              },
                            ),
                          SizedBox(height: 24.h),
                          CustomButton(
                            onClick: () {
                              if (_formKey.currentState!.validate()) {
                                final livestockProvider =
                                    Provider.of<LivestockProvider>(
                                      context,
                                      listen: false,
                                    );
                                final aiProvider = Provider.of<AIProvider>(
                                  context,
                                  listen: false,
                                );
                                final livestock = LiveStockDetail(
                                  id:
                                      _livestockDetails?.id ??
                                      const Uuid().v4(),
                                  liveStockName: _livestockNameController.text,
                                  liveStockType:
                                      livestockProvider
                                          .selectedLivestockType
                                          ?.name ??
                                      'cow',
                                  purpose:
                                      livestockProvider
                                          .selectedLivestockPurpose
                                          ?.name ??
                                      'breeding',
                                  gender:
                                      livestockProvider.selectedGender?.name ??
                                      'male',
                                  age: int.tryParse(_ageController.text) ?? 0,
                                  vaccinatedDate:
                                      parseDate(
                                        _vaccinationDateController.text,
                                      ) ??
                                      DateTime.now(),
                                  aiRecommendations:
                                      aiProvider.aiResponse.isEmpty
                                          ? null
                                          : aiProvider.aiResponse,
                                );

                                if (widget.livestockId != null) {
                                  livestockProvider
                                      .updateLivestock(
                                        _firestoreService.userId,
                                        livestock,
                                      )
                                      .then((_) {
                                        showCustomSnackBar(
                                          context,
                                          "Livestock updated successfully",
                                        );
                                        Navigator.pop(context);
                                      })
                                      .catchError((e) {
                                        showCustomSnackBar(
                                          context,
                                          "Error updating livestock: $e",
                                        );
                                      });
                                } else {
                                  livestockProvider
                                      .addLiveStock(livestock)
                                      .then((_) {
                                        showCustomSnackBar(
                                          context,
                                          "Livestock added successfully",
                                        );
                                        Navigator.pop(context);
                                      })
                                      .catchError((e) {
                                        showCustomSnackBar(
                                          context,
                                          "Error adding livestock: $e",
                                        );
                                      });
                                }
                              }
                            },
                            buttonName:
                                widget.livestockId == null
                                    ? 'Save Details'
                                    : 'Update Details',
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
                ].separator(SizedBox(height: 24.h)).toList(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _livestockNameController.dispose();
    _ageController.dispose();
    _vaccinationDateController.dispose();
    _focusNodeName.dispose();
    _focusNodeAge.dispose();
    _focusNodeVaccinate.dispose();
    super.dispose();
  }
}
