import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/socket_service.dart';

class ProductScreen extends StatelessWidget {
  final SocketService socketService;

  const ProductScreen({required this.socketService});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: fakeProducts.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) {
        final product = fakeProducts[index];
        return Card(
          child: Column(
            children: [
              Image.network(
                product.imagePath,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image),
              ),
              Text(product.name),
              ElevatedButton(
                onPressed: () => socketService.addToCart({
                  'name': product.name,
                  'imagePath': product.imagePath,
                  'price': product.price, // 💰
                }),
                child: const Text("Add to Cart"),
              ),
            ],
          ),
        );
      },
    );
  }
}
