import '../../config/utils/app_utils/app_strings.dart';

class ValidationForm {
  static String? phoneValidator(String? value) {
    bool isValid =
        RegExp(r"^(\+201|1|01|00201)[0-2,5]{1}[0-9]{8}").hasMatch(value!);
    if (value.isEmpty) {
      return AppStrings.pleaseEnterPhoneNumber;
    } else if (!isValid) {
      return AppStrings.phoneNumberNotValid;
    }
    return null;
  }

  static String? passwordValidator(String? v) {
    if (v?.isEmpty ?? true) {
      return AppStrings.pleaseEnterPassword;
    } else if (v!.length <= 5) {
      return AppStrings.passwordNotValid;
    } else {
      return null;
    }
  }

  static String? confirmPasswordValidator(
    String? v,
    String text,
  ) {
    if (v?.isEmpty ?? true) {
      return AppStrings.passwordNotMatch;
    } else if (text != v) {
      return AppStrings.passwordNotMatch;
    } else {
      return null;
    }
  }

  static String? nameValidator(String? v) {
    if ((v?.isEmpty ?? true)) {
      return AppStrings.pleaseEnterName;
    } 
    return null;
  }

  static String? dateValidator(String? date) {
    if (date?.isEmpty ?? true) {
      return AppStrings.pleaseEnterDate;
    } else {
      // Regular expression to match the date format YYYY-MM-DD
      bool isValid = RegExp(r"^\d{4}-\d{2}-\d{2}$").hasMatch(date!);
      if (!isValid) {
        return AppStrings.dateNotValid;
      }
    }
    return null;
  }


  static String? codeValidator(String? v, String? code) {
    if (v?.isEmpty ?? true) {
      return AppStrings.pleaseEnterCode;
    } else if (v != code) {
      return AppStrings.invalidCode;
    } else {
      return null;
    }
  }

  static String? emailValidator(String? value) {
    if (value?.isEmpty ?? true) {
      return AppStrings.pleaseEnterName;
    } else {
      // Regular expression to match a valid email format
      bool isValid = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value!);
      if (!isValid) {
        return AppStrings.email;
      }
    }
    return null;
  }
}
