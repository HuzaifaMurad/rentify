import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:rentify/models/product.dart';

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
}
