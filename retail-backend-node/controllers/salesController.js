const sale = require('../models/sale');

const createSale = async (req, res) =>{
    try{
        const newSale = new sale(req.body);
        const savedSale = await newSale.save();

        res.status(201).json({
            message: "Sale added successfully!",
            data: savedSale
        });
    }catch(error){
        res.status(400).json({error: error.message});
    }
};

const getAllSales =  async (req, res) =>{
    try{
        const sales = await sale.find();
        res.status(200).json(sales);
    }catch(error){
        res.status(500).json({error: error.message});
    }
};

module.exports = {
    createSale,
    getAllSales
};