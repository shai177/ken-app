import 'package:fire_base_first/models/AppUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Authservices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Converts a Firebase [User] object to an [AppUser] object.
  ///
  /// If the [user] is not null, it returns an [AppUser] with the [uid] set to the [user]'s UID.
  /// Otherwise, it returns null.
  AppUser? _userFromFireBaseUser(User? user) {
    if (user != null) return AppUser(ui: user.uid);
    return null;
  }

  /// Stream that emits the current authenticated user.
  ///
  /// Listens for authentication state changes and maps the current user to an [AppUser] object.
  /// Returns a [Stream<AppUser?>] object representing the current authenticated user.
  Stream<AppUser?> get user {
    return _auth.authStateChanges().map(_userFromFireBaseUser);
  }

  /// Creates a Firestore document with the given [name] and a subcollection under it.
  ///
  /// The function creates a document with the [name] parameter as the document ID in the collection `didnt_return`.
  /// It sets a field named `name` with the given [name].
  /// Additionally, it creates a subcollection named `items` under the created document.
  /// Prints a success message if the document creation is successful; otherwise, prints an error message.


  /// Signs in the user anonymously.
  ///
  /// Signs in the user anonymously using Firebase Authentication's signInAnonymously method.
  /// Returns an [AppUser] object representing the signed-in user if successful; otherwise, returns null.
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFireBaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /// Registers a new user with the provided [email] and [password].
  ///
  /// Registers a new user using Firebase Authentication's createUserWithEmailAndPassword method.
  /// If registration is successful, it creates a document in Firestore using the [createDocument] function.
  /// Returns an [AppUser] object representing the registered user if successful; otherwise, returns null.
  Future register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      return _userFromFireBaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /// Signs in the user with the provided [email] and [password].
  ///
  /// Signs in the user using Firebase Authentication's signInWithEmailAndPassword method.
  /// Returns an [AppUser] object representing the signed-in user if successful; otherwise, returns null.
  Future signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFireBaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /// Signs out the current user.
  ///
  /// Signs out the current user using Firebase Authentication's signOut method.
  /// Returns null if successful; otherwise, returns an error message.
  Future signout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /// Retrieves the value of the 'name' key from SharedPreferences.
  ///
  /// Retrieves the value of the 'name' key from SharedPreferences, which is a local key-value storage.
  /// Returns the value of the 'name' key as a [String] or an empty string if it is null.
  Future<String> getName() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('name') ?? "";
  }
}
