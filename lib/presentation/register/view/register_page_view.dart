import 'package:book/presentation/common/custom_text_form.dart';
import 'package:book/models/app_user.dart';
import 'package:book/presentation/common/book_app_bar.dart';
import 'package:book/presentation/login/bloc/bloc_login.dart';
import 'package:book/presentation/login/bloc/login_event.dart';
import 'package:book/presentation/login/bloc/login_state.dart';
import 'package:book/styles/app_colors.dart';
import 'package:book/validation/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocConsumer<LoginBloc, LoginState>(
        builder: (BuildContext context, Object? state) {
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
    }, listener: (context, state) async {
      if (state is SuccessfulSignUp) {
        Navigator.pop(context);
        final successfulSignUpSnackBar = SnackBar(
          content: Text(
            AppLocalizations.of(context)!.successful_registration,
            textAlign: TextAlign.center,
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(successfulSignUpSnackBar);
      } else if (state is ErrorState) {
        final errorSnackbar = SnackBar(
          content: Text(
            AppLocalizations.of(context)!.error,
            textAlign: TextAlign.center,
          ),
        );
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(errorSnackbar);
      } else if (state is ErrorAuthState) {
        final errorAuthSnackBar = SnackBar(
            content: Text(
          AppLocalizations.of(context)!.error_auth,
          textAlign: TextAlign.center,
        ));
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(errorAuthSnackBar);
      }
    });
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
        CustomTextForm(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.empty_name;
              }
              name = value;
              return null;
            },
            labelText: AppLocalizations.of(context)!.name,
            keyboardType: TextInputType.text,
            isNonPasswordField: true,
            maxLenght: 20),
        SizedBox(
          height: 15,
        ),
        CustomTextForm(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.empty_last_name;
              }
              lastName = value;
              return null;
            },
            labelText: AppLocalizations.of(context)!.last_name,
            keyboardType: TextInputType.text,
            isNonPasswordField: true,
            maxLenght: 20),
        SizedBox(
          height: 15,
        ),
        CustomTextForm(
            validator: (value) {
              final isValid = ValidationUtils.validateEmailAddress(value!);
              if (value.isNotEmpty && isValid == true) {
                email = value;
                return null;
              } else if (value.isNotEmpty && isValid == false) {
                return AppLocalizations.of(context)!.invalid_email;
              } else {
                return AppLocalizations.of(context)!.empty_email;
              }
            },
            labelText: AppLocalizations.of(context)!.email,
            keyboardType: TextInputType.text,
            isNonPasswordField: true,
            maxLenght: 20),
        SizedBox(
          height: 15,
        ),
        CustomTextForm(
            validator: (value) {
              final isValid =
                  ValidationUtils.passwordValidator(context, value, 8);

              if (value!.isNotEmpty && isValid == null) {
                password = value;
                return null;
              } else if (value.isNotEmpty && isValid != null) {
                return isValid;
              } else {
                return isValid;
              }
            },
            labelText: AppLocalizations.of(context)!.password,
            keyboardType: TextInputType.text,
            isNonPasswordField: false,
            maxLenght: 16),
        SizedBox(
          height: 15,
        ),
        CustomTextForm(
            validator: (value) {
              if (value!.isNotEmpty && value == password) {
                confirmPassword = value;
                return null;
              } else if (value.isNotEmpty && confirmPassword != password) {
                return AppLocalizations.of(context)!.passwords_doesnt_match;
              } else {
                return AppLocalizations.of(context)!.confirm_password_validate;
              }
            },
            labelText: AppLocalizations.of(context)!.confirm_password,
            keyboardType: TextInputType.text,
            isNonPasswordField: false,
            maxLenght: 16)
      ],
    );
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

  void onSignUpPressed() {
    if (_formKey.currentState!.validate()) {
      AppUser appUser = AppUser(
          name: name!, lastName: lastName!, email: email!, password: password!);
      context.read<LoginBloc>().add(SignUp(appUser: appUser));
    }
  }
}
