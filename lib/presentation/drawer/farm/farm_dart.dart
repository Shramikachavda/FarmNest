import 'package:agri_flutter/core/image.dart';
import 'package:agri_flutter/customs_widgets/custom_snackbar.dart';
import 'package:agri_flutter/utils/comman.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../customs_widgets/custom_app_bar.dart';
import '../../../customs_widgets/reusable.dart';
import '../../../models/post_sign_up/farm_detail.dart';
import '../../../theme/theme.dart';
import '../../../utils/navigation/navigation_utils.dart';
import '../../post_sign_up/farm_detail2.dart';
import 'farm_bloc.dart';

class Farm extends StatefulWidget {
  const Farm({super.key});

  @override
  State<Farm> createState() => _FarmState();
}

class _FarmState extends State<Farm> {
  final FarmBloc _farmBloc = FarmBloc();


  @override
  void didChangeDependencies() async {
    await _farmBloc.getFarmDetail();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor(context: context).surface,
      appBar: CustomAppBar(title: "Your Farms"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NavigationUtils.push(
            MaterialPageRoute(
              builder: (context) => AddFarmFieldLocationScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: _farmBloc.farmList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: bodyText(snapshot.error.toString()));
          }

          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return Center(child: bodyText("Add your farm"));
          }

          final farmdata = snapshot.data ?? [];
          print(farmdata);

          return ListView.builder(
            itemCount: farmdata.length,
            itemBuilder: (context, index) {
              final farm = farmdata[index];
              return farmDetailCard(farm);
            },
          );
        },
      ),
    );
  }

  Widget farmDetailCard(FarmDetail farm) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Stack(
            children: [
              //image
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  ImageConst.bg3,
                  height: 260.h,
                  fit: BoxFit.cover,
                  opacity: AlwaysStoppedAnimation(0.2),
                ),
              ),

              //data
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //name and delete button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        bodyMediumBoldText(farm.fieldName, maxLine: 2),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: const Text('Delete Farm'),
                                    content: Text(
                                      'Are you sure you want to delete ${farm.fieldName}?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          final isDelete = await _farmBloc
                                              .deleteFarm(farm.id);
                                          Navigator.pop(context);

                                          if (isDelete) {
                                            showCustomSnackBar(
                                              context,
                                              '${farm.fieldName} deleted',
                                            );
                                          } else {
                                            showCustomSnackBar(
                                              context,
                                              '${farm.fieldName}is not deleted',
                                            );
                                          }
                                        },
                                        child: bodyText('Delete'),
                                      ),
                                    ],
                                  ),
                            );
                          },
                        ),
                      ],
                    ),

                    //crop and area
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 10.w,
                      children: [
                        Icon(Icons.grass, size: 20.sp),
                        bodyText(farm.cropDetails, maxLine: 2),
                        SizedBox(width: 15.w),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          spacing: 10.w,
                          children: [
                            Icon(Icons.aspect_ratio, size: 20.sp),
                            bodyText('${farm.fieldSize} ', maxLine: 2),
                          ],
                        ),
                      ],
                    ),

                    //ownership type and farmer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 10.w,
                      children: [
                        Icon(Icons.badge, size: 20.sp),
                        bodyText(" ${farm.ownershipType}", maxLine: 2),
                        SizedBox(width: 15.w),

                        //farmer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          spacing: 10.w,
                          children: [
                            Icon(Icons.groups, size: 20.sp),
                            bodyText(' ${farm.farmersAllocated}'),
                          ],
                        ),
                      ],
                    ),

                    //location  city and
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 10.w,
                      children: [
                        Icon(Icons.location_on, size: 20.sp),
                        bodyText(farm.locationDescription, maxLine: 2),

                        //    SizedBox(width: 5.w),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 10.w,
                      children: [
                        Icon(Icons.location_city, size: 20.sp),
                        bodyText(farm.state),
                      ],
                    ),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            NavigationUtils.push(
                              MaterialPageRoute(
                                builder:
                                    (_) => FarmBoundaryScreen(
                                      farmId: farm.id,
                                      boundaryPoints: farm.farmBoundaries,
                                      onBoundaryUpdated: (newBoundary) {
                                        _farmBloc.updateFarmBoundary(
                                          farm.id,
                                          newBoundary,
                                        );
                                      },
                                    ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.map),
                          label: bodyText('View Map'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                themeColor(context: context).primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                      ],
                    ),

            /*        //advice
                    // AI Response Section
                    Consumer<AIProvider>(
                      builder: (context, aiProvider, _) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                          [
                            // Other farm details...

                            // AI Response Button and Text
                         Row(children: [
                           Icon(Icons.tips_and_updates),
                           TextButton(onPressed: (){   aiProvider.getSuggestion(
                             context,
                             farm,
                           );}, child: smallText("Get Advice"))
                         ],)


                          ].separator(SizedBox(height: 8.h)).toList(),
                        );
                      },
                    ),
                    if (farm.aiResponse != null)
                      Text(
                        farm.aiResponse ?? "No response",
                        maxLines: 3,
                      ),  */

                  ].separator(SizedBox(height: 8,)).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FarmBoundaryScreen extends StatefulWidget {
  final String farmId;

  final List<LatLongData> boundaryPoints;
  final Function(List<LatLongData>)? onBoundaryUpdated;

  const FarmBoundaryScreen({
    super.key,
    required this.farmId,

    required this.boundaryPoints,
    this.onBoundaryUpdated,
  });

  @override
  State<FarmBoundaryScreen> createState() => _FarmBoundaryScreenState();
}

class _FarmBoundaryScreenState extends State<FarmBoundaryScreen> {
  late GoogleMapController _mapController;
  late List<LatLongData> _editableBoundary;

  @override
  void initState() {
    super.initState();
    _editableBoundary = List.from(widget.boundaryPoints);
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _editableBoundary.add(
        LatLongData(lat: position.latitude, lng: position.longitude),
      );
    });
  }

  void _onMarkerTap(LatLongData point) {
    setState(() {
      _editableBoundary.removeWhere((p) {
        // Check if lat and lng are non-null for both p and point
        if (p.lat == null ||
            p.lng == null ||
            point.lat == null ||
            point.lng == null) {
          return false; // Skip if any coordinate is null
        }
        return (p.lat! - point.lat!).abs() < 0.0001 &&
            (p.lng! - point.lng!).abs() < 0.0001;
      });
    });
  }

  void _clearBoundary() {
    setState(() {
      _editableBoundary.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              mapType: MapType.satellite,
              initialCameraPosition: CameraPosition(
                target:
                    _editableBoundary.isNotEmpty
                        ? _editableBoundary.first.toLatLng()
                        : const LatLng(23.123, 72.456),
                zoom: 20.0,
              ),
              polygons: {
                Polygon(
                  polygonId: PolygonId(widget.farmId),
                  points: _editableBoundary.map((e) => e.toLatLng()).toList(),
                  strokeColor: Colors.green,
                  fillColor: Colors.green,
                  strokeWidth: 2,
                ),
              },
              markers:
                  _editableBoundary
                      .map(
                        (point) => Marker(
                          markerId: MarkerId(point.toString()),
                          position: point.toLatLng(),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRed,
                          ),
                          onTap: () => _onMarkerTap(point),
                        ),
                      )
                      .toSet(),
              onMapCreated: (controller) => _mapController = controller,
              onTap: _onMapTap,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton.icon(
                  onPressed: _clearBoundary,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear Boundary'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_editableBoundary.length < 3) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Select at least 3 points'),
                        ),
                      );
                      return;
                    }
                    if (widget.onBoundaryUpdated != null) {
                      widget.onBoundaryUpdated!(_editableBoundary);
                    }
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Boundary updated')),
                    );
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor(context: context).primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
