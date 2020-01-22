import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn;
  FacebookLogin _facebookLogin;

  // create user object based on Firebase object
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
        //.map((FirebaseUser user) => _userFromFirebaseUser(user)); // same as functionality below line
        .map(
            _userFromFirebaseUser); // maps Firebase User to our User Model Class
  }

  // sign In anonymously
  Future signInAnonymously() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

// sign In with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign In with google
  Future signInWithGoogle() async {
    _googleSignIn = GoogleSignIn(scopes: ['email']);

    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        AuthResult authResult = await _auth.signInWithCredential(
            GoogleAuthProvider.getCredential(
                idToken: (await googleSignInAccount.authentication).idToken,
                accessToken:
                    (await googleSignInAccount.authentication).accessToken));

        FirebaseUser user = authResult.user;
        // create a new document for the user with the uid
        await DatabaseService(uid: user.uid)
            .updateUserData('0', 'Anonymous', 100);

        return _userFromFirebaseUser(user);
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign In with Facebook
  Future signInWithFacebook() async {
    try {
      _facebookLogin = FacebookLogin();
      FacebookLoginResult facebookLoginResult =
          await _facebookLogin.logIn(['email', 'public_profile']);
      if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
        AuthResult authResult = await _auth.signInWithCredential(
            FacebookAuthProvider.getCredential(
                accessToken: (facebookLoginResult.accessToken).token));

        FirebaseUser user = authResult.user;

        // create a new document for the user with the uid
        await DatabaseService(uid: user.uid)
            .updateUserData('0', 'Anonymous', 100);

        return _userFromFirebaseUser(user);
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

// register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid)
          .updateUserData('0', 'Anonymous', 100);

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

// sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
