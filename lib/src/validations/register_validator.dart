// ignore_for_file: body_might_complete_normally_nullable

class RegisterValidationMixin {

 String? validateName(String? value) {
    if (value!.length < 4 || value.length > 16) {
      return "Must be 4-16 characters";
    }
  }

  String? validateEmail(String? value) {
    if (value!.length < 8 || value.length > 50) {
      return "Must be 8-50 characters";
    }
  }

  String? validatePassword(String? value) {
        if (value!.length < 8 || value.length > 50) {
      return "Must be 8-50 characters";
    }
  }
}
