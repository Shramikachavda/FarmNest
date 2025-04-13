import 'package:agri_flutter/customs_widgets/custom_app_bar.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:agri_flutter/utils/comman.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:agri_flutter/models/post_sign_up/default_farmer_address.dart';
import 'package:agri_flutter/presentation/drawer/add_address.dart';
import 'package:agri_flutter/providers/drawer/address_provider.dart';
import 'package:agri_flutter/providers/drawer/selected_address.dart';

class SelectAddressScreen extends StatefulWidget {
  const SelectAddressScreen({Key? key}) : super(key: key);

  @override
  State<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  List<DefaultFarmerAddress> _addresses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final addressProvider = Provider.of<AddressProvider>(
        context,
        listen: false,
      );
      await addressProvider.loadAddressesSilently();
      setState(() {
        _addresses = addressProvider.addresses;
        _isLoading = false;
      });
      print(
        "Loaded Addresses: ${_addresses.map((a) => '${a.name}: ${a.isDefault}').toList()}",
      );
    } catch (e) {
      print("Error loading addresses: $e");
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load addresses: $e")));
    }
  }

  Future<void> _setDefaultAddress(DefaultFarmerAddress address) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final addressProvider = Provider.of<AddressProvider>(
        context,
        listen: false,
      );
      final selectedAddressProvider = Provider.of<SelectedAddressProvider>(
        context,
        listen: false,
      );
      await addressProvider.setDefault(address);
      selectedAddressProvider.setAddress(address);
      await _loadAddresses();
      print("Default set to: ${address.name}. Screen should NOT pop.");
    } catch (e) {
      print("Error setting default address: $e");
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to set default: $e")));
    }
  }

  Future<void> _addNewAddress(DefaultFarmerAddress farm) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final addressProvider = Provider.of<AddressProvider>(
        context,
        listen: false,
      );
      await addressProvider.addAddress(farm);
      await _loadAddresses();
    } catch (e) {
      print("Error adding address: $e");
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to add address: $e")));
    }
  }

  Future<void> _updateAddress(DefaultFarmerAddress farm) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final addressProvider = Provider.of<AddressProvider>(
        context,
        listen: false,
      );
      await addressProvider.updateAddress(farm);
      await _loadAddresses();
    } catch (e) {
      print("Error updating address: $e");
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to update address: $e")));
    }
  }

  Future<void> _deleteAddress(String addressName) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final addressProvider = Provider.of<AddressProvider>(
        context,
        listen: false,
      );
      final selectedAddressProvider = Provider.of<SelectedAddressProvider>(
        context,
        listen: false,
      );

      // Check if the deleted address is the selected one
      if (selectedAddressProvider.selected?.name == addressName) {
        selectedAddressProvider.clear();
        print("Deleted address was selected, cleared SelectedAddressProvider.");
      }

      await addressProvider.deleteAddress(addressName);
      await _loadAddresses();

      // If addresses remain, set a new default if none exists
      if (_addresses.isNotEmpty && !_addresses.any((addr) => addr.isDefault)) {
        final newDefault = _addresses.first;
        await addressProvider.setDefault(newDefault);
        selectedAddressProvider.setAddress(newDefault);
        print("Set new default after delete: ${newDefault.name}");
      }
    } catch (e) {
      print("Error deleting address: $e");
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to delete address: $e")));
    }
  }

  void _navigateToAddAddress({
    bool isEdit = false,
    DefaultFarmerAddress? address,
  }) {
    final selectedAddressProvider = Provider.of<SelectedAddressProvider>(
      context,
      listen: false,
    );

    if (isEdit && address != null) {
      selectedAddressProvider.setAddress(address);
    } else {
      selectedAddressProvider.clear();
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddAddressScreen()),
    ).then((result) async {
      if (result is DefaultFarmerAddress) {
        if (isEdit) {
          await _updateAddress(result);
        } else {
          await _addNewAddress(result);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Select Address'),

      floatingActionButton:
          _addresses.isNotEmpty
              ? FloatingActionButton(
                onPressed: () => _navigateToAddAddress(isEdit: false),
                child: Icon(Icons.add),
              )
              : null,

      backgroundColor: themeColor(context: context).surface,
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Consumer<AddressProvider>(
                builder: (context, provider, _) {
                  final addresses = provider.addresses;

                  if (addresses.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_off,
                            size: 40.sp,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10.h),
                          bodyMediumText(
                            "No addresses found",
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10.h),
                          ElevatedButton.icon(
                            onPressed:
                                () => _navigateToAddAddress(isEdit: false),
                            icon: Icon(Icons.add, size: 24.sp),
                            label: const Text("Add an Address"),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: addresses.length,
                            itemBuilder: (context, index) {
                              final address = addresses[index];
                              final isDefault = address.isDefault;

                              return Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                  side: BorderSide(
                                    color:
                                        isDefault
                                            ? themeColor(
                                              context: context,
                                            ).primary
                                            : themeColor(
                                              context: context,
                                            ).secondaryContainer,
                                    width: 2,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () => _setDefaultAddress(address),
                                  borderRadius: BorderRadius.circular(15.r),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.h,
                                      horizontal: 16.w,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              bodyMediumBoldText(address.name),
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
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (isDefault)
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  right: 8.w,
                                                ),
                                                child: Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                  size: 24.sp,
                                                ),
                                              ),
                                            PopupMenuButton<String>(
                                              onSelected: (value) {
                                                if (value == 'edit') {
                                                  _navigateToAddAddress(
                                                    isEdit: true,
                                                    address: address,
                                                  );
                                                } else if (value == 'delete') {
                                                  _deleteAddress(address.name);
                                                }
                                              },
                                              itemBuilder:
                                                  (context) => const [
                                                    PopupMenuItem(
                                                      value: 'edit',
                                                      child: Text('Edit'),
                                                    ),
                                                    PopupMenuItem(
                                                      value: 'delete',
                                                      child: Text('Delete'),
                                                    ),
                                                  ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
