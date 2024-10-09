import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:together/Objects/user_detail.dart';

class FireStore {
  Future<UserDetail> getUserDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Fetch additional user details from Firebase Authentication
        await user.reload();
        user = FirebaseAuth.instance.currentUser;

        return UserDetail(
          uid: user!.uid, // Add uid to UserDetail
          name: user.displayName,
          profileImage: user.photoURL,
        );
      } else {
        // No user is signed in
        return UserDetail(name: null);
      }
    } catch (e) {
      print('Error fetching user details: $e');
      // Handle the error as needed
      return UserDetail(name: null);
    }
  }
}
