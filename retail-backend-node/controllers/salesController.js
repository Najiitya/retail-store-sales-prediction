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

const updateSales = async (req, res) =>{
    try{
        const updateSale = await sale.findByIdAndUpdate(req.params.id, req.body, {new: true});

        if(!updateSale){
            return res.status(404).json({message: "Sale not found"});
        }
        res.status(200).json({message: "Sale updated succesfully!", data: updateSale});
    }catch(error){
        res.status(500).json({error: error.message});
    }
};

const deleteSale = async (req, res) =>{
    try{
        const deleteSale = await sale.findByIdAndDelete(req.params.id);

        if(!deleteSale){
            return res.status(404).json({message: "Sale not found"});
        }
        res.status(200).json({message: "Sale deleted successfully"});
    }catch(error){
        res.status(500).json({error: error.message});
    }
};

module.exports = {
    createSale,
    getAllSales,
    updateSales,
    deleteSale
};