import 'package:agri_flutter/presentation/drawer/address_scrren.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../customs_widgets/custom_app_bar.dart';
import '../../customs_widgets/custom_button.dart';
import '../../customs_widgets/custom_snackbar.dart';
import '../../providers/market_place_provider/cart_provider.dart';
import '../../theme/theme.dart';
import '../../providers/drawer/address.dart';
import '../../models/post_sign_up/default_farmer_address.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDefaultAddress();
  }

  Future<void> _loadDefaultAddress() async {
    setState(() => _isLoading = true);
    final addressProvider = Provider.of<AddressProvider>(
      context,
      listen: false,
    );
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await addressProvider.loadAddresses(); // Fetch addresses from Firestore
      final addresses = addressProvider.addresses;

      // Find default address or first available address, handle null explicitly
      final DefaultFarmerAddress? selectedAddress =
          addresses.isNotEmpty
              ? (addresses.firstWhere(
                (addr) => addr.isDefault,
                orElse:
                    () => addresses.first, // Return first address if no default
              ))
              : null;

      if (selectedAddress != null) {
        // Format address as a single string
        String formattedAddress =
            '${selectedAddress.address1}, ${selectedAddress.address2}, ${selectedAddress.landmark}';
        _addressController.text = formattedAddress;
      }
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: themeColor().surface,
      appBar: CustomAppBar(title: 'Checkout'),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order Summary",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartProvider.cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartProvider.cartItems[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(item.name),
                            subtitle: Text("Quantity: ${item.quantity}"),
                            trailing: Text("₹${item.price * item.quantity}"),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Delivery Address",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const SelectAddressScreen(),
                              ),
                            ).then((_) => _loadDefaultAddress());
                          },
                          child: const Text("Change Address"),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: _addressController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Enter your delivery address",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "₹${cartProvider.totalCartPrice.toDouble()}",
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ],
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: CustomButton(
                            buttonName: 'Confirm Order',
                            onClick: () {
                              final address = _addressController.text.trim();
                              if (address.isEmpty) {
                                showCustomSnackBar(
                                  context,
                                  "Please enter address",
                                );
                                return;
                              }
                              showCustomSnackBar(
                                context,
                                "Order placed successfully!",
                              );
                              cartProvider.clearCart();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }
}
