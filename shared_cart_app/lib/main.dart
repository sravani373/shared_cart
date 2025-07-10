import 'package:flutter/material.dart';
import 'screens/product_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/chat_screen.dart';
import 'services/socket_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SocketService _socketService = SocketService();
  List cartItems = [];
  List chatMessages = [];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _socketService.connect(
      (cart) => setState(() => cartItems = cart),
      (chat) => setState(() => chatMessages = chat),
    );
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      ProductScreen(socketService: _socketService),
      //CartScreen(cartItems: cartItems),
      CartScreen(
        cartItems: cartItems,
        socketService: _socketService,
      ),

      ChatScreen(
        chatMessages: chatMessages,
        socketService: _socketService,
      ),
    ];

    return MaterialApp(
      title: 'Shared Cart App',
      home: Scaffold(
        appBar: AppBar(title: Text('Shared Cart')),
        body: pages[_selectedIndex],
        // bottomNavigationBar: BottomNavigationBar(
        //   currentIndex: _selectedIndex,
        //   onTap: _onItemTapped,
        //   items: const [
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.shopping_bag),
        //       label: 'Products',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.shopping_cart),
        //       label: 'Cart',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.chat),
        //       label: 'Chat',
        //     ),
        //   ],
        // ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Products',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.shopping_cart),
                  if (cartItems.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cartItems.fold<int>(0, (sum, item) => sum + ((item['quantity'] ?? 1) as int))}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
          ],
        ),
      ),
    );
  }
}
