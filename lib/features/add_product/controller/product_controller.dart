import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rentify/core/provider/storage_provider.dart';
import 'package:rentify/features/add_product/repository/product_repository.dart';
import 'package:rentify/features/dashboard.dart/dashboard_screen.dart';
import 'package:rentify/features/home/screen/home_screen.dart';
import 'package:rentify/models/product.dart';
import 'package:rentify/models/report.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utility.dart';
import '../../auth/controller/auth_controller.dart';

final renalPostsProvider = StreamProvider((ref) {
  final postController = ref.watch(addProductControllerProvider.notifier);
  return postController.fetchRenalProduct();
});

final addProductControllerProvider =
    StateNotifierProvider<ProductController, bool>(
  (ref) {
    final postRepository = ref.watch(addProductRepostioryProvider);
    final storageRepository = ref.watch(storageRepositoryProvider);
    return ProductController(
        addProductRepository: postRepository,
        ref: ref,
        storageRepository: storageRepository);
  },
);

class ProductController extends StateNotifier<bool> {
  final AddProductRepository _addProductRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  ProductController({
    required AddProductRepository addProductRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _addProductRepository = addProductRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void addPost({
    required BuildContext context,
    required String title,
    required String price,
    required String description,
    required String selectedCategory,
    required String selectedCondition,
    required String location,
    required String city,
    required List<File?> file,
  }) async {
    state = true;
    String productId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final imageRes = await _storageRepository.storeFiles(
      path: 'posts/$selectedCategory',
      ids: productId,
      files: file,
    );
    DateTime myDate = DateTime.now();

    // Define the date format
    String formattedDate = DateFormat('MM-dd-yyyy').format(myDate);

    imageRes.fold(
      (l) => showSnackBar(context, l.message),
      (url) async {
        final Product products = Product(
            id: productId,
            title: title,
            description: description,
            price: double.parse(price),
            images: url,
            category: selectedCategory,
            isAvailable: true,
            postedDate: myDate,
            location: location,
            ownerId: user.id,
            address: city,
            ownerName: user.name,
            ownerContact: user.phoneNo,
            reports: 0,
            status: 'inactive',
            report: null,
            view: []);

        final res = await _addProductRepository.addPost(products);
        res.fold((l) => showSnackBar(context, l.message), (r) {
          showSnackBar(context, 'Posted Successfully');
          // Routemaster.of(context).pop();
        });
      },
    );
  }

  void updateStatus({
    required String id,
    required String status,
    required BuildContext context,
  }) async {
    state = true;

    final res = await _addProductRepository.updateStatus(id, status);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {},
    );
  }

  void deleteProduct({
    required String id,
    required BuildContext context,
  }) async {
    state = true;

    final res = await _addProductRepository.deleteDocument(id);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => showSnackBar(context, 'delete successfully'),
    );
  }

  void reportProduct({
    required String id,
    required Report report,
    required BuildContext context,
  }) async {
    state = true;

    final res = await _addProductRepository.reportProd(id, report);
    state = false;
    res.fold(
      (l) {
        print(l.message);
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

  void editProfile({
    required Product product,
    required BuildContext context,
  }) async {
    state = true;

    product = product.copyWith(
      address: product.address,
      category: product.category,
      description: product.description,
      id: product.id,
      images: product.images,
      isAvailable: product.isAvailable,
      location: product.location,
      ownerContact: product.ownerContact,
      ownerId: product.ownerId,
      ownerName: product.ownerName,
      postedDate: product.postedDate,
      price: product.price,
      title: product.title,
    );
    final res = await _addProductRepository.updateProduct(product);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        // _ref.read(userProvider.notifier).update((state) => user);
        Navigator.of(context).pop();
      },
    );
  }

  Stream<List<Product>> fetchRenalProduct() {
    return _addProductRepository.fetchRentalProduct();
  }

  void updateView({
    required String id,
    required String userid,
    required BuildContext context,
  }) async {
    state = true;

    final res = await _addProductRepository.updateView(id: id, userid: userid);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {},
    );
  }
}
