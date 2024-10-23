import 'package:book/core/constants.dart';
import 'package:book/models/app_user.dart';
import 'package:book/presentation/common/custom_dialog.dart';
import 'package:book/presentation/common/custom_snackbar.dart';
import 'package:book/presentation/common/custom_text_form.dart';
import 'package:book/presentation/common/dialog_utils.dart';
import 'package:book/presentation/login/bloc/login_bloc.dart';
import 'package:book/presentation/login/bloc/login_event.dart';
import 'package:book/presentation/login/bloc/login_state.dart';
import 'package:book/styles/app_colors.dart';
import 'package:book/validation/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateProviderAccount extends StatefulWidget {
  CreateProviderAccount({required this.userCredential});

  @override
  State<CreateProviderAccount> createState() => _SetPasswordPage();

  final UserCredential userCredential;
}

class _SetPasswordPage extends State<CreateProviderAccount> {
  late String? password;
  late String? confirmPassword;
  late String? lastName;
  late String? name;
  bool _visibleText = false;

  @override
  void initState() {
    name = widget.userCredential.user!.displayName!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
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
      } else if (state is LoadingState) {
        DialogUtils.showLoadingScreen(context);
      } else if (state is LoadedState) {
        Navigator.pop(context);
      }
    }, builder: (BuildContext context, Object? state) {
      return WillPopScope(
        onWillPop: () => onBackPressed(context),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.maybePop(context);
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
            title: Text(AppLocalizations.of(context)!.create_account_title),
          ),
          body: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                CustomTextForm(
                  initialValue: widget.userCredential.user?.displayName,
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
                  height: 20,
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
                  height: 20,
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
                  height: 20,
                ),
                CustomTextForm(
                  validator: (value) {
                    if (value!.isNotEmpty && value == password) {
                      return null;
                    } else if (value.isNotEmpty &&
                        confirmPassword != password) {
                      return AppLocalizations.of(context)!
                          .passwords_doesnt_match;
                    } else {
                      return AppLocalizations.of(context)!
                          .confirm_password_validate;
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
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brown.withOpacity(0.8)),
                  onPressed: () async {
                    AppUser appUser = AppUser(
                        name: name!,
                        lastName: lastName!,
                        email: widget.userCredential.additionalUserInfo
                            ?.profile!['email'],
                        password: password!);
                    context
                        .read<LoginBloc>()
                        .add(SignUpWithProvider(appUser: appUser));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.save,
                        style: TextStyle(color: AppColors.white),
                      ),
                      Icon(
                        Icons.edit,
                        color: Colors.yellow,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  bool get hasChanges =>
      name != null ||
      lastName != null ||
      password != null ||
      confirmPassword != null;

  Future<bool> onBackPressed(BuildContext context) async {
    if (hasChanges) {
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
}
