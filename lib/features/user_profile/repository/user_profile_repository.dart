import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/provider/firebase_provider.dart';
import '../../../core/type_dfs.dart';
import '../../../models/report.dart';
import '../../../models/review.dart';
import '../../../models/user_models.dart';
import '../../auth/controller/auth_controller.dart';

final userProfileRepositoryProvider = Provider(
  (ref) => UserProfileRepository(
    firebaseFirestore: ref.watch(firestoreProvider),
  ),
);

class UserProfileRepository {
  final FirebaseFirestore _firebaseFirestore;
  UserProfileRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  CollectionReference get _users =>
      _firebaseFirestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _post =>
      _firebaseFirestore.collection(FirebaseConstants.postsCollection);

  FutureVoid editProfile(UserModel userModel) async {
    try {
      return right(
        _users.doc(userModel.id).update(userModel.toMap()),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid updateStatus(String id, String status) async {
    try {
      return right(
        _users.doc(id).update({'status': status}),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  Future<UserModel?> fetchUserByUID(String uid) async {
    try {
      // Query the collection to get the user with the specified UID
      QuerySnapshot querySnapshot =
          await _users.where('id', isEqualTo: uid).get();

      // Check if the user with the given UID exists
      if (querySnapshot.docs.isNotEmpty) {
        // Get the user data
        Map<String, dynamic> userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;

        // Convert the Map to UserModel using the fromMap constructor
        return UserModel.fromMap(userData);
      } else {
        // User not found
        return null;
      }
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  FutureVoid updateUserFavorite(String id, String uid) async {
    try {
      var userSnapshot = await _users.doc(uid).get();
      // Fetch the current favorite list
      List<String> currentFavorites =
          List<String>.from(userSnapshot['favorite'] ?? []);

      // Check if the ID is already in the list
      if (currentFavorites.contains(id)) {
        // Remove the ID from the list
        currentFavorites.remove(id);
      } else {
        // Add the ID to the list if it's not already present
        currentFavorites.add(id);
      }

      return right(

          // Update the user document with the modified favorite list
          await _users.doc(uid).update({
        'favorite': currentFavorites,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  Stream<List<UserModel>> fetchUsers() {
    var ss = _users.snapshots().map(
          (event) => event.docs
              .map(
                (e) => UserModel.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );

    return ss;
  }

  FutureVoid addReview(String reviewedUserId, Review review) async {
    try {
      // Fetch the current user document
      DocumentSnapshot userSnapshot = await _users.doc(reviewedUserId).get();

      // Fetch the current reviews list
      List<dynamic> currentReviews =
          List<dynamic>.from(userSnapshot['reviews'] ?? []);

      print(currentReviews.toString());

      // Add the new review to the list
      currentReviews.add(review.toMap());

      return right(
        // Update the user document with the modified reviews list
        await _users.doc(reviewedUserId).update({
          'reviews': currentReviews,
        }),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid reportUser(String reportinguserid, Report review) async {
    try {
      // Fetch the current user document
      DocumentSnapshot userSnapshot = await _users.doc(reportinguserid).get();

      // Fetch the current reviews list
      List<dynamic> currentReviews =
          List<dynamic>.from(userSnapshot['report'] ?? []);

      // Add the new review to the list
      currentReviews.add(review.toMap());

      return right(
        // Update the user document with the modified reviews list
        await _users.doc(reportinguserid).update({
          'report': currentReviews,
        }),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }
}
