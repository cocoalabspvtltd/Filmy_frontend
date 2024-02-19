extension StringValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  bool isValidName() {
    if (this.isEmpty) return false;
    return RegExp(r"^[a-zA-Z\s]*$", unicode: true).hasMatch(this);
  }

  bool isValidMobileNumber() {
    if (this.isEmpty) return false;
    if (this.length != 10) return false;

    return !(this.split('').any((element) {
      try {
        int.parse(element);
        return false;
      } catch (e) {
        return true;
      }
    })) &&
        (this.length > 5);

    // return !(RegExp(r"[a-zA-Z]+", unicode: true).hasMatch(this)) &&
    //     !(this.length < 6 || this.length > 15);
  }
  static final RegExp _dobRegExp =
  RegExp('^(19|20)\d\d([- /.])(0[1-9]|1[012])\2(0[1-9]|[12][0-9]|3[01])');
   ivalidateDob(value) {
    return value!.isEmpty ||
        value.length > 10 ||
        value.length < 8 ||
        _dobRegExp.hasMatch(value)
        ? "Enter Date in format YYYY-MM-DD"
        : null;
  }
  bool isValiddob() {
    return _dobRegExp
        .hasMatch(this);
  }
  Map<String, dynamic> isValidPassword() {
    if (this.isEmpty)
      return {'isValid': false, 'message': 'Please provide a password'};
    if (this.contains(' '))
      return {
        'isValid': false,
        'message': 'Password should not contain any space'
      };
    if (this.length < 6)
      return {
        'isValid': false,
        'message': 'Password must be minimum 6 characters long'
      };

    return {'isValid': true, 'message': ''};
  }
}
