class Product {
  final int id;
  final String name;
  final String imagePath;
  final int price;

  Product({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
  });
}

final List<Product> fakeProducts = [
  Product(
    id: 1,
    name: 'Laptop',
    imagePath: 'https://m.media-amazon.com/images/I/510uTHyDqGL.jpg',
    price: 2999,
  ),
  Product(
    id: 2,
    name: 'Phone',
    imagePath: 'https://m.media-amazon.com/images/I/71St1R5DFGL.jpg',
    price: 2999,
  ),
  Product(
    id: 3,
    name: 'Headphones',
    imagePath:
        'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/MUW33_AV3?wid=1144&hei=1144&fmt=jpeg&qlt=90',
    price: 2999,
  ),
];
