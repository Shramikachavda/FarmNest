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

class SelectAddressScreen extends StatelessWidget {
  const SelectAddressScreen({Key? key}) : super(key: key);

  void _navigateToAddAddress(
    BuildContext context, {
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
        final provider = Provider.of<AddressProvider>(context, listen: false);
        if (isEdit) {
          await provider.updateAddress(result);
        } else {
          await provider.addAddress(result);
        }
      }
    });
  }

  Future<void> _setDefaultAddress(
    BuildContext context,
    DefaultFarmerAddress address,
  ) async {
    final addressProvider = Provider.of<AddressProvider>(
      context,
      listen: false,
    );
    final selectedAddressProvider = Provider.of<SelectedAddressProvider>(
      context,
      listen: false,
    );

    if (!address.isDefault) {
      await addressProvider.setDefaultIfNotAlready(address);
      selectedAddressProvider.setAddress(address);
    }
  }

  Future<void> _deleteAddress(
    BuildContext context,
    DefaultFarmerAddress address,
  ) async {
    final addressProvider = Provider.of<AddressProvider>(
      context,
      listen: false,
    );
    final selectedAddressProvider = Provider.of<SelectedAddressProvider>(
      context,
      listen: false,
    );

    if (selectedAddressProvider.selected?.name == address.name) {
      selectedAddressProvider.clear();
    }

    await addressProvider.deleteAddress(address.name);

    if (addressProvider.addresses.isNotEmpty &&
        !addressProvider.addresses.any((a) => a.isDefault)) {
      final newDefault = addressProvider.addresses.first;
      await addressProvider.setDefaultIfNotAlready(newDefault);
      selectedAddressProvider.setAddress(newDefault);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Select Address'),
      floatingActionButton: Consumer<AddressProvider>(
        builder: (context, provider, _) {
          if (provider.addresses.isEmpty) return SizedBox.shrink();

          return FloatingActionButton(
            onPressed: () => _navigateToAddAddress(context, isEdit: false),
            child: const Icon(Icons.add),
          );
        },
      ),

      backgroundColor: themeColor(context: context).surface,
      body: Consumer<AddressProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final addresses = provider.addresses;

          if (addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off, size: 40.sp, color: Colors.grey),
                  SizedBox(height: 10.h),
                  bodyMediumText("No addresses found", color: Colors.grey),
                  SizedBox(height: 10.h),
                  ElevatedButton.icon(
                    onPressed:
                        () => _navigateToAddAddress(context, isEdit: false),
                    icon: Icon(Icons.add, size: 20.sp),
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
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            child: Column(
              children: [
                //ADDRESS
                Expanded(
                  child: ListView.builder(
                    itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      final isDefault = address.isDefault;

                      return Column(
                        children: [
                          InkWell(
                            onTap: () => _setDefaultAddress(context, address),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                side: BorderSide(
                                  color:
                                      isDefault
                                          ? themeColor(context: context).primary
                                          : themeColor(
                                            context: context,
                                          ).secondaryContainer,
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12 , horizontal: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    if (isDefault)
                                      Container(


                                      //  color: Colors.pinkAccent,
                                        height: 24.h,
                                        width: 20.w,
                                        child: Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 20.sp,
                                        ),
                                      ),
                                    Container(
                                     //color: Colors.green,
                                      height: 40.h,
                                      width: 20.w,

                                      child: PopupMenuButton<String>(
                                        onSelected: (value) {
                                          if (value == 'edit') {
                                            _navigateToAddAddress(
                                              context,
                                              isEdit: true,
                                              address: address,
                                            );
                                          } else if (value == 'delete') {
                                            _deleteAddress(context, address);
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
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 24.h),
                        ],
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
