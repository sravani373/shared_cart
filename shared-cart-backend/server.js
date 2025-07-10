// server.js
const express = require('express');
const http = require('http');
const cors = require('cors');
const { Server } = require('socket.io');
const mongoose = require('mongoose');
const CartItem = require('./models/CartItem');
const ChatMessage = require('./models/ChatMessage');


// Replace with your MongoDB URI or use local MongoDB
mongoose.connect('mongodb+srv://sharedcartuser:shared123@cluster0.dwyxjsh.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});
//mongodb+srv://sharedcartuser:shared123@cluster0.dwyxjsh.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0

const db = mongoose.connection;
db.on('error', console.error.bind(console, '❌ MongoDB connection error:'));
db.once('open', () => {
  console.log('✅ Connected to MongoDB');
});




const app = express();
const server = http.createServer(app);
app.use(cors());

const io = new Server(server, {
  cors: {
    origin: "*",
  }
});

// let sharedCart = [];
// let chatMessages = [];

io.on("connection", (socket) => {
  console.log("User connected:", socket.id);

  // socket.emit("initial_cart", sharedCart);
  // socket.emit("initial_chat", chatMessages);
  CartItem.find().then((items) => {
  socket.emit("initial_cart", items);
});

ChatMessage.find().then((messages) => {
  socket.emit("initial_chat", messages);
});


//  socket.on("add_to_cart", async (item) => {
//   const newItem = new CartItem(item);
//   await newItem.save();

//   const updatedCart = await CartItem.find();
//   io.emit("cart_updated", updatedCart); // Sync entire cart
// });


// socket.on("add_to_cart", async (item) => {
//   const existingItem = await CartItem.findOne({ name: item.name });

//   if (existingItem) {
//     existingItem.quantity += 1;
//     await existingItem.save();
//   } else {
//     const newItem = new CartItem({ ...item, quantity: 1 });
//     await newItem.save();
//   }

//   const updatedCart = await CartItem.find();
//   io.emit("cart_updated", updatedCart);
// });

socket.on('add_to_cart', async (item) => {
  console.log('🛒 Received add_to_cart:', item);

  const existingItem = await CartItem.findOne({ name: item.name });
  if (existingItem) {
    existingItem.quantity += 1;
    await existingItem.save();
  } else {
    const newItem = new CartItem({
      name: item.name,
      imagePath: item.imagePath,
      price: item.price,
      quantity: 1,
    });
    await newItem.save();
  }

  const updatedCart = await CartItem.find();
  io.emit('cart_updated', updatedCart);
});


socket.on("update_quantity", async ({ name, change }) => {
  const item = await CartItem.findOne({ name });
  if (!item) return;

  item.quantity = (item.quantity || 1) + change;
  if (item.quantity <= 0) {
    await CartItem.deleteOne({ _id: item._id });
  } else {
    await item.save();
  }

  const updatedCart = await CartItem.find();
  io.emit("cart_updated", updatedCart);
});





socket.on("send_message", async (msg) => {
  const newMessage = new ChatMessage({
    sender: msg.sender,
    message: msg.message,
    timestamp: new Date(),
  });
  await newMessage.save();

  const updatedMessages = await ChatMessage.find();
  io.emit("chat_updated", updatedMessages); // Sync entire chat
});


  socket.on("disconnect", () => {
    console.log("User disconnected:", socket.id);
  });


  
});

app.get("/", (req, res) => {
  res.send("Shared Cart Server Running");
});

server.listen(3000, () => {
  console.log("Server running on http://localhost:3000");
});
