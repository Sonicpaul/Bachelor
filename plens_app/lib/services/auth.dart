import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:plens_app/models/user.dart' as plens;
import 'package:plens_app/models/user.dart';
import 'package:plens_app/services/database.dart';

// this class is used for authentication only!
class AuthService {
  final firebase.FirebaseAuth _firebaseAuth = firebase.FirebaseAuth.instance;

  //create UserObject based on FirebaseUser
  plens.User _userFromFirebaseUser(firebase.User firebaseUser) {
    return firebaseUser != null ? plens.User(uid: firebaseUser.uid) : null;
  }

  // auth change user Stream
  Stream<plens.User> get user {
    return _firebaseAuth
        .authStateChanges()
        .map((firebase.User user) => _userFromFirebaseUser(user));
  }

  // get LoggedInUser
  User get loggedInUser {
    return _userFromFirebaseUser(_firebaseAuth.currentUser);
  }

  // sign in Anon
  Future signInAnon() async {
    try {
      firebase.UserCredential userCredential =
          await firebase.FirebaseAuth.instance.signInAnonymously();
      return _userFromFirebaseUser(userCredential.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with E-mail & pass
  Future signInWithEmailAndPass(String email, String pass) async {
    try {
      firebase.UserCredential result = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: pass);
      firebase.User user = result.user;

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with E-mail &pass
  Future registerWithEmailAndPass(String email, String pass) async {
    try {
      firebase.UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: pass);
      firebase.User user = result.user;

      user.sendEmailVerification();

      // create a new doc for the user
      await DatabaseService(uid: user.uid)
          .updateUserData('Username', user.email, '');

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // try changing UserEmail
  Future updateUserEmail(String email) async {
    var currentUser = _firebaseAuth.currentUser;
    try {
      await currentUser.updateEmail(email);
      return 'done';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Change User Password with Email
  Future changePass(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return 'done';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
