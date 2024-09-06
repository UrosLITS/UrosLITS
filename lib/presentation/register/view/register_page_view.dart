import 'package:book/core/constants.dart';
import 'package:book/models/app_user.dart';
import 'package:book/presentation/common/book_app_bar.dart';
import 'package:book/presentation/common/custom_dialog.dart';
import 'package:book/presentation/common/custom_snackbar.dart';
import 'package:book/presentation/common/custom_text_form.dart';
import 'package:book/presentation/common/dialog_utils.dart';
import 'package:book/presentation/login/bloc/login_bloc.dart';
import 'package:book/presentation/login/bloc/login_event.dart';
import 'package:book/presentation/login/bloc/login_state.dart';
import 'package:book/styles/app_colors.dart';
import 'package:book/validation/validation.dart';
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
  bool _visibleText = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state is LoadingState) {
          DialogUtils.showLoadingScreen(context);
        }
        if (state is LoadedState) {
          Navigator.pop(context);
        }
        if (state is SuccessfulSignUp) {
          Navigator.pop(context);
          CustomSnackBar.showSnackBar(
              color: Colors.green,
              content: AppLocalizations.of(context)!.successful_registration,
              context: context);
        } else if (state is ErrorState) {
          CustomSnackBar.showSnackBar(
              color: Colors.red,
              content: AppLocalizations.of(context)!.error,
              context: context);
        } else if (state is ErrorAuthState) {
          CustomSnackBar.showSnackBar(
              color: Colors.red,
              content: AppLocalizations.of(context)!.error_auth,
              context: context);
        }
      },
      builder: (BuildContext context, Object? state) {
        return WillPopScope(
          onWillPop: () => onBackPressed(context),
          child: Scaffold(
              appBar: AppBarLogReg(
                titleText: AppLocalizations.of(context)!.register,
                leading: IconButton(
                  onPressed: () {
                    Navigator.maybePop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ),
              ),
              body: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: buildBody(),
              )),
        );
      },
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
        CustomTextForm(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.empty_name;
            }
            return null;
          },
          labelText: AppLocalizations.of(context)!.name,
          keyboardType: TextInputType.text,
          maxLength: nameMaxLength,
          onChanged: (value) {
            name = value;
          },
        ),
        SizedBox(
          height: 15,
        ),
        CustomTextForm(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.empty_last_name;
            }
            return null;
          },
          labelText: AppLocalizations.of(context)!.last_name,
          keyboardType: TextInputType.text,
          maxLength: nameMaxLength,
          onChanged: (value) {
            lastName = value;
          },
        ),
        SizedBox(
          height: 15,
        ),
        CustomTextForm(
          validator: (value) {
            final isValid = ValidationUtils.validateEmailAddress(value!);
            if (value.isNotEmpty && isValid == true) {
              return null;
            } else if (value.isNotEmpty && isValid == false) {
              return AppLocalizations.of(context)!.invalid_email;
            } else {
              return AppLocalizations.of(context)!.empty_email;
            }
          },
          labelText: AppLocalizations.of(context)!.email,
          keyboardType: TextInputType.text,
          maxLength: emailMaxLength,
          onChanged: (value) {
            email = value;
          },
        ),
        SizedBox(
          height: 15,
        ),
        CustomTextForm(
          validator: (value) {
            final isValid =
                ValidationUtils.passwordValidator(context, value, 8);

            if (value!.isNotEmpty && isValid == null) {
              return null;
            } else if (value.isNotEmpty && isValid != null) {
              return isValid;
            } else {
              return isValid;
            }
          },
          labelText: AppLocalizations.of(context)!.password,
          keyboardType: TextInputType.text,
          isPasswordField: true,
          suffixIcon: IconButton(
              onPressed: () {
                toggleObscureText();
              },
              icon: !_visibleText
                  ? Icon(Icons.visibility)
                  : Icon(Icons.visibility_off)),
          maxLength: maxPasswordLength,
          obscureText: !_visibleText,
          onChanged: (value) {
            password = value;
          },
        ),
        SizedBox(
          height: 15,
        ),
        CustomTextForm(
          validator: (value) {
            if (value!.isNotEmpty && value == password) {
              return null;
            } else if (value.isNotEmpty && confirmPassword != password) {
              return AppLocalizations.of(context)!.passwords_doesnt_match;
            } else {
              return AppLocalizations.of(context)!.confirm_password_validate;
            }
          },
          labelText: AppLocalizations.of(context)!.confirm_password,
          keyboardType: TextInputType.text,
          isPasswordField: true,
          suffixIcon: IconButton(
              onPressed: () {
                toggleObscureText();
              },
              icon: !_visibleText
                  ? Icon(Icons.visibility)
                  : Icon(Icons.visibility_off)),
          maxLength: maxPasswordLength,
          obscureText: !_visibleText,
          onChanged: (value) {
            confirmPassword = value;
          },
        )
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
          return CustomDialog(
              content: AppLocalizations.of(context)!.discard_changes);
        },
      );
      return result;
    }
    return true;
  }

  void toggleObscureText() {
    setState(() {
      _visibleText = !_visibleText;
    });
  }

  void onSignUpPressed() {
    if (_formKey.currentState!.validate()) {
      AppUser appUser = AppUser(
          name: name!, lastName: lastName!, email: email!, password: password!);
      context.read<LoginBloc>().add(SignUp(appUser: appUser));
    }
  }
}
