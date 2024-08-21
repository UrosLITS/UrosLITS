bool validateEmailAddress(String input) {
  const emailRegex =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  if (RegExp(emailRegex).hasMatch(input)) {
    return true;
  } else
    return false;
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Password is required";
  } else if (!value.contains(RegExp(r'[A-Z]'))) {
    return "Password must contain at least one uppercase letter";
  } else if (!value.contains(RegExp(r'[a-z]'))) {
    return "Password must contain at least one lowercase letter";
  } else if (!value.contains(RegExp(r'[0-9]'))) {
    return "Password must contain at least one numeric character";
  } else if (!value.contains(RegExp(r'[!@#\$%^&*()<>?/|}{~:]'))) {
    return "Password must contain at least one special character";
  }
  if (value.length < 8) {
    return "Password must be at least 8 characters long";
  } else if (value.length > 16) {
    return "Max length is 10 characters.";
  } else {
    return null; // Password is valid.
  }
}

String? confirmPasswordValidator(String? val, firstPasswordInpTxt) {
  final String firstPassword = firstPasswordInpTxt;
  final String secondPassword = val as String;
  if (firstPassword.isEmpty ||
      secondPassword.isEmpty ||
      firstPassword.length != secondPassword.length) {
    return "Two passwords don't match.";
  } else if (firstPassword != secondPassword) {
    return "Two passwords don't match.";
  }
  return null;
}

bool validatePassword(String input) {
  const passwordRegex =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

  if (RegExp(passwordRegex).hasMatch(input)) {
    return true;
  } else {
    return false;
  }
}
