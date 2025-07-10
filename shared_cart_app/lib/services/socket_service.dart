import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void connect(
    Function(List) onCartUpdated,
    Function(List) onChatUpdated,
  ) {
    socket = IO.io('mongodb+srv://sharedcartuser:shared123@cluster0.dwyxjsh.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    //sharedcartuser:shared123

    socket.onConnect((_) {
      print('✅ Socket connected: ${socket.id}');

      // Listen for initial cart
      socket.on('initial_cart', (data) {
        print('📥 Received initial_cart: $data');
        onCartUpdated(List<Map<String, dynamic>>.from(data));
      });

      // Listen for initial chat
      socket.on('initial_chat', (data) {
        print('📥 Received initial_chat: $data');
        onChatUpdated(List<Map<String, dynamic>>.from(data));
      });

      // Listen for cart updates
      socket.on('cart_updated', (data) {
        print('🔄 Received cart_updated: $data');
        onCartUpdated(List<Map<String, dynamic>>.from(data));
      });

      // Listen for chat updates
      socket.on('chat_updated', (data) {
        print('🔄 Received chat_updated: $data');
        onChatUpdated(List<Map<String, dynamic>>.from(data));
      });
    });

    socket.onDisconnect((_) {
      print('❌ Socket disconnected');
    });
  }

  void addToCart(Map<String, dynamic> item) {
    print('➡️ Sending to add_to_cart: $item');
    socket.emit('add_to_cart', item);
  }

  void sendMessage(String message) {
    final msg = {
      'sender': 'User',
      'message': message,
      'timestamp': DateTime.now().toString(),
    };
    print('➡️ Sending message: $msg');
    socket.emit('send_message', msg);
  }

  void updateQuantity(String name, int change) {
    socket.emit('update_quantity', {
      'name': name,
      'change': change,
    });
  }
}
