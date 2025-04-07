import 'package:agri_flutter/core/widgets/BaseStateFullWidget.dart';
import 'package:agri_flutter/providers/drawer/address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:agri_flutter/models/post_sign_up/default_farmer_address.dart';
import 'package:agri_flutter/services/firestore.dart';
import 'package:provider/provider.dart';

class AddAddressScreen extends BaseStatefulWidget {
  const AddAddressScreen({Key? key}) : super(key: key);

  @override
  String get routeName => '/addAddress';

  @override
  Route<dynamic> buildRoute() => materialRoute();

  @override
  State<StatefulWidget> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();

  final ValueNotifier<bool> _setAsDefault = ValueNotifier(false);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  final FirestoreService _firebaseService = FirestoreService();

  Future<void> _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      _isLoading.value = true;

      final address = DefaultFarmerAddress(
        name: _nameController.text.trim(),
        address1: _address1Controller.text.trim(),
        address2: _address2Controller.text.trim(),
        landmark: _landmarkController.text.trim(),
        contactNumber: int.parse(_contactNumberController.text),
        isDefault: _setAsDefault.value,
      );

      try {
        final addressProvider = Provider.of<AddressProvider>(
          context,
          listen: false,
        );
        await addressProvider.addAddress(address);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Address added successfully')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('❌ Failed to add address')),
          );
        }
      } finally {
        _isLoading.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Address', style: TextStyle(fontSize: 20.sp)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField("Name", _nameController),
                _buildTextField("Address Line 1", _address1Controller),
                _buildTextField("Address Line 2", _address2Controller),
                _buildTextField("Landmark", _landmarkController),
                _buildTextField(
                  "Contact Number",
                  _contactNumberController,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 15.h),
                ValueListenableBuilder<bool>(
                  valueListenable: _setAsDefault,
                  builder: (context, value, _) {
                    return CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        "Set as default address",
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      value: value,
                      onChanged: (val) => _setAsDefault.value = val ?? false,
                    );
                  },
                ),
                SizedBox(height: 30.h),
                ValueListenableBuilder<bool>(
                  valueListenable: _isLoading,
                  builder: (context, loading, _) {
                    return SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: loading ? null : _saveAddress,
                        child:
                            loading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : Text(
                                  'Save Address',
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator:
            (value) =>
                value == null || value.isEmpty ? 'Please enter $label' : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 14.h,
          ),
        ),
      ),
    );
  }
}
