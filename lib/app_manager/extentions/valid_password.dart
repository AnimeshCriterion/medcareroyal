



extension PasswordValidator on String {
  bool isValidPassword() {

    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    return !RegExp(pattern)
        .hasMatch(this);
  }
}