import 'package:agri_flutter/customs_widgets/custom_app_bar.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:agri_flutter/utils/comman.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:agri_flutter/models/post_sign_up/default_farmer_address.dart';
import 'package:agri_flutter/services/firestore.dart';
import 'package:agri_flutter/presentation/drawer/add_address.dart';
import 'package:agri_flutter/providers/drawer/address_provider.dart';
import 'package:agri_flutter/providers/drawer/selected_address.dart';
import '../../utils/navigation/navigation_utils.dart';

class SelectAddressScreen extends StatefulWidget {
  const SelectAddressScreen({Key? key}) : super(key: key);

  @override
  State<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {


  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final addressProvider = Provider.of<AddressProvider>(context, listen: false);
    final selectedAddressProvider = Provider.of<SelectedAddressProvider>(context, listen: false);

    await addressProvider.loadAddresses();
    final addresses = addressProvider.addresses;

    if (addresses.isNotEmpty) {
      // Automatically select the default address
      final defaultAddress = addresses.firstWhere(
            (addr) => addr.isDefault,
        orElse: () => addresses.first,
      );
      selectedAddressProvider.setAddress(defaultAddress);
    }
  }


  Future<void> _addNewAddress(DefaultFarmerAddress farm) async {
    try {
      final addressProvider = Provider.of<AddressProvider>(context, listen: false);
      await addressProvider.addAddress(farm);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding address: $e")),
      );
    }
  }

  Future<void> _updateAddress(DefaultFarmerAddress farm) async {
    try {
      final addressProvider = Provider.of<AddressProvider>(context, listen: false);
      await addressProvider.updateAddress(farm);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating address: $e")),
      );
    }
  }

  Future<void> _deleteAddress(String addressName) async {
    try {
      final addressProvider = Provider.of<AddressProvider>(context, listen: false);
      await addressProvider.deleteAddress(addressName);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting address: $e")),
      );
    }
  }

  void _navigateToAddAddress({bool isEdit = false}) async {
    final addressProvider = Provider.of<AddressProvider>(context, listen: false); // <-- Add this
    final selectedAddressProvider =
    Provider.of<SelectedAddressProvider>(context, listen: false);

    if (isEdit) {
      final currentAddress = addressProvider.addresses
          .firstWhere((addr) => addr.name == selectedAddressProvider.selected?.name);
      selectedAddressProvider.setAddress(currentAddress);
    } else {
      selectedAddressProvider.clear();
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddAddressScreen()),
    );
    if (result is DefaultFarmerAddress) {
      if (isEdit) {
        await _updateAddress(result);
      } else {
        await _addNewAddress(result);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);
    final selectedAddressProvider = Provider.of<SelectedAddressProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Select Address',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToAddAddress(isEdit: false),
          ),
        ],
      ),
      backgroundColor: themeColor().surface,
      body: addressProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : addressProvider.addresses.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 40.sp,
              color: Colors.grey,
            ),
            bodyMediumText(
              "No addresses found",
              color: Colors.grey,
            ),
            ElevatedButton.icon(
              onPressed: () => _navigateToAddAddress(isEdit: false),
              icon: Icon(Icons.add, size: 24.sp),
              label: const Text("Add an Address"),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ].separator(SizedBox(height: 10.h)).toList(),
        ),
      )
          : Padding(
        padding: EdgeInsets.only(
          top: 12.h,
          left: 24.w,
          right: 24.w,
          bottom: 24.h,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: addressProvider.addresses.length,
          itemBuilder: (context, index) {
            final address = addressProvider.addresses[index];
            final isSelected =
                selectedAddressProvider.selected?.name == address.name;

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
                side: BorderSide(
                  color: isSelected
                      ? themeColor(context: context).outlineVariant
                      : themeColor(context: context).primary,
                  width: 2,
                ),
              ),
              child: RadioListTile<DefaultFarmerAddress>(
                value: address,
                  groupValue: selectedAddressProvider.selected ,
                onChanged: (value) async {
                  if (value != null) {
                    selectedAddressProvider.setAddress(value);
                    final addressProvider =
                    Provider.of<AddressProvider>(context, listen: false);
                    await addressProvider.setDefault(value);
                    Navigator.pop(context); // Return to CheckoutView
                  }
                },
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 8.h,
                ),
                title: bodyMediumBoldText(address.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4.h),
                    Text(
                      "${address.address1}, ${address.address2}",
                    ),
                    if (address.landmark.isNotEmpty)
                      captionStyleText(
                        "Landmark: ${address.landmark}",
                      ),
                    captionStyleText(
                      "Contact: ${address.contactNumber}",
                    ),
                  ],
                ),
                secondary: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _navigateToAddAddress(isEdit: true);
                    } else if (value == 'delete') {
                      _deleteAddress(address.name);
                    }
                  },
                  itemBuilder: (context) => [
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

