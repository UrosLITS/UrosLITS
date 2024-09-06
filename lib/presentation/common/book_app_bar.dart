import 'package:book/styles/app_colors.dart';
import 'package:book/styles/app_styles.dart';
import 'package:flutter/material.dart';

class AppBarLogReg extends StatelessWidget implements PreferredSizeWidget {
  const AppBarLogReg({
    super.key,
    required this.titleText,
    this.leading,
  });

  final String titleText;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60)),
        ),
        bottom: PreferredSize(
          preferredSize: preferredSize,
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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 50,
                  ),
                )),
          ),
        ),
        title: Text(titleText, style: AppTextStyles.titleLogin()),
        centerTitle: true,
        toolbarHeight: 75,
        backgroundColor: AppColors.brown.withOpacity(0.8),
        elevation: 0,
        leading: leading);
  }

  @override
  Size get preferredSize => Size.fromHeight(200);
}
