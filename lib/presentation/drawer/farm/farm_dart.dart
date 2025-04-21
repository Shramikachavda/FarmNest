import 'package:agri_flutter/core/image.dart';
import 'package:agri_flutter/customs_widgets/custom_snackbar.dart';
import 'package:agri_flutter/utils/comman.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../customs_widgets/custom_app_bar.dart';
import '../../../customs_widgets/reusable.dart';
import '../../../models/post_sign_up/farm_detail.dart';
import '../../../providers/map.dart';
import '../../../theme/theme.dart';
import '../../../utils/navigation/navigation_utils.dart';
import '../../post_sign_up/farm_detail2.dart';
import 'farm_bloc.dart';
import 'farm_form.dart';

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
            MaterialPageRoute(builder: (context) => FarmForm()),
          );
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: _farmBloc.farmList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: showLoading(context));
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
                  children:
                      [
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
                                            onPressed:
                                                () => Navigator.pop(context),
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
                      ].separator(SizedBox(height: 8)).toList(),
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

  void _clearBoundary() {
    final boundaryProvider = Provider.of<BoundaryProvider>(
      context,
      listen: false,
    );
    boundaryProvider.clearBoundary();

    setState(() {
      _editableBoundary = [];
      print("Cleared boundary: ${_editableBoundary.length} points");
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Boundary cleared'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _editableBoundary = List.from(widget.boundaryPoints);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "map boundary",),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(

              mapType: MapType.satellite,
              onMapCreated: (controller) {
                _mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target:
                    _editableBoundary.isNotEmpty
                        ? _editableBoundary.first.toLatLng()
                        : const LatLng(23.123, 72.456),
                zoom: 20.0,

              ),
              polygons:
                  _editableBoundary.isNotEmpty
                      ? {
                        Polygon(
                          polygonId: PolygonId(widget.farmId),
                          points:
                              _editableBoundary
                                  .map((e) => e.toLatLng())
                                  .toList(),
                          strokeColor: themeColor(context: context).primary,
                          fillColor: themeColor(context: context).primary,
                          strokeWidth: 2,
                        ),
                      }
                      : {},
              markers:
                  _editableBoundary
                      .asMap()
                      .entries
                      .map(
                        (entry) => Marker(
                          markerId: MarkerId('marker_${entry.key}'),
                          position: entry.value.toLatLng(),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRed,
                          ),
                        ),
                      )
                      .toSet(),

              onTap: (LatLng tappedLatLng) {
                setState(() {
                  _editableBoundary.add(
                    LatLongData(lat: tappedLatLng.latitude, lng: tappedLatLng.longitude, ),
                  );
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _clearBoundary,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear Boundary'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_editableBoundary.length < 4) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Select at least 3 points'),
                        ),
                      );
                      return;
                    }

                    final boundaryProvider = Provider.of<BoundaryProvider>(
                      context,
                      listen: false,
                    );

                    List<LatLng> updatedLatLngPoints =
                        _editableBoundary.map((e) => e.toLatLng()).toList();
                    boundaryProvider.updateAllPoints(updatedLatLngPoints);
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
