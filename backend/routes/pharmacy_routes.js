const express = require('express');
const router = express.Router();
const { pool } = require('../database');

// Get Pharmacy Catalog
router.get('/medicines', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM medicines');
    if (rows.length === 0) {
      return res.json([
        { id: 'MED-01', name: 'Paracetamol 650mg', generic_name: 'Paracetamol', category: 'Fever & Pain', price: 32.00, original_price: 40.00, pack_size: 'Strip of 15 Tablets', requires_prescription: false },
        { id: 'MED-02', name: 'Cetirizine 10mg', generic_name: 'Cetirizine HCl', category: 'Allergy & Cold', price: 28.00, original_price: 35.00, pack_size: 'Strip of 10 Tablets', requires_prescription: false },
        { id: 'MED-03', name: 'Cough Relief Syrup', generic_name: 'Dextromethorphan', category: 'Cough Relief', price: 95.00, original_price: 120.00, pack_size: 'Bottle of 100ml', requires_prescription: false },
        { id: 'MED-04', name: 'Electrolyte ORS Sachet', generic_name: 'Oral Rehydration Salts', category: 'Hydration', price: 22.00, original_price: 25.00, pack_size: 'Sachet of 21.8g', requires_prescription: false },
        { id: 'MED-05', name: 'Amoxicillin 500mg', generic_name: 'Amoxicillin Trihydrate', category: 'Antibiotics', price: 110.00, original_price: 140.00, pack_size: 'Strip of 10 Capsules', requires_prescription: true },
        { id: 'MED-06', name: 'Vitamin C 500mg Chewable', generic_name: 'Ascorbic Acid', category: 'Immunity Boost', price: 75.00, original_price: 95.00, pack_size: 'Bottle of 60 Chewables', requires_prescription: false },
      ]);
    }
    return res.json(rows);
  } catch (err) {
    console.error('Error fetching medicines:', err.message);
    return res.status(500).json({ error: 'Failed to fetch medicines' });
  }
});

// Create 15-Minute Delivery Order
router.post('/order', (req, res) => {
  const { userId, items, totalAmount, deliveryAddress } = req.body;
  const orderId = `HE${Math.floor(10000000 + Math.random() * 90000000)}`;

  return res.json({
    message: 'Order placed for 15-minute quick delivery',
    orderId,
    status: 'out_for_delivery',
    etaMinutes: '18 mins',
    driverName: 'Ravi Kumar',
    driverPhone: '+91 9848099887',
    totalAmount,
    deliveryAddress: deliveryAddress || 'Flat 402, Green Meadows, Hitech City, Hyderabad',
  });
});

module.exports = router;
