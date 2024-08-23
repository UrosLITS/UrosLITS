import 'package:book/styles/app_colors.dart';
import 'package:book/styles/app_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarLogReg extends StatelessWidget implements PreferredSizeWidget {
  AppBarLogReg({
    required this.welcomeText,
    required this.registerText,
    required this.signInText,
  });

  final String welcomeText;
  final String registerText;
  final String signInText;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60)),
      ),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  welcomeText,
                  style: TextStyle(fontSize: 30, color: AppColors.black),
                ),
                SizedBox(height: 20),
                Text(
                  signInText,
                  style: TextStyle(fontSize: 15, color: AppColors.black),
                ),
              ],
            ),
          ),
        ),
      ),
      title: Text(registerText, style: AppTextStyles.titleLogin()),
      centerTitle: true,
      toolbarHeight: 75,
      backgroundColor: AppColors.brown.withOpacity(0.8),
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.maybePop(context);
        },
        icon: Icon(Icons.arrow_back_ios),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(200); // Return the desired height
}
