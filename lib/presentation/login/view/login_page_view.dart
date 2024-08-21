import 'package:book/styles/app_colors.dart';
import 'package:book/styles/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(60),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.brown.withOpacity(0),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(60, 60),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 50,
                  ),
                ),
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          title: Text(
            AppLocalizations.of(context)!.login,
            textAlign: TextAlign.center,
            style: AppTextStyles.titleLogin(),
          ),
          centerTitle: true,
          toolbarHeight: 100,
          backgroundColor: AppColors.brown.withOpacity(0.8),
          elevation: 0,
        ),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: buildBody(),
      ),
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
                      //ovde ide pushNamed ka Registraciji
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
          TextFormField(
            maxLines: 1,
            enableInteractiveSelection: true,
            keyboardType: TextInputType.emailAddress,
            maxLength: 30,
            decoration: InputDecoration(
              counterText: "",
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.black, width: 1),
              ),
              alignLabelWithHint: true,
              labelStyle: TextStyle(color: Colors.black),
              labelText: AppLocalizations.of(context)!.email,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
            ),
            validator: (value) {
              if (value!.isNotEmpty) {
                email = value;
                return null;
              } else {
                return AppLocalizations.of(context)!.empty_email;
              }
            },
          ),
          SizedBox(
            height: 30,
          ),
          TextFormField(
            maxLines: 1,
            obscureText: !passwordVisible,
            enableInteractiveSelection: true,
            keyboardType: TextInputType.text,
            maxLength: 16,
            decoration: InputDecoration(
              counterText: "",
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.black, width: 1),
              ),
              alignLabelWithHint: true,
              labelStyle: TextStyle(color: Colors.black),
              labelText: AppLocalizations.of(context)!.password,
              suffixIcon: IconButton(
                icon: Icon(
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(
                    () {
                      passwordVisible = !passwordVisible;
                    },
                  );
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
            ),
            validator: (value) {
              if (value!.isNotEmpty) {
                password = value;
                return null;
              } else {
                return AppLocalizations.of(context)!.empty_password;
              }
            },
          )
        ],
      ),
    );
  }

  void onLoginPressed() async {
    if (_formKey.currentState!.validate()) {
      //login bloc funkcija
    }
  }
}
