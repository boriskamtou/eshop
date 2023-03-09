import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FakeProductsRepository makeProductRepository() =>
      FakeProductsRepository(hasDelay: false);

  group('FakeProductRepository', () {
    test('Get the list of product', () {
      final fakeProductRepository = makeProductRepository();

      expect(fakeProductRepository.getProductList(), kTestProducts);
    });

    test('Get product by his id', () {
      final fakeProductRepository = makeProductRepository();

      expect(fakeProductRepository.getProduct('1'), kTestProducts[0]);
    });

    test('Return null if the product is not in the amount of product', () {
      final fakeProductRepository = makeProductRepository();
      expect(
        fakeProductRepository.getProduct('100'),
        null,
      );
    });

    test('Fetch Product List', () async {
      final fakeProductRepository = makeProductRepository();
      expect(
        await fakeProductRepository.fetchProductList(),
        kTestProducts,
      );
    });

    test('Fetch Products Stream List', () {
      final fakeProductRepository = makeProductRepository();
      expect(
        fakeProductRepository.watchProductsList(),
        emits(kTestProducts),
      );
    });

    test('Fetch Product(1) Stream', () {
      final fakeProductRepository = makeProductRepository();
      expect(
        fakeProductRepository.watchProduct('1'),
        emits(kTestProducts[0]),
      );
    });

    test('Watch product that is not in the list, this will return null', () {
      final fakeProductRepository = makeProductRepository();
      expect(
        fakeProductRepository.watchProduct('100'),
        emits(null),
      );
    });
  });
}
