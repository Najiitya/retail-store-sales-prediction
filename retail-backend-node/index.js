//load the environment from the .env
require('dotenv').config();
//import the require packages
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const sale = require('./models/sale');
const saleRoute = require('./routes/saleRoutes');
const itemRoutes = require('./routes/itemRoutes');

//initialze the express application
const app = express();

// CORS allows your Flutter frontend to communicate with this backend without security blocks
app.use(cors());
// express.json() allows your server to read incoming JSON data (like sales numbers)
app.use(express.json());

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

app.use('/api/sales', saleRoute);

app.use('/api/items', itemRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`Server is listening on PORT ${PORT}`);
});