import 'package:agri_flutter/providers/drawer/address.dart';
import 'package:agri_flutter/providers/drawer/selected_address.dart';
import 'package:agri_flutter/models/post_sign_up/default_farmer_address.dart';
import 'package:agri_flutter/services/firestore.dart';
import 'package:agri_flutter/presentation/drawer/add_address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectAddressScreen extends StatefulWidget {
  const SelectAddressScreen({Key? key}) : super(key: key);

  @override
  State<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  final FirestoreService _firestor = FirestoreService();

  @override
  void initState() {
    super.initState();

    final addressProvider = Provider.of<AddressProvider>(
      context,
      listen: false,
    );
    addressProvider.loadAddresses();
  }

  // Helper function to add a new address
  Future<void> _addNewAddress(DefaultFarmerAddress farm) async {
    try {
      await _firestor.addNewAddress(farm);
      print("✅ New address added");
      Provider.of<AddressProvider>(
        context,
        listen: false,
      ).loadAddresses(); // Refresh addresses
    } catch (e) {
      print("❌ Error adding address: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error adding address: $e")));
    }
  }

  // Helper function to update an address
  Future<void> _updateAddress(DefaultFarmerAddress farm) async {
    try {
      await _firestor.updateAddress(farm);
      print("✅ Address updated");
      Provider.of<AddressProvider>(
        context,
        listen: false,
      ).loadAddresses(); // Refresh addresses
    } catch (e) {
      print("❌ Error updating address: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error updating address: $e")));
    }
  }

  // Helper function to delete an address
  Future<void> _deleteAddress(String addressName) async {
    try {
      await _firestor.deleteAddress(addressName);
      print("🗑️ Address deleted");
      Provider.of<AddressProvider>(
        context,
        listen: false,
      ).loadAddresses(); // Refresh addresses
    } catch (e) {
      print("❌ Error deleting address: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error deleting address: $e")));
    }
  }

  // Helper function to set default address
  Future<void> _addDefaultLocation(DefaultFarmerAddress farm) async {
    try {
      await _firestor.addDefaultLocation(farm);
      print("✅ Default address saved.");
      Provider.of<AddressProvider>(
        context,
        listen: false,
      ).loadAddresses(); // Refresh addresses
    } catch (e) {
      print("❌ Failed to save default address: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving default address: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(
      context,
      listen: false,
    );
    final selectedProvider = Provider.of<SelectedAddressProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Select Address')),
      body: FutureBuilder(
        future: addressProvider.loadAddresses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Consumer<AddressProvider>(
            builder: (_, provider, __) {
              if (provider.addresses.isEmpty) {
                return const Center(child: Text("No address found."));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: provider.addresses.length,
                itemBuilder: (context, index) {
                  final address = provider.addresses[index];
                  final isSelected =
                      selectedProvider.selected?.name == address.name;

                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Icon(
                        isSelected ? Icons.check_circle : Icons.location_on,
                        color: isSelected ? Colors.green : Colors.grey,
                      ),
                      title: Text(
                        address.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        '${address.address2}, ${address.landmark}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteAddress(address.name);
                        },
                      ),
                      onTap: () {
                        selectedProvider.setAddress(address);
                        // Show dialog for update
                        showDialog(
                          context: context,
                          builder: (context) {
                            final nameController = TextEditingController(
                              text: address.name,
                            );
                            final address1Controller = TextEditingController(
                              text: address.address1,
                            );
                            final address2Controller = TextEditingController(
                              text: address.address2,
                            );
                            final landmarkController = TextEditingController(
                              text: address.landmark,
                            );
                            final contactNumberController =
                                TextEditingController(
                                  text: address.contactNumber.toString(),
                                );
                            return AlertDialog(
                              title: const Text("Update Address"),
                              content: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: nameController,
                                      decoration: const InputDecoration(
                                        labelText: "Name",
                                      ),
                                    ),
                                    TextField(
                                      controller: address1Controller,
                                      decoration: const InputDecoration(
                                        labelText: "Address Line 1",
                                      ),
                                    ),
                                    TextField(
                                      controller: address2Controller,
                                      decoration: const InputDecoration(
                                        labelText: "Address Line 2",
                                      ),
                                    ),
                                    TextField(
                                      controller: landmarkController,
                                      decoration: const InputDecoration(
                                        labelText: "Landmark",
                                      ),
                                    ),
                                    TextField(
                                      controller: contactNumberController,
                                      decoration: const InputDecoration(
                                        labelText: "Contact Number",
                                      ),
                                      keyboardType: TextInputType.phone,
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    final updatedAddress = DefaultFarmerAddress(
                                      name: nameController.text,
                                      address1: address1Controller.text,
                                      address2: address2Controller.text,
                                      landmark: landmarkController.text,
                                      contactNumber: int.parse(
                                        contactNumberController.text,
                                      ),
                                      isDefault:
                                          address
                                              .isDefault, // Preserve isDefault
                                    );
                                    _updateAddress(updatedAddress);
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Save"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    final updatedAddress = DefaultFarmerAddress(
                                      name: nameController.text,
                                      address1: address1Controller.text,
                                      address2: address2Controller.text,
                                      landmark: landmarkController.text,
                                      contactNumber: int.parse(
                                        contactNumberController.text,
                                      ),
                                      isDefault: true, // Set as default
                                    );
                                    _addDefaultLocation(updatedAddress);
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Set as Default"),
                                ),
                              ],
                            );
                          },
                        );
                        // Close drawer if open, else pop current screen
                        if (Scaffold.of(context).isDrawerOpen) {
                          Navigator.pop(context); // closes drawer
                        } else {
                          Navigator.pop(context); // closes screen
                        }
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddAddressScreen()),
          ).then((newAddress) {
            if (newAddress != null && newAddress is DefaultFarmerAddress) {
              _addNewAddress(newAddress);
            }
          });
        },
        label: const Text("Add Address"),
        icon: const Icon(Icons.add_location_alt),
      ),
    );
  }
}
