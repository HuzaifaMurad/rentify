import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:rentify/core/utility.dart';

import '../../../models/user_models.dart';
import '../repository/auth_repository.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

final authStateProvider = StreamProvider((ref) {
  final authcontroller = ref.watch(authControllerProvider.notifier);
  return authcontroller.authStateChange;
});

class AuthController extends StateNotifier<bool> {
  final Ref _ref;
  final AuthRepository _authRepository;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChange => _authRepository.authStateChnage;

  void loginWithEmailAndPassword(
      String email, String password, BuildContext context) {
    _authRepository.loginWithEmailAndPassword(email, password, context);
  }

  void signInWithGoogle(
    BuildContext context,
  ) async {
    state = true;
    final user = await _authRepository.googleSignIn();
    state = false;
    //use for error handling by using package fpdart and type_ds.dart
    user.fold(
      (l) => showSnackBar(context, l.message),
      (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  void signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String phone,
    required File imageFile,
    required String password,
    required BuildContext context,
  }) async {
    _authRepository.signUpWithEmailAndPassword(
        email, name, phone, imageFile, password, context);
  }

  Stream<UserModel?> getUSerData(String uid) {
    return _authRepository.getUserData(uid);
  }

  Future<UserModel?> getSpecificUserData(String uid) {
    return _authRepository.getSpecificUserData(uid);
  }

  void signOut() async {
    _authRepository.signOut();
  }
}
