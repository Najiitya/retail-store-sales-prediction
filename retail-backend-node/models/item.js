const mongoose = require('mongoose');

const itemSchema = new mongoose.Schema({
    item_id: {
        type: String,
        required: true,
        unique: true // Ensures we don't accidentally create two items with the same ID
    },
    name: {
        type: String,
        required: true
    },
    category: {
        type: String,
        required: true
    },
    price: {
        type: Number,
        required: true
    },
    current_stock: {
        type: Number,
        required: true,
        default: 0
    }
}, { 
    timestamps: true 
});

module.exports = mongoose.model('item', itemSchema);