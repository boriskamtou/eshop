import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeProductsRepository {
  final bool hasDelay;

  final List<Product> _products = kTestProducts;

  FakeProductsRepository({this.hasDelay = true});

  List<Product> getProductList() {
    return _products;
  }

  Product? getProduct(String id) => _getProduct(_products, id);

  Future<List<Product>> fetchProductList() async {
    await delay(hasDelay);
    return Future.value(_products);
  }

  Stream<List<Product>> watchProductsList() async* {
    await delay(hasDelay);
    yield _products;
  }

  Stream<Product?> watchProduct(String id) {
    return watchProductsList().map((products) => _getProduct(products, id));
  }

  static Product? _getProduct(List<Product> products, String id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}

final fakeProductRepositoryProvider = Provider<FakeProductsRepository>((ref) {
  return FakeProductsRepository();
});

final productsListStreamProvider =
    StreamProvider.autoDispose<List<Product>>((ref) {
  debugPrint("Created productsListStreamProvider");
  final productRepository = ref.watch(fakeProductRepositoryProvider);
  return productRepository.watchProductsList();
});

final productsListFutureProvider =
    FutureProvider.autoDispose<List<Product>>((ref) {
  final productRepository = ref.watch(fakeProductRepositoryProvider);
  return productRepository.fetchProductList();
});

final productStringFamilyProvider =
    StreamProvider.autoDispose.family<Product?, String>((ref, id) {
  debugPrint("Created productProvider with id: $id");
  final productsRepository = ref.watch(fakeProductRepositoryProvider);
  return productsRepository.watchProduct(id);
});
