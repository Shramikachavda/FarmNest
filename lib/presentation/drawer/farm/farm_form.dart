import 'package:agri_flutter/customs_widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/drop_down_value.dart';
import '../../../customs_widgets/add_farm_custom.dart';
import '../../../models/post_sign_up/farm_detail.dart';
import '../../../providers/post_sign_up_providers/default_farmer_address.dart';
import '../../../services/firestore.dart';
import '../../../services/local_storage/post_sign_up.dart';

class FarmForm extends StatefulWidget {
  const FarmForm({super.key});

  @override
  State<FarmForm> createState() => _FarmFormState();
}

class _FarmFormState extends State<FarmForm> {
  //form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //text editing controller
  final TextEditingController _fieldNameController = TextEditingController();

  final TextEditingController _cropDetailsController = TextEditingController();

  final TextEditingController _fieldSizeController = TextEditingController();

  final TextEditingController _stateController = TextEditingController();

  final TextEditingController _locationDescriptionController =
      TextEditingController();

  final TextEditingController _boundaryController = TextEditingController();

  //focus node
  final FocusNode _focusNodeName = FocusNode();

  final FocusNode _focusNodeCropDetail = FocusNode();

  final FocusNode _focusNodeFieldSize = FocusNode();

  final FocusNode _focusNodeState = FocusNode();

  final FocusNode _focusNodeBoundary = FocusNode();

  final FocusNode _focusNodeLocation = FocusNode();

  FarmOwnershipType selctedOwnerShip = FarmOwnershipType.family;

  FarmersAllocated selectedFarmer = FarmersAllocated.one;

  List<LatLongData> _farmBoundaries = [];

  final FirestoreService _firestoreService = FirestoreService();

  Future<void> _submitFarmDetails() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _firestoreService.addFarm(
          FarmDetail(
            fieldName: _fieldNameController.text.trim(),
            ownershipType: selctedOwnerShip.name,
            farmBoundaries: _farmBoundaries,
            cropDetails: _cropDetailsController.text.trim(),
            fieldSize: double.tryParse(_fieldSizeController.text.trim()) ?? 0.0,
            state: _stateController.text.trim(),
            locationDescription: _locationDescriptionController.text.trim(),
            farmersAllocated: selectedFarmer.name,
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Farm details saved successfully")),
        );

        final postSignupNotifier = context.read<PostSignupNotifier>();
        await LocalStorageService.setPostSignupCompleted();
        postSignupNotifier.completeSignupAndNavigate();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("❌ Error: $e")));
      }
    }
  }

  String _formatBoundaryCoordinates(List<LatLongData> points) {
    return points
        .map(
          (point) =>
              '[${point.lat?.toStringAsFixed(6)}, ${point.lng?.toStringAsFixed(6)}]',
        )
        .join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: buildAddFarmForm(
          context: context,
          formKey: _formKey,
          setState: setState,
          fieldNameController: _fieldNameController,
          boundaryController: _boundaryController,
          cropDetailsController: _cropDetailsController,
          fieldSizeController: _fieldSizeController,
          stateController: _stateController,
          locationController: _locationDescriptionController,
          focusNodeName: _focusNodeName,
          focusNodeBoundary: _focusNodeBoundary,
          focusNodeCropDetail: _focusNodeCropDetail,
          focusNodeFieldSize: _focusNodeFieldSize,
          focusNodeState: _focusNodeState,
          focusNodeLocation: _focusNodeLocation,
          onSubmit: _submitFarmDetails,
          farmBoundaries: _farmBoundaries,
          onBoundarySelected: (boundaries) {
            setState(() {
              _farmBoundaries = boundaries;
            });
          },
          selectedOwnership: selctedOwnerShip,
          onOwnershipChanged: (value) {
            setState(() {
              selctedOwnerShip = value;
            });
          },
          selectedFarmer: selectedFarmer,
          onFarmerChanged: (value) {
            setState(() {
              selectedFarmer = value;
            });
          },
          formatBoundary: _formatBoundaryCoordinates,
        ),
      ),
    );
  }
}
