import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:rentify/models/product.dart';
import 'package:rentify/models/report.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/provider/firebase_provider.dart';
import '../../../core/type_dfs.dart';

final addProductRepostioryProvider = Provider(
  (ref) => AddProductRepository(
    firebaseFirestore: ref.watch(firestoreProvider),
  ),
);

class AddProductRepository {
  final FirebaseFirestore _firebaseFirestore;
  AddProductRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  CollectionReference get _posts =>
      _firebaseFirestore.collection(FirebaseConstants.postsCollection);

  FutureVoid addPost(Product post) async {
    try {
      return right(
        _posts.doc(post.id).set(post.toMap()),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid updateProduct(Product product) async {
    try {
      return right(
        _posts.doc(product.id).update(product.toMap()),
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
        _posts.doc(id).update({'status': status}),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid reportProd(String reportinguserid, Report review) async {
    try {
      // Fetch the current user document
      DocumentSnapshot userSnapshot = await _posts.doc(reportinguserid).get();

      // Fetch the current reviews list
      List<dynamic> currentReviews =
          List<dynamic>.from(userSnapshot['report'] ?? []);

      // Add the new review to the list
      currentReviews.add(review.toMap());

      return right(
        // Update the user document with the modified reviews list
        await _posts.doc(reportinguserid).update({
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

  Stream<List<Product>> fetchRentalProduct() {
    var ss = _posts.orderBy('postedDate', descending: true).snapshots().map(
          (event) => event.docs
              .map(
                (e) => Product.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );

    return ss;
  }

  FutureVoid deleteDocument(String documentId) async {
    try {
      return right(
        // Update the user document with the modified reviews list
        await _posts.doc(documentId).delete(),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
      // Handle error
    }
  }

  FutureVoid updateView({required String id, required String userid}) async {
    try {
      var userSnapshot = await _posts.doc(id).get();
      // Fetch the current favorite list
      List<String> currentView = List<String>.from(userSnapshot['view'] ?? []);

      if (currentView.contains(userid)) {
        return right(
          // Update the user document with the modified favorite list
          print('already exist'),
        );
      }
      currentView.add(userid);

      return right(
        // Update the user document with the modified favorite list
        await _posts.doc(id).update(
          {
            'view': currentView,
          },
        ),
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
