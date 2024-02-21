
import 'package:film/screens/authscreens/loginscreen.dart';
import 'package:film/utils/api_helper.dart';
import 'package:film/utils/string_formatter_and_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/common.dart';
import '../../network/api_provider.dart';
import '../../network/apis.dart';
import '../../widgets/app_dialogs.dart';
import '../../widgets/app_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  ApiProvider apiProvider = ApiProvider();
  final TextFieldControl _email = TextFieldControl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [secondaryColor, primaryColor],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.white),
        title: const Text(
          "Forgot password",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter email address",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              AppTextBox(
                textFieldControl: _email,
                prefixIcon: Icon(Icons.email_outlined),
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: SizedBox(
                  height: 50,
                  width: 100,
                  child: ElevatedButton(
                    style:
                    ElevatedButton.styleFrom(primary: Colors.cyan),
                    child: Text("Submit"),
                    onPressed: () => _validate(context),
                  ),
                ),
              )
            ]),
      ),
    );
  }

  FormatAndValidate formatAndValidate = FormatAndValidate();

  _validate(BuildContext context) async {
    var email = _email.controller.text;

    if (formatAndValidate.validateEmailID(email) != null) {
      return toastMessage(formatAndValidate.validateEmailID(email));
    }
    CommonResponse response = await forgotPassword();
    return showAlert(context,response.message!);
  }

  Future<CommonResponse> forgotPassword() async {
    AppDialogs.loading();
    final response = await apiProvider.getJsonInstance().post(
        '${Apis.userforgotpassword}',
        data: {"email": _email.controller.text});
    Get.back();
    return CommonResponse.fromJson(response.data);
  }

  void showAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("${message}"),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: primaryColor, // Background color
                onPrimary: Colors.white, // Text color
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Button border radius
                ),
              ),
              onPressed: () {
                Get.to(LoginScreen());
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }
}
