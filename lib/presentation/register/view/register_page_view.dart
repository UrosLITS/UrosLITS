import 'package:book/models/app_user.dart';
import 'package:book/styles/app_colors.dart';
import 'package:book/styles/app_styles.dart';
import 'package:book/validation/validation_form.dart';
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
  late String message;
  bool passwordVisible = false;
  bool confPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(200),
              child: AppBar(
                  automaticallyImplyLeading: false,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(60))),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(150),
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.brown.withOpacity(0),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.elliptical(60, 60),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.welcome,
                                style: TextStyle(
                                    fontSize: 30, color: AppColors.black),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                AppLocalizations.of(context)!.sign_in,
                                style: TextStyle(
                                    fontSize: 15, color: AppColors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  title: Text(AppLocalizations.of(context)!.register,
                      style: AppTextStyles.titleLogin()),
                  centerTitle: true,
                  toolbarHeight: 75,
                  backgroundColor: AppColors.brown.withOpacity(0.8),
                  elevation: 0,
                  leading: IconButton(
                      onPressed: () {
                        Navigator.maybePop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios))),
            ),
            body: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: buildBody(),
            )),
        onWillPop: () => onBackPressed(context));
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
                inputForm(),
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

  Widget inputForm() {
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
              setState(() {});
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.empty_name;
              }
              name = value;
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
              lastName = value;
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
              final isValid = validateEmailAddress(value!);
              if (value.isNotEmpty && isValid == true) {
                email = value;
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
              setState(() {});
            },
            validator: (value) {
              final isValid = passwordValidator(value);

              if (value!.isNotEmpty && isValid == null) {
                password = value;
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
              setState(() {});
            },
            validator: (value) {
              if (value!.isNotEmpty && value == password) {
                confirmPassword = value;
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
