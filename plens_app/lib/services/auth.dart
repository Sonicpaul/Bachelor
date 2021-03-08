import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:plens_app/models/user.dart' as plens;

class AuthService {

  final firebase.FirebaseAuth _firebaseAuth = firebase.FirebaseAuth.instance;

  //create UserObject based on FirebaseUser
  plens.User _userFromFirebaseUser(firebase.User firebaseUser){
    return firebaseUser != null ? plens.User(uid: firebaseUser.uid) : null;
  }

  // auth change user Stream
  Stream<plens.User> get user {
    return _firebaseAuth.authStateChanges()
        .map((firebase.User user) => _userFromFirebaseUser(user));
  }

  // sign in Anon
  Future signInAnon() async{

    try{

      firebase.UserCredential userCredential = await firebase.FirebaseAuth.instance.signInAnonymously();
      return _userFromFirebaseUser(userCredential.user);

    } catch(e){

      print(e.toString());
      return null;

    }
  }

  //sign in with E-mail & pass

  //register with E-mail &pass

  //sign out
}