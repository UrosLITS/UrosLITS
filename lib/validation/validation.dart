import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const emailRegex =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

const passwordRegex =
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

class ValidationUtils {
  static bool validateEmailAddress(String input) {
    if (RegExp(emailRegex).hasMatch(input)) {
      return true;
    } else {
      return false;
    }
  }

  static String? passwordValidator(
      BuildContext context, String? value, int maxPasswordLenght) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)?.empty_password;
    } else if (!value.contains(RegExp(r'[A-Z]'))) {
      return AppLocalizations.of(context)?.no_upper_case;
    } else if (!value.contains(RegExp(r'[a-z]'))) {
      return AppLocalizations.of(context)?.no_lowe_case;
    } else if (!value.contains(RegExp(r'[0-9]'))) {
      return AppLocalizations.of(context)?.missing_number;
    } else if (!value.contains(RegExp(r'[!@#\$%^&*()<>?/|}{~:]'))) {
      return AppLocalizations.of(context)?.missing_special_char;
    }
    if (value.length < maxPasswordLenght) {
      return AppLocalizations.of(context)?.not_long_enough_pass;
    } else {
      return null;
    }
  }

  static bool validatePassword(String input) {
    if (RegExp(passwordRegex).hasMatch(input)) {
      return true;
    } else {
      return false;
    }
  }
}
