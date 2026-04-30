const express = require('express');
const router = express.Router();

const {createSale, getAllSales, updateSales, deleteSale} = require('../controllers/salesController');

router.post('/', createSale);
router.get('/', getAllSales);
router.put('/:id', updateSales);
router.delete('/:id', deleteSale);

module.exports = router;    