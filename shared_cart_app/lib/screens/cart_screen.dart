// import 'package:flutter/material.dart';

// class CartScreen extends StatelessWidget {
//   final List cartItems;

//   const CartScreen({super.key, required this.cartItems});

//   @override
//   Widget build(BuildContext context) {
//     // 🔢 Group items by name, and track imagePath + quantity
//     final Map<String, Map<String, dynamic>> groupedItems = {};

//     for (var item in cartItems) {
//       final name = item['name'] ?? 'Unknown';
//       final imagePath = item['imagePath'];

//       if (groupedItems.containsKey(name)) {
//         groupedItems[name]!['quantity'] += 1;
//       } else {
//         groupedItems[name] = {
//           'imagePath': imagePath,
//           'quantity': 1,
//         };
//       }
//     }

//     final groupedList = groupedItems.entries.toList();

//     return ListView.builder(
//       itemCount: groupedList.length,
//       itemBuilder: (_, i) {
//         final name = groupedList[i].key;
//         final imagePath = groupedList[i].value['imagePath'];
//         final quantity = groupedList[i].value['quantity'];

//         return ListTile(
//           leading: imagePath != null
//               ? Image.network(
//                   imagePath,
//                   width: 50,
//                   height: 50,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) =>
//                       const Icon(Icons.broken_image),
//                 )
//               : const Icon(Icons.shopping_bag),
//           title: Text(
//             '$name x$quantity',
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../services/socket_service.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatelessWidget {
  final List cartItems;
  final SocketService socketService;

  const CartScreen({
    super.key,
    required this.cartItems,
    required this.socketService,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    // Group by name, imagePath, and price
    final Map<String, Map<String, dynamic>> groupedItems = {};

    for (var item in cartItems) {
      final name = item['name'] ?? 'Unknown';
      final imagePath = item['imagePath'];
      //final price = double.tryParse('${item['price'] ?? 0}') ?? 0;
      final priceRaw = item['price'];
      final price = (priceRaw is num)
          ? priceRaw.toDouble()
          : double.tryParse('$priceRaw') ?? 0.0;
      final quantity = item['quantity'] ?? 1; // ✅ Use backend quantity

      if (groupedItems.containsKey(name)) {
        groupedItems[name]!['quantity'] += 1;
      } else {
        groupedItems[name] = {
          'imagePath': imagePath,
          'price': price,
          'quantity': quantity,
        };
      }
    }

    final groupedList = groupedItems.entries.toList();

    // Calculate total cart value
    double total = groupedList.fold(0, (sum, entry) {
      final item = entry.value;
      return sum + (item['price'] * item['quantity']);
    });

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: groupedList.length,
            itemBuilder: (_, i) {
              final name = groupedList[i].key;
              final imagePath = groupedList[i].value['imagePath'];
              final price = groupedList[i].value['price'];
              final quantity = groupedList[i].value['quantity'];

              return ListTile(
                leading: imagePath != null
                    ? Image.network(
                        imagePath,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image),
                      )
                    : const Icon(Icons.shopping_bag),
                title: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  //'₹${price.toStringAsFixed(2)} x $quantity = ₹${(price * quantity).toStringAsFixed(2)}',
                  '${currencyFormatter.format(price)} x $quantity = ${currencyFormatter.format(price * quantity)}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        socketService.updateQuantity(name, -1);
                      },
                    ),
                    Text('$quantity'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        socketService.updateQuantity(name, 1);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Total: ${currencyFormatter.format(total)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
