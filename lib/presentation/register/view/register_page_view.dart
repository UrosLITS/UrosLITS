import 'package:book/presentation/common/book_app_bar.dart';
import 'package:book/styles/app_colors.dart';
import 'package:book/validation/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterPageView extends StatefulWidget {
  const RegisterPageView({super.key});

  @override
  State<RegisterPageView> createState() => _RegisterPageView();
}

class _RegisterPageView extends State<RegisterPageView> {
  String? name;
  String? lastName;
  String? email;
  String? password;
  String? confirmPassword;
  final _formKey = GlobalKey<FormState>();
  bool passwordVisible = false;
  bool confPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackPressed(context),
      child: Scaffold(
          appBar: AppBarLogReg(
            titleText: AppLocalizations.of(context)!.register,
          ),
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: buildBody(),
          )),
    );
  }

  Widget buildBody() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputForm(),
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: SizedBox.expand(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColors.brown.withOpacity(0.8)),
                            onPressed: () {
                              onSignUpPressed();
                            },
                            child: Text(
                              AppLocalizations.of(context)!.register,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black),
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInputForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        TextFormField(
            enableInteractiveSelection: true,
            keyboardType: TextInputType.text,
            maxLength: 16,
            decoration: InputDecoration(
              counterText: "",
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.black, width: 1)),
              alignLabelWithHint: true,
              labelText: AppLocalizations.of(context)!.name,
              labelStyle: TextStyle(color: AppColors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.grey,
                  width: 1,
                ),
              ),
            ),
            onChanged: (value) {
              name = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.empty_name;
              }
              return null;
            }),
        SizedBox(
          height: 15,
        ),
        TextFormField(
            enableInteractiveSelection: true,
            keyboardType: TextInputType.text,
            maxLength: 16,
            decoration: InputDecoration(
              counterText: "",
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.black, width: 1)),
              alignLabelWithHint: true,
              labelStyle: TextStyle(color: AppColors.black),
              labelText: AppLocalizations.of(context)!.last_name,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.grey,
                  width: 1,
                ),
              ),
            ),
            onChanged: (value) {
              lastName = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.empty_last_name;
              }
              return null;
            }),
        SizedBox(
          height: 15,
        ),
        TextFormField(
            enableInteractiveSelection: true,
            keyboardType: TextInputType.emailAddress,
            maxLength: 30,
            decoration: InputDecoration(
              counterText: "",
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.black, width: 1)),
              alignLabelWithHint: true,
              labelStyle: TextStyle(color: AppColors.black),
              labelText: AppLocalizations.of(context)!.email,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.grey,
                  width: 1,
                ),
              ),
            ),
            onChanged: (value) {
              email = value;
            },
            validator: (value) {
              final isValid = ValidationUtils.validateEmailAddress(value!);
              if (value.isNotEmpty && isValid == true) {
                return null;
              } else if (value.isNotEmpty && isValid == false) {
                return AppLocalizations.of(context)!.invalid_email;
              } else {
                return AppLocalizations.of(context)!.empty_email;
              }
            }),
        SizedBox(
          height: 15,
        ),
        TextFormField(
            enableInteractiveSelection: true,
            obscureText: !passwordVisible,
            keyboardType: TextInputType.text,
            maxLength: 16,
            decoration: InputDecoration(
              counterText: "",
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.black, width: 1)),
              alignLabelWithHint: true,
              labelStyle: TextStyle(color: AppColors.black),
              labelText: AppLocalizations.of(context)!.password,
              suffixIcon: IconButton(
                icon: Icon(
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.black,
                ),
                onPressed: () {
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.grey,
                  width: 1,
                ),
              ),
            ),
            onChanged: (value) {
              password = value;
            },
            validator: (value) {
              final isValid = ValidationUtils.passwordValidator(context, value);

              if (value!.isNotEmpty && isValid == null) {
                return null;
              } else if (value.isNotEmpty && isValid != null) {
                return isValid;
              } else {
                return isValid;
              }
            }),
        SizedBox(
          height: 15,
        ),
        TextFormField(
            enableInteractiveSelection: true,
            obscureText: !confPasswordVisible,
            maxLength: 16,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              counterText: "",
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.black, width: 1)),
              alignLabelWithHint: true,
              labelStyle: TextStyle(color: AppColors.black),
              labelText: AppLocalizations.of(context)!.confirm_password,
              suffixIcon: IconButton(
                icon: Icon(
                  confPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.black,
                ),
                onPressed: () {
                  setState(() {
                    confPasswordVisible = !confPasswordVisible;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.grey,
                  width: 1,
                ),
              ),
            ),
            onChanged: (value) {
              confirmPassword = value;
            },
            validator: (value) {
              if (value!.isNotEmpty && value == password) {
                return null;
              } else if (value.isNotEmpty && confirmPassword != password) {
                return AppLocalizations.of(context)!.passwords_doesnt_match;
              } else {
                return AppLocalizations.of(context)!.confirm_password_validate;
              }
            }),
      ],
    );
  }

  void onSignUpPressed() {
    if (_formKey.currentState!.validate()) {}
  }

  Future<bool> onBackPressed(BuildContext context) async {
    if (name != null ||
        lastName != null ||
        email != null ||
        password != null ||
        confirmPassword != null) {
      final result = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppLocalizations.of(context)!.discard_changes),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text(AppLocalizations.of(context)!.yes),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(AppLocalizations.of(context)!.no),
                    ),
                  ],
                ),
              ],
            );
          });
      return result;
    }
    return true;
  }
}
