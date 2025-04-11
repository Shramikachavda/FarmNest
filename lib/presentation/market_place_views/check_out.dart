import 'package:agri_flutter/core/widgets/BaseStateFullWidget.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/presentation/drawer/order_screen.dart';
import 'package:agri_flutter/utils/comman.dart';
import 'package:agri_flutter/utils/navigation/navigation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../customs_widgets/custom_app_bar.dart';
import '../../customs_widgets/custom_button.dart';
import '../../customs_widgets/custom_form_field.dart';
import '../../customs_widgets/custom_snackbar.dart';
import '../../providers/market_place_provider/cart_provider.dart';
import '../../theme/theme.dart';
import '../../providers/drawer/address_provider.dart';
import '../../providers/drawer/selected_address.dart';
import '../../models/post_sign_up/default_farmer_address.dart';
import '../drawer/selected_address.dart' show SelectAddressScreen;

class CheckoutView extends BaseStatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();

  @override
  Route buildRoute() {
    return materialRoute();
  }

  static const String route = "/CheckoutView";

  @override
  String get routeName => route;
}

class _CheckoutViewState extends State<CheckoutView> {
  final TextEditingController _addressController = TextEditingController();
  final FocusNode _focusNodeAddress = FocusNode();
  bool _isLoading = true; // Track loading state
  bool _isAddressLoaded = false; // Prevent multiple initial loads

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isAddressLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadDefaultAddress();
      });
      _isAddressLoaded = true;
    }
  }

  Future<void> _loadDefaultAddress() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final selectedAddressProvider =
      Provider.of<SelectedAddressProvider>(context, listen: false);
      final selectedAddress = selectedAddressProvider.selected;

      if (selectedAddress != null) {
        String formattedAddress =
            '${selectedAddress.address1}, ${selectedAddress.address2}'
            '${selectedAddress.landmark.isNotEmpty ? ', ${selectedAddress.landmark}' : ''}';
        _addressController.text = formattedAddress.trim();
      } else {
        _addressController.text = '';
      }
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showCustomSnackBar(context, "Failed to load address: $e");
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final selectedAddressProvider = Provider.of<SelectedAddressProvider>(context);

    return Scaffold(
      backgroundColor: themeColor().surface,
      appBar: CustomAppBar(title: 'Checkout'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            bodyMediumBoldText("Order Summary"),
            // Order list
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: cartProvider.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartProvider.cartItems[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: bodyText(item.name),
                    subtitle: smallText("Quantity: ${item.quantity}"),
                    trailing: smallText("₹${item.price * item.quantity}"),
                  );
                },
              ),
            ),
            // Delivery address section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                bodyMediumText("Delivery Address"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SelectAddressScreen(),
                      ),
                    ).then((_) {
                      _loadDefaultAddress(); // Refresh address on return
                    });
                  },
                  child: const Text("Change Address"),
                ),
              ],
            ),
            // Address field
            CustomFormField(
              maxLine: 3,
              readOnly: true,
              focusNode: _focusNodeAddress,
              keyboardType: TextInputType.streetAddress,
              hintText: 'Select your delivery address...',
              label: 'Delivery address',
              textEditingController: _addressController,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please select an address";
                }
                return null;
              },
            ),
            // Total and order button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bodyText("Total"),
                    bodyText("₹${cartProvider.totalCartPrice.toDouble()}"),
                  ],
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: CustomButton(
                    buttonName: 'Confirm Order',
                    onClick: () {
                      final address = _addressController.text.trim();
                      if (address.isEmpty) {
                        showCustomSnackBar(
                            context, "Please select an address");
                        return;
                      }
                      showCustomSnackBar(
                          context, "Order placed successfully!");
                      cartProvider.clearCart();
                      selectedAddressProvider.clear(); // Reset address after order
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ].separator(SizedBox(height: 10.h)).toList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    _focusNodeAddress.dispose();
    super.dispose();
  }
}