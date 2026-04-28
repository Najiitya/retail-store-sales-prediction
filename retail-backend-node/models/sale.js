const mongoose = require('mongoose');

const saleSchema = new mongoose.Schema({
    store_id: {
        type: String,
        required: true
    },
    item_id: {
        type: String,
        required: true
    },
    quantity_sold: {
        type: Number,
        required: true
    },
    sale_date: {
        type: Date,
        required: true,
        default: Date.now
    },
    price: {
        type: Number,
        required: true
    }
}, { timestamps: true }); // timestamps automatically adds createdAt and updatedAt

module.exports = mongoose.model('sale', saleSchema);