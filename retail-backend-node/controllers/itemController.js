const item = require('../models/item');

// Create a new item
const createItem = async (req, res) => {
    try {
        const newItem = new item(req.body);
        const savedItem = await newItem.save();
        res.status(201).json({ message: "Item added successfully!", data: savedItem });
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

// Get all items
const getAllItems = async (req, res) => {
    try {
        const items = await item.find();
        res.status(200).json(items);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Update an item (like changing the stock or price)
const updateItem = async (req, res) => {
    try {
        const updatedItem = await item.findByIdAndUpdate(req.params.id, req.body, { new: true });
        if (!updatedItem) return res.status(404).json({ message: "Item not found" });
        res.status(200).json({ message: "Item updated!", data: updatedItem });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Delete an item
const deleteItem = async (req, res) => {
    try {
        const deletedItem = await item.findByIdAndDelete(req.params.id);
        if (!deletedItem) return res.status(404).json({ message: "Item not found" });
        res.status(200).json({ message: "Item deleted!" });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

module.exports = { createItem, getAllItems, updateItem, deleteItem };