// validate.dart

class Validator {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$");
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? fullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full Name is required';
    }
    return null;
  }

  static String? cardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Card number is required';
    }
    return null;
  }

  static String? cvc(String? value) {
    if (value == null ||
        value.isEmpty ||
        value.length > 3 ||
        value.length < 3) {
      return 'CVC is invalid';
    }
    return null;
  }

  static String? title(String? value) {
    if (value == null || value.isEmpty) {
      return 'Title is required';
    }
    return null;
  }

  static String? cnic(String? value) {
    if (value == null || value.isEmpty) {
      return 'CNIC is required';
    }
    if (value.length != 13) {
      return 'CNIC must be 13 digits';
    }
    return null;
  }

  static String? yourExpertise(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expertise is required';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password is required';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? classValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Class is required'; // Error message for empty class selection
    }
    return null;
  }

  static String? fromTimeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'From time is required'; // Error message for empty class selection
    }
    return null;
  }

  static String? feeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Fee is required'; // Error message for empty class selection
    }
    return null;
  }

  static String? toTimeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'To time is required'; // Error message for empty class selection
    }
    return null;
  }

  static String? subjectValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Subject is required'; // Error message for empty class selection
    }
    return null;
  }

  static String? gradeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'grade selection is required'; // Error message for empty class selection
    }
    return null;
  }
}
