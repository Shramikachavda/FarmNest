// presentation/market_place/checkout_view.dart
import 'package:agri_flutter/core/widgets/BaseStateFullWidget.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/presentation/drawer/order_screen.dart';
import 'package:agri_flutter/services/firestore.dart';
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
import '../../presentation/drawer/selected_address.dart';

class CheckoutView extends BaseStatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();

  @override
  Route buildRoute() => materialRoute();

  static const String route = "/CheckoutView";
  @override
  String get routeName => route;
}

class _CheckoutViewState extends State<CheckoutView> {
  final TextEditingController _addressController = TextEditingController();
  final FocusNode _focusNodeAddress = FocusNode();
  bool _isLoading = true;
  bool _isAddressLoaded = false;
  final FirestoreService _firestoreService = FirestoreService();

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
      final selectedAddressProvider = Provider.of<SelectedAddressProvider>(
        context,
        listen: false,
      );
      final addressProvider = Provider.of<AddressProvider>(
        context,
        listen: false,
      );

      await addressProvider.loadAddresses();
      DefaultFarmerAddress? selectedAddress = selectedAddressProvider.selected;

      if (selectedAddress == null ||
          !addressProvider.addresses.any(
            (addr) => addr.name == selectedAddress?.name,
          )) {
        selectedAddress = await addressProvider.getDefaultAddress();
        if (selectedAddress == null && addressProvider.addresses.isNotEmpty) {
          selectedAddress = addressProvider.addresses.first;
          await addressProvider.setDefaultIfNotAlready(selectedAddress);
        }
        if (selectedAddress != null) {
          selectedAddressProvider.setAddress(selectedAddress);
        }
      }

      if (selectedAddress != null) {
        String formattedAddress = [
          selectedAddress.address1,
          selectedAddress.address2,
          if (selectedAddress.landmark.isNotEmpty) selectedAddress.landmark,
        ].where((s) => s.isNotEmpty).join(', ');
        _addressController.text =
            formattedAddress.isEmpty
                ? 'Add your address please to proceed'
                : formattedAddress;
      } else {
        _addressController.text = 'Add your address please to proceed';
      }
    } catch (e) {
      showCustomSnackBar(context, "Failed to load address: $e");
      _addressController.text = 'Error loading address';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _confirmOrder(
    CartProvider cartProvider,
    SelectedAddressProvider selectedAddressProvider,
  ) async {
    final address = _addressController.text.trim();
    if (address.isEmpty || address == 'Add your address please to proceed') {
      showCustomSnackBar(context, "Please select an address");
      return;
    }

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        showCustomSnackBar(context, "User not logged in");
        return;
      }

      if (cartProvider.cartItems.isEmpty) {
        showCustomSnackBar(context, "Cart is empty");
        return;
      }

      setState(() {
        _isLoading = true;
      });

      await _firestoreService.placeOrder(cartProvider.cartItems);

      showCustomSnackBar(context, "Order placed successfully!");

      cartProvider.clearCart();
      selectedAddressProvider.clear();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const OrderScreen()),
        (route) => false,
      );
    } catch (e) {
      showCustomSnackBar(context, "Order failed: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final selectedAddressProvider = Provider.of<SelectedAddressProvider>(
      context,
    );

    return Scaffold(
      backgroundColor: themeColor(context: context).surface,
      appBar: CustomAppBar(title: 'Checkout'),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
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
                      child:
                          cartProvider.cartItems.isEmpty
                              ? const Center(child: Text("Your cart is empty"))
                              : ListView.builder(
                                itemCount: cartProvider.cartItems.length,
                                itemBuilder: (context, index) {
                                  final item = cartProvider.cartItems[index];
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                      item.name,
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                    subtitle: Text(
                                      "Quantity: ${item.quantity}",
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    trailing: Text(
                                      "₹${(item.price * item.quantity).toStringAsFixed(2)}",
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  );
                                },
                              ),
                    ),
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
                          child: Text(
                            _addressController.text ==
                                    'Add your address please to proceed'
                                ? "Add Address"
                                : "Change Address",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
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
                        if (value == null ||
                            value.isEmpty ||
                            value == 'Add your address please to proceed') {
                          return "Please select an address";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total", style: TextStyle(fontSize: 16.sp)),
                            Text(
                              "₹${cartProvider.totalCartPrice.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: CustomButton(
                            buttonName: 'Confirm Order',
                            onClick:
                                () => _confirmOrder(
                                  cartProvider,
                                  selectedAddressProvider,
                                ),
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
    _focusNodeAddress.dispose();
    super.dispose();
  }
}
