import 'package:agri_flutter/customs_widgets/custom_app_bar.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:agri_flutter/models/post_sign_up/default_farmer_address.dart';
import 'package:agri_flutter/services/firestore.dart';
import 'package:agri_flutter/presentation/drawer/add_address.dart';
import 'package:agri_flutter/providers/drawer/address.dart';
import 'package:agri_flutter/providers/drawer/selected_address.dart';

class SelectAddressScreen extends StatefulWidget {
  const SelectAddressScreen({Key? key}) : super(key: key);

  @override
  State<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  final FirestoreService _firestore = FirestoreService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() => _isLoading = true);
    final addressProvider = Provider.of<AddressProvider>(
      context,
      listen: false,
    );
    await addressProvider.loadAddresses();
    if (addressProvider.addresses.isNotEmpty &&
        !addressProvider.addresses.any((addr) => addr.isDefault)) {
      final firstAddress = addressProvider.addresses.first;
      await _addDefaultLocation(firstAddress);
    }
    setState(() => _isLoading = false);
  }

  Future<void> _addNewAddress(DefaultFarmerAddress farm) async {
    try {
      await _firestore.addNewAddress(farm);
      final addressProvider = Provider.of<AddressProvider>(
        context,
        listen: false,
      );
      await addressProvider.loadAddresses();
      if (addressProvider.addresses.length == 1) {
        await _addDefaultLocation(farm);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error adding address: $e")));
    }
  }

  Future<void> _updateAddress(DefaultFarmerAddress farm) async {
    try {
      await _firestore.updateAddress(farm);
      Provider.of<AddressProvider>(context, listen: false).loadAddresses();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error updating address: $e")));
    }
  }

  Future<void> _deleteAddress(String addressName) async {
    try {
      await _firestore.deleteAddress(addressName);
      Provider.of<AddressProvider>(context, listen: false).loadAddresses();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error deleting address: $e")));
    }
  }

  Future<void> _addDefaultLocation(DefaultFarmerAddress farm) async {
    try {
      await _firestore.addDefaultLocation(farm);
      Provider.of<AddressProvider>(context, listen: false).loadAddresses();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving default address: $e")),
      );
    }
  }

  void _showUpdateDialog(DefaultFarmerAddress address) {
    final nameController = TextEditingController(text: address.name);
    final address1Controller = TextEditingController(text: address.address1);
    final address2Controller = TextEditingController(text: address.address2);
    final landmarkController = TextEditingController(text: address.landmark);
    final contactNumberController = TextEditingController(
      text: address.contactNumber.toString(),
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            title: Text(
              "Edit Address",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField("Name", nameController),
                  _buildTextField("Address Line 1", address1Controller),
                  _buildTextField("Address Line 2", address2Controller),
                  _buildTextField("Landmark", landmarkController),
                  _buildTextField(
                    "Contact Number",
                    contactNumberController,
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              TextButton(
                onPressed: () {
                  final updatedAddress = DefaultFarmerAddress(
                    name: nameController.text,
                    address1: address1Controller.text,
                    address2: address2Controller.text,
                    landmark: landmarkController.text,
                    contactNumber: int.parse(contactNumberController.text),
                    isDefault: address.isDefault,
                  );
                  _updateAddress(updatedAddress);
                  Navigator.pop(context);
                },
                child: Text("Save", style: TextStyle(color: Colors.green[600])),
              ),
              TextButton(
                onPressed: () {
                  final updatedAddress = DefaultFarmerAddress(
                    name: nameController.text,
                    address1: address1Controller.text,
                    address2: address2Controller.text,
                    landmark: landmarkController.text,
                    contactNumber: int.parse(contactNumberController.text),
                    isDefault: true,
                  );
                  _addDefaultLocation(updatedAddress);
                  Navigator.pop(context);
                },
                child: Text(
                  "Set as Default",
                  style: TextStyle(color: Colors.blue[600]),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 10.h,
          ),
        ),
      ),
    );
  }

  void _navigateToAddAddress() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddAddressScreen()),
    );
    if (result is DefaultFarmerAddress) {
      _addNewAddress(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);
    final selectedProvider = Provider.of<SelectedAddressProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(title: 'Select Address'),
      backgroundColor: themeColor().surface,
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.green),
              )
              : addressProvider.addresses.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_off,
                      size: 40.sp,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16.h),
                    bodyMediumText("No addresses found", color: Colors.grey),
                    SizedBox(height: 16.h),
                    ElevatedButton.icon(
                      onPressed: _navigateToAddAddress,
                      icon: const Icon(Icons.add),
                      label: const Text("Add an Address"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: _loadAddresses,
                color: Colors.green,
                child: ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemCount: addressProvider.addresses.length,
                  itemBuilder: (context, index) {
                    final address = addressProvider.addresses[index];
                    final isSelected =
                        selectedProvider.selected?.name == address.name;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.green[50] : Colors.white,
                        border: Border.all(
                          color:
                              isSelected
                                  ? Colors.green[600]!
                                  : Colors.grey[300]!,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: RadioListTile<DefaultFarmerAddress>(
                        value: address,
                        groupValue: addressProvider.addresses.firstWhere(
                          (addr) => addr.isDefault,
                          orElse: () => addressProvider.addresses.first,
                        ),
                        onChanged: (value) {
                          if (value != null) {
                            _addDefaultLocation(value);
                          }
                        },
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        title: Text(
                          address.name,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4.h),
                            Text("${address.address1}, ${address.address2}"),
                            if (address.landmark.isNotEmpty)
                              Text("Landmark: ${address.landmark}"),
                            Text("Contact: ${address.contactNumber}"),
                          ],
                        ),
                        secondary: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showUpdateDialog(address);
                            } else if (value == 'delete') {
                              _deleteAddress(address.name);
                            }
                          },
                          itemBuilder:
                              (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                              ],
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
