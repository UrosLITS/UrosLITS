import 'package:book/app_routes/app_routes.dart';
import 'package:book/core/constants.dart';
import 'package:book/presentation/common/custom_loading_screen.dart';
import 'package:book/presentation/common/custom_text_form.dart';
import 'package:book/models/app_user_singleton.dart';
import 'package:book/presentation/book/view/home_page_view.dart';
import 'package:book/presentation/common/book_app_bar.dart';
import 'package:book/presentation/common/custom_snackbar.dart';
import 'package:book/presentation/login/bloc/bloc_login.dart';
import 'package:book/presentation/login/bloc/login_event.dart';
import 'package:book/presentation/login/bloc/login_state.dart';
import 'package:book/styles/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;
  String? password;
  bool passwordVisible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state is LoadingState) {
          CustomLoadingScreen.showLoadingScreen(context);
        }
        if (state is SuccessfulLogin) {
          Navigator.pushReplacementNamed(context, registerRoute);
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
        return Scaffold(
          appBar: AppBarLogReg(
            titleText: AppLocalizations.of(context)!.login,
          ),
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: buildBody(),
          ),
        );
      },
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.welcome,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                AppLocalizations.of(context)!.login_to_continue,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 20,
              ),
              inputForm(),
              SizedBox(
                height: 40,
              ),
              Center(
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: SizedBox.expand(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brown.withOpacity(0.8),
                        ),
                        onPressed: () {
                          onLoginPressed();
                        },
                        child: Text(
                          AppLocalizations.of(context)!.login_btn,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.new_user,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, registerRoute);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.sign_up,
                      style: TextStyle(color: AppColors.red),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget inputForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          CustomTextForm(
            validator: (value) {
              if (value!.isNotEmpty) {
                email = value;
                return null;
              } else {
                return AppLocalizations.of(context)!.empty_email;
              }
            },
            labelText: AppLocalizations.of(context)!.email,
            isNonPasswordField: true,
            keyboardType: TextInputType.text,
            maxLength: emailMaxLength,
          ),
          SizedBox(
            height: 30,
          ),
          CustomTextForm(
            validator: (value) {
              if (value!.isNotEmpty) {
                password = value;
                return null;
              } else {
                return AppLocalizations.of(context)!.empty_password;
              }
            },
            labelText: AppLocalizations.of(context)!.password,
            keyboardType: TextInputType.text,
            isNonPasswordField: false,
            maxLength: maxPasswordLength,
          )
        ],
      ),
    );
  }

  void onLoginPressed() async {
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(Login(email: email!, password: password!));
    }
  }
}
