class LoginValidationMixin {
  // ignore: body_might_complete_normally_nullable
  String? validateEmail(String? value) {
    if (value!.length < 8 || value.length > 50) {
      return "Must be 8-50 characters";
    }
  }

  // ignore: body_might_complete_normally_nullable
  String? validatePassword(String? value) {
        if (value!.length < 8 || value.length > 50) {
      return "Must be 8-50 characters";
    }
  }
}
