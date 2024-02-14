import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentify/models/review.dart';

import '../../../core/provider/storage_provider.dart';
import '../../../core/utility.dart';
import '../../../models/report.dart';
import '../../../models/user_models.dart';
import '../../auth/controller/auth_controller.dart';
import '../../dashboard.dart/dashboard_screen.dart';
import '../repository/user_profile_repository.dart';

final userFetchProvider = StreamProvider((ref) {
  final postController = ref.watch(userProfileControllerProvider.notifier);
  return postController.fetchUsers();
});

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>(
  (ref) => UserProfileController(
    userProfileRepository: ref.watch(userProfileRepositoryProvider),
    ref: ref,
    storageRepository: ref.watch(storageRepositoryProvider),
  ),
);

// final getUserPostProvider = StreamProvider.family(
//   (ref, String uid) =>
//       ref.read(userProfileControllerProvider.notifier).getUserPost(uid),
// );

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  UserProfileController(
      {required UserProfileRepository userProfileRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _userProfileRepository = userProfileRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void updateUserFavorite(String id, String uid) async {
    UserModel user = _ref.read(userProvider)!;

    // Create a copy of the original list and add the new item
    List<String> updatedFavorite = List.from(user.favorite)..add(id);

    // Update the user object with the modified favorite list
    user = user.copyWith(favorite: updatedFavorite);

    final res = await _userProfileRepository.updateUserFavorite(id, uid);

    res.fold(
      (l) => null,
      (r) => _ref.read(userProvider.notifier).update((state) => user),
    );
  }

  void editProfile({
    required File? profileFile,
    required BuildContext context,
    required String name,
    required String email,
    required String phoneno,
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;
    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'users/profile',
        id: user.id,
        file: profileFile,
      );
      res.fold((l) => showSnackBar(context, l.message),
          (r) => user = user.copyWith(profilePic: r));
    }

    user = user.copyWith(name: name, phoneNo: phoneno);
    final res = await _userProfileRepository.editProfile(user);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        _ref.read(userProvider.notifier).update((state) => user);
        // Navigator.of(context).pop();
      },
    );
  }

  Stream<List<UserModel>> fetchUsers() {
    return _userProfileRepository.fetchUsers();
  }

  void addUserReview(String reviewUserId, Review review) async {
    try {
      // // Fetch the user being reviewed
      // UserModel? reviewedUser =
      //     await _userProfileRepository.fetchUserByUID(reviewUserId);

      // // Fetch the current reviews list
      // List<Review> currentReviews = List<Review>.from(reviewedUser!.reviews!);

      // // Add the new review to the list
      // currentReviews.add(review);

      // // Create a copy of the original user object and update the reviews
      // UserModel updatedUser = reviewedUser.copyWith(reviews: currentReviews);

      // Update the user document with the modified reviews list
      final res = await _userProfileRepository.addReview(reviewUserId, review);

      res.fold(
        (l) => null,
        (r) => print('user review added'),
      );
    } catch (e) {
      print('Error adding user review: $e');
    }
  }

  void updateStatus({
    required String id,
    required String status,
    required BuildContext context,
  }) async {
    state = true;

    final res = await _userProfileRepository.updateStatus(id, status);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {},
    );
  }

  void reportUser({
    required String id,
    required Report report,
    required BuildContext context,
  }) async {
    state = true;

    final res = await _userProfileRepository.reportUser(id, report);
    state = false;
    res.fold(
      (l) {
        showSnackBar(context, l.message);
      },
      (r) {
        showSnackBar(context, 'Report submitted');
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const DashBoard(),
        ));
      },
    );
  }
}
