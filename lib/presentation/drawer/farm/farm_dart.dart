import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
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
      appBar: CustomAppBar(),
      body: StreamBuilder(
        stream: _farmBloc.farmList,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: bodyText(snapshot.error.toString()));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: bodyText("No Data found"));
          }

          final farmdata = snapshot.data ?? [];
          print(farmdata);
          print(farmdata);
          return ListView.builder(
            itemCount: farmdata.length,
            itemBuilder: (context, index) {
              final farm = farmdata[index];
              return farmDetailCard(farm, context);
            },
          );
        },
      ),
    );
  }


  Widget farmDetailCard(FarmDetail farm, BuildContext context) {
    if (farm.farmBoundaries.isEmpty) {
      return const SizedBox.shrink(); // or show a different placeholder
    }

    final List<LatLongData> boundaryPoints =
        farm.farmBoundaries
            .map(
              (point) => LatLongData(
                lat: point.lat?.toDouble() ?? 0.0,
                lng: point.lng?.toDouble() ?? 0.0,
              ),
            )
            .toList();

    // Generate polyline for static map
    final polyline = boundaryPoints.map((p) => '${p.lat},${p.lng}').join('|');

    final staticMapUrl =
        'https://maps.googleapis.com/maps/api/staticmap?size=600x300'
        '&path=color:0xff0000ff|weight:2|$polyline'
        '&key=AIzaSyBkdT5XD9WyRvWIupFFiF15Tl8aERHhPYI';

    return GestureDetector(
      onTap: () {
        NavigationUtils.push(
          MaterialPageRoute(
            builder:
                (_) => FarmBoundaryScreen(
                  farmId: farm.fieldName,
                  boundaryPoints: boundaryPoints,
                  onBoundaryUpdated: (newBoundary) {
                    // Optional: implement saving updated boundary back to Firestore
                  },
                ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(12),
        child: Column(
          children: [
            Image.network(
              staticMapUrl,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: Text("Failed to load map")),
                );
              },
            ),
            ListTile(
              title: Text(farm.fieldName),
              subtitle: Text('Area: ${farm.fieldSize} hectares'),
              trailing: const Icon(Icons.edit_location),
            ),
          ],
        ),
      ),
    );
  }
}

class FarmBoundaryScreen extends StatefulWidget {
  final List<LatLongData> boundaryPoints;
  final String farmId;
  final Function(List<LatLongData>)? onBoundaryUpdated;

  const FarmBoundaryScreen({
    super.key,
    required this.boundaryPoints,
    required this.farmId,
    this.onBoundaryUpdated,
  });

  @override
  State<FarmBoundaryScreen> createState() => _FarmBoundaryScreenState();
}

class _FarmBoundaryScreenState extends State<FarmBoundaryScreen> {
  late GoogleMapController _mapController;
  List<LatLongData> _editableBoundary = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Boundary - ${widget.farmId}")),
      body: GoogleMap(
        mapType: MapType.satellite,
        initialCameraPosition: CameraPosition(
          target: _editableBoundary.first.toLatLng(),
          zoom: 50,
        ),
        polygons: {
          Polygon(
            polygonId: PolygonId(widget.farmId),
            points:  _editableBoundary.map((e) => e.toLatLng()).toList(),
            strokeColor: Colors.green,
            fillColor: Colors.green.withOpacity(0.3),
            strokeWidth: 2,
          ),
        },
        onMapCreated: (controller) => _mapController = controller,
        onTap: _onMapTap,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (widget.onBoundaryUpdated != null) {
            widget.onBoundaryUpdated!(_editableBoundary);
          }
          Navigator.pop(context);
        },
        label: const Text("Save"),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
