
class SignUpModel {
  String email;
  String password;
  bool isAgreedToTerms;

  SignUpModel({
    required this.email,
    required this.password,
    this.isAgreedToTerms = false,
  });


  bool isValid() {
    return email.isNotEmpty && password.isNotEmpty && isAgreedToTerms;
  }
}
