//load the environment from the .env
require('dotenv').config();
//import the require packages
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const sale = require('./models/sale');

//initialze the express application
const app = express();

// CORS allows your Flutter frontend to communicate with this backend without security blocks
app.use(cors());
// express.json() allows your server to read incoming JSON data (like sales numbers)
app.use(express.json());
console.log("My URI is: ", process.env.MONGO_URI);
//conect mongodb using mongoose
mongoose.connect(process.env.MONGO_URI)
    .then(() => {
        console.log('Connected to MongoDB successfully!');
    })
    .catch((error) => {
        console.error('Error connecting to MongoDB:', error.message);
    });

app.get('/', (req, res) => {
    res.json({
        status: "success",
        message: "Retail backend is Running"
    });
});

//create a new scheme
app.post('/api/sales', async (req, res) => {
    try{
        const newSale = new sale(req.body);

        const savedSale = await newSale.save();

        res.status(201).json({
            message: "Sale added successfully!",
            data: savedSale
        });

    }catch(error){
        res.status(400).json({ error: error.message });
    }
});

app.get('/api/sales', async (req, res) => {
    try {
        // Find all records in the Sales collection
        const sales = await sale.find();
        res.status(200).json(sales);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`Server is listening on PORT ${PORT}`);
});