import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:wherehome/common/inherited_http_controller.dart';
import 'package:wherehome/common/providers/user_provider.dart';
import 'package:wherehome/common/widgets/dialog_error.dart';
import 'package:wherehome/data/repositories/home_owner_repo.dart';
import 'package:wherehome/features/profile/profile_view.dart';
import 'package:wherehome/features/profile/widgets/empty_profile.dart';

// Define loadWidgetAuthorized method
void loadWidgetAuthorized(
    BuildContext context, Widget Function(HomeOwner) successWidget) async {
  final api = HttpControllerInherited.of(context).api;
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final user = userProvider.user;

  if (user != null) {
    try {
      // Get the Firebase ID token
      final idToken = await user.getIdToken();

      // Use the Firebase UID and ID token for the API request
      api.sendGetRequest(
        'homeowner/${user.uid}', // Use Firebase UID
        {'Authorization': 'Bearer $idToken'}, // Use Firebase ID token
        (success) {
          final json = jsonDecode(success.body);
          HomeOwner? homeOwner = HomeOwner.fromJson(json);
          userProvider.setUser(user);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => successWidget(homeOwner)),
          );
        },
        (failure) {
          showErrorDialog(context, 'You are not authorized');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfileView(
                child: EmptyProfile(),
              ),
            ),
          );
        },
      );
    } catch (e) {
      // Handle Firebase token retrieval errors
      showErrorDialog(context, 'Failed to authenticate: $e');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfileView(
            child: EmptyProfile(),
          ),
        ),
      );
    }
  } else {
    // Handle case where the user is not logged in
    showErrorDialog(context, 'You must be logged in to access this feature');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileView(
          child: EmptyProfile(),
        ),
      ),
    );
  }
}