import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<AuthResult> signInWithCredential(AuthCredential credential) async {
    return _auth.signInWithCredential(credential);
  }

  Future<void> verifyPhoneNumber(
      String phone,
      PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
      PhoneCodeSent codeSent,
      Duration duration,
      PhoneVerificationCompleted verificationCompleted,
      PhoneVerificationFailed verificationFailed) async {
    return _auth.verifyPhoneNumber(
        phoneNumber: phone,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        codeSent: codeSent,
        timeout: duration,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed);
  }


  Future<FirebaseUser> getCurrentUser() {
    return _auth.currentUser();
  }
}
