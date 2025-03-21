import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  String? _uniqueId;

  User? get user => _user;
  String? get uniqueId => _uniqueId;

  UserProvider() {
    _loadUserSession();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _user = user;
        _uniqueId = user.uid;
      } else {
        _user = null;
        _uniqueId = null;
      }
      notifyListeners();
    });
  }

  // Set user after successful login
  void setUser(User user) {
    _user = user;
    _uniqueId = user.uid;
    _saveUserId();
    notifyListeners();
  }

  // Sign out user and clear session
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      _user = null;
      _uniqueId = null;
      await _disposeUserId();
      notifyListeners();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Check if user is logged in
  bool get isUserAuthenticated => _user != null;

  // Load user session from SharedPreferences
  Future<void> _loadUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('userId');
    if (uid != null) {
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null && firebaseUser.uid == uid) {
        _user = firebaseUser;
        _uniqueId = uid;
        notifyListeners();
      } else {
        // Clear invalid session
        await _disposeUserId();
      }
    }
  }

  // Save user ID to SharedPreferences
  Future<void> _saveUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_uniqueId != null) {
      prefs.setString('userId', _uniqueId!);
    }
  }

  // Remove user session from SharedPreferences
  Future<void> _disposeUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
  }
}