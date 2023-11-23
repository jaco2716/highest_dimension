class ValidateValues {
  //check if string is empty
  String? validateString(String? value) {
    try {
      return value!.isEmpty ? 'Påkrævet' : null;
    } catch (e) {
      return 'Påkrævet';
    }
  }

  String? validatePassword(String? value) {
    try {
      return value!.length < 6 ? 'Password skal være midst 6 tegn.' : null;
    } catch (e) {
      return 'Password skal være midst 6 tegn.';
    }
  }

  String? validateEmail(String? value) {
    // if (value == null) return 'Ugyldig E-mail.';
    try {
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = RegExp(pattern);
      return (!regex.hasMatch(value!)) ? 'Ugyldig E-mail.' : null;
    } catch (e) {
      return 'Ugyldig E-mail.';
    }
  }
}
