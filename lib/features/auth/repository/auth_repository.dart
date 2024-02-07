// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rentify/core/provider/firebase_provider.dart';
import 'package:rentify/core/type_dfs.dart';
import 'package:rentify/core/utility.dart';

import '../../../core/constants/constants.dart';
import '../../../core/constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/provider/storage_provider.dart';
import '../../../models/user_models.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
    storageRepository: ref.watch(storageRepositoryProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final StorageRepository _storageRepository;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
    required StorageRepository storageRepository,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn,
        _storageRepository = storageRepository;

  CollectionReference get users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureEither<UserModel?> googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      UserModel? userModel;
      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          id: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? 'no name',
          profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
          email: userCredential.user!.email!,
          fingerPrint: '',
          phoneNo: userCredential.user!.phoneNumber ?? '',
          favorite: [
            '',
          ],
          reviews: null,
        );
        await users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureEither<UserModel?> signUpWithEmailAndPassword(
    String email,
    String name,
    String phone,
    File imageFile,
    String password,
    BuildContext context,
  ) async {
    String? profileImage;
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final res = await _storageRepository.storeFile(
        path: 'users/profile',
        id: userCredential.user!.uid,
        file: imageFile,
      );
      res.fold((l) {
        showSnackBar(context, l.message);
        return;
      }, (r) => profileImage = r);

      UserModel? userModel;
      userModel = UserModel(
        id: userCredential.user!.uid,
        name: name, // You can prompt the user to set their name later
        profilePic:
            profileImage != null ? profileImage! : Constants.avatarDefault,
        email: userCredential.user!.email!,
        fingerPrint: 'no data',
        phoneNo: phone,
        favorite: [
          '',
        ],
        reviews: null,
      );
      await users.doc(userCredential.user!.uid).set(userModel.toMap());

      return right(userModel);
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid loginWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // ignore: use_build_context_synchronously
      return right(showSnackBar(context, 'login successfully'));
    } on FirebaseException catch (e) {
      return right(showSnackBar(context, e.toString()));
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  Stream<User?> get authStateChnage => _auth.authStateChanges();

  Stream<UserModel?> getUserData(String uid) {
    return users.doc(uid).snapshots().map(
      (event) {
        final data = event.data();
        if (data == null) {
          // Document does not exist or data is null
          return null;
        }

        // Safely cast the data to Map<String, dynamic> and create a UserModel
        return UserModel.fromMap(data as Map<String, dynamic>);
      },
    );
  }

  Future<UserModel?> getSpecificUserData(String uid) async {
    try {
      DocumentSnapshot documentSnapshot = await users.doc(uid).get();
      final data = documentSnapshot.data();
      if (data == null) {
        // Document does not exist or data is null
        return null;
      }
      log(data.toString());
      // Safely cast the data to Map<String, dynamic> and create a UserModel
      return UserModel.fromMap(data as Map<String, dynamic>);
    } catch (e) {
      log('Error fetching user data: $e');
      return null;
    }
  }

  void signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
