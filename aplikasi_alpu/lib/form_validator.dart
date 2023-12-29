class FormValidator {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    } else if (value.length > 50) {
      return 'Nama tidak boleh lebih dari 50 karakter';
    } else if (!_isCapitalized(value)) {
      return 'Nama harus dimulai dengan huruf kapital';
    }
    return null;
  }

  static String? validateNIK(String? value) {
    if (value?.isNotEmpty != true) {
      return 'NIK tidak boleh kosong';
    } else if (value!.length != 16) {
      return 'NIK harus terdiri dari 16 digit';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null) {
      return null;
    }

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigit = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacters =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    if (!hasUppercase) {
      return 'password harus mangandung huruf kapital';
    } else if (!hasLowercase) {
      return 'password harus mengandung huruf kecil';
    } else if (!hasDigit) {
      return 'password harus mengandung angka';
    } else if (!hasSpecialCharacters) {
      return 'password harus mengandung simbol';
    } else if (password.length < 10) {
      return 'password minimal 10 huruf';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    } else if (value.length < 10 || value.length > 13) {
      return 'Nomor telepon harus terdiri dari 10-13 digit';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    } else {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value)) {
        return 'Masukkan email yang valid';
      }
    }
    return null;
  }

  static String? validateAddress(String? value) {
    if (value?.isEmpty == true) {
      return 'Alamat tidak boleh kosong';
    } else if (!_isCapitalized(value)) {
      return 'Alamat harus dimulai dengan huruf kapital';
    }
    return null;
  }

  static bool _isCapitalized(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    return value[0] == value[0].toUpperCase();
  }
}
