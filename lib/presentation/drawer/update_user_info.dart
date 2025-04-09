import 'package:agri_flutter/core/widgets/BaseStateFullWidget.dart';
import 'package:agri_flutter/customs_widgets/custom_app_bar.dart';
import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:agri_flutter/customs_widgets/custom_snackbar.dart';
import 'package:agri_flutter/models/user_data.dart';
import 'package:agri_flutter/services/firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../customs_widgets/reusable.dart';

class EditProfileScreen extends BaseStatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();

  @override
  Route buildRoute() {
    return materialRoute();
  }

  static const String route = "/EditProfileScreen";
  @override
  String get routeName => route;
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();
  final FirestoreService _firestoreService = FirestoreService();

  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();

  @override
  void initState() {
    final userProvider = context.read<UserProvider>();
    _nameController = TextEditingController(text: userProvider.userName);
    _emailController = TextEditingController(text: userProvider.userEmail);
    super.initState();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      showLoadingDialog(context);
      await _firestoreService.updateUser(
        UserModelDb(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          id: _firestoreService.userId,
        ),
      );

      context.read<UserProvider>().setUserNameEmail(
        _nameController.text.trim(),
        _emailController.text.trim(),
      );

      Navigator.of(context).pop();

      showCustomSnackBar(context, "Profile updated successfully");

      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      showCustomSnackBar(context, "Failed to update profile");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar( title: "Edit Profile") , 
 
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 24.h),
              CustomFormField(
                hintText: 'Name',
                keyboardType: TextInputType.name,
                label: 'Name',
                textEditingController: _nameController,
                focusNode: _focusNodeName,
                textInputAction: TextInputAction.next,
                validator:
                    (val) => val == null || val.isEmpty ? 'Enter name' : null,
              ),
              SizedBox(height: 24.h),
              CustomFormField(
                hintText: 'Email',
                keyboardType: TextInputType.name,
                label: 'Email',
                textEditingController: _emailController,
                focusNode: _focusNodeEmail,
                textInputAction: TextInputAction.next,
                validator:
                    (val) => val == null || val.isEmpty ? 'Enter email' : null,
              ),
              SizedBox(height: 24.h),
              CustomButton(onClick: _saveProfile, buttonName: "Save"),
            ],
          ),
        ),
      ),
    );
  }
}
