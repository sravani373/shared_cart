const mongoose = require('mongoose');

const CartItemSchema = new mongoose.Schema({
  id: Number,
  name: String,
  quantity: { type: Number, default: 1 },
  price: Number, // 💰
  imagePath: String,
});

module.exports = mongoose.model('CartItem', CartItemSchema);
