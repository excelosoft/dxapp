String? validateEmail(String? value) {
  if (value?.trim() == null || value!.trim().isEmpty) {
    return 'Please enter your email';
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
  if (!emailRegex.hasMatch(value.trim())) {
    return 'Please enter a valid email address';
  }

  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters long';
  }
  return null;
}

String? validateSignupPassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters long';
  }
  if (!value.contains(RegExp(r'[0-9]'))) {
    return 'Password must contain at least one number';
  }

  if (!value.contains(RegExp(r'[!@#\$%^&*()_+{}|:;<>,.?~\-]'))) {
    return 'Password must contain at least one symbol';
  }
  return null;
}

String? validateForNormalFeild({required String? value, required String? props}) {
  if (value == null || value.isEmpty) {
    return 'Please enter your $props';
  }
  return null;
}

String? validateLogoField({required String? value, required String? props}) {
  if (value == null || value.isEmpty) {
    return 'Please upload your $props';
  }
  return null;
}

String? validateForNameField({required String? value, required String? props}) {
  // final RegExp nameRegExp = RegExp(r'^[a-zA-Z\s]+$');
  // final RegExp nameRegExp = props == 'Last Name' ? RegExp(r'^[a-zA-Z]+$') : RegExp(r'^[a-zA-Z]+(?:\s[a-zA-Z]+)?$');

  if (value == null || value.isEmpty) {
    return 'Please enter your $props';
  }
  // if (!nameRegExp.hasMatch(value)) {
  //   return 'Invalid $props';
  // }
  return null;
}

String? validateForLastNameField({required String value, required String? props}) {
  // final RegExp nameRegExp = RegExp(r'^[a-zA-Z\s]+$');
  final RegExp nameRegExp = RegExp(r'^[a-zA-Z]+$');

  if (value.isEmpty) {
    return 'Please enter your $props';
  }
  if (!nameRegExp.hasMatch(value)) {
    return 'Invalid $props';
  }
  return null;
}

String? validateForLastNameForNotMandatory({required String value, required String? props}) {
  // final RegExp nameRegExp = RegExp(r'^[a-zA-Z\s]+$');
  final RegExp nameRegExp = RegExp(r'^[a-zA-Z]+$');

  if (!nameRegExp.hasMatch(value) && value.isNotEmpty) {
    return 'Invalid $props';
  }
  return null;
}

String? validationForAlphaNumeric({required String? value, required String? props}) {
  final RegExp nameRegExp = RegExp(r'^(?!\s*$)[a-zA-Z0-9- ]{1,20}$');

  if (value == null || value.isEmpty) {
    return 'Please enter your $props';
  }
  if (!nameRegExp.hasMatch(value)) {
    return 'Invalid $props';
  }
  return null;
}

String? validateForOraganizationNameField({required String? value, required String? props}) {
  final RegExp nameRegExp = RegExp(r'^[a-zA-Z0-9\s]+$');

  if (value == null || value.isEmpty) {
    return 'Please enter your $props';
  }
  if (!nameRegExp.hasMatch(value)) {
    return 'Invalid $props';
  }
  return null;
}

String getOnlyNumber(String value) {
  RegExp regExp = RegExp(r'\D+');
  String numbersOnly = value.replaceAll(regExp, '');
  return numbersOnly;
}

String removeExtraSpaces(String input) {
  List<String> words = input.split(' ').where((word) => word.isNotEmpty).toList();
  String output = words.join(' ');
  return output;
}

String? validateForMobileNumberFeild({required String? value, required String? props}) {
  if (value == null || value.isEmpty) {
    return 'Please enter your $props';
  } else if (value.length < 10) {
    return "Enter Valid $props";
  }
  return null;
}

String? validateEmailNotMandatory(String? value) {
  if (value == null || value.isNotEmpty) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
    if (!emailRegex.hasMatch(value!)) {
      return 'Please enter a valid email address';
    }
  }
  return null;
}

String? isYouTubeVideoURL(String url) {
  if (url.isEmpty) {
    return null;
  }
  final RegExp regExp = RegExp(
    r'^https?:\/\/(?:www\.)?youtube\.com\/watch\?v=([a-zA-Z0-9_-]+)',
    caseSensitive: false,
  );
  final RegExp regExp2 = RegExp(
    r'^https:\/\/(?:www\.)?youtu\.be\/([\w-]+)(?:\?.*)?$',
    caseSensitive: false,
  );

  final RegExp shortsUrlRegex = RegExp(
    r'^https:\/\/(?:www\.)?youtube\.com\/(?:shorts\/)?([\w-]+)(?:\?.*)?$',
    caseSensitive: false,
  );

  final RegExp shortsUrlRegex2 = RegExp(
    r'^https:\/\/(?:www\.)?youtube\.com\/(?:(?:shorts\/)|(?:watch\?v=))?([\w-]+)(?:\?.*)?$',
    caseSensitive: false,
  );

  if (!regExp.hasMatch(url) && !regExp2.hasMatch(url) && !shortsUrlRegex.hasMatch(url) && !shortsUrlRegex2.hasMatch(url)) {
    return 'Please enter a valid Youtube video link';
  }
  return null;
}

String? validateFordropDown({required String? value, required String? props, required String? textfieldvalue}) {
  if (value == null || value.isEmpty && textfieldvalue == null || textfieldvalue!.isEmpty) {
    return 'Please Select $props';
  }
  return null;
}
