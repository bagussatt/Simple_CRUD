const express = require('express');
const db = require('../config/database');
const jwt = require('jsonwebtoken');

const router = express.Router();

// Middleware untuk memverifikasi token
const verifyToken = (req, res, next) => {
  const token = req.headers['authorization'];
  if (!token) return res.status(403).send('Token diperlukan');

  jwt.verify(token, 'your_jwt_secret', (err, decoded) => {
    if (err) return res.status(500).send('Token tidak valid');
    req.userId = decoded.id;
    req.isAdmin = decoded.isAdmin;
    next();
  });
};

// Get all items untuk user dengan userId tertentu atau semua item jika admin
router.get('/', verifyToken, (req, res) => {
  const sql = req.isAdmin ? 'SELECT * FROM items' : 'SELECT * FROM items WHERE userId = ?';
  const params = req.isAdmin ? [] : [req.userId];
  db.query(sql, params, (err, results) => {
    if (err) throw err;
    res.json(results);
  });
});

// Get item by id yang dimiliki oleh user dengan userId tertentu atau semua item jika admin
router.get('/:id', verifyToken, (req, res) => {
  const sql = req.isAdmin ? 'SELECT * FROM items WHERE id = ?' : 'SELECT * FROM items WHERE id = ? AND userId = ?';
  const params = req.isAdmin ? [req.params.id] : [req.params.id, req.userId];
  db.query(sql, params, (err, results) => {
    if (err) throw err;
    if (!results.length) return res.status(404).json({ message: 'Item not found' });
    res.json(results[0]);
  });
});

// Create new item untuk user dengan userId tertentu
router.post('/', verifyToken, (req, res) => {
  const { name, description } = req.body;
  const sql = 'INSERT INTO items (name, description, userId) VALUES (?, ?, ?)';
  db.query(sql, [name, description, req.userId], (err, result) => {
    if (err) throw err;
    res.json({ id: result.insertId, name, description });
  });
});

// Update item yang dimiliki oleh user dengan userId tertentu atau semua item jika admin
router.put('/:id', verifyToken, (req, res) => {
  const { name, description } = req.body;
  const sql = req.isAdmin ? 'UPDATE items SET name = ?, description = ? WHERE id = ?' : 'UPDATE items SET name = ?, description = ? WHERE id = ? AND userId = ?';
  const params = req.isAdmin ? [name, description, req.params.id] : [name, description, req.params.id, req.userId];
  db.query(sql, params, (err, result) => {
    if (err) throw err;
    if (result.affectedRows === 0) return res.status(404).json({ message: 'Item not found' });
    res.json({ id: req.params.id, name, description });
  });
});

// Delete item yang dimiliki oleh user dengan userId tertentu atau semua item jika admin
router.delete('/:id', verifyToken, (req, res) => {
  const sql = req.isAdmin ? 'DELETE FROM items WHERE id = ?' : 'DELETE FROM items WHERE id = ? AND userId = ?';
  const params = req.isAdmin ? [req.params.id] : [req.params.id, req.userId];
  db.query(sql, params, (err, result) => {
    if (err) throw err;
    if (result.affectedRows === 0) return res.status(404).json({ message: 'Item not found' });
    res.json({ message: 'Item deleted' });
  });
});

// Endpoint khusus admin untuk melihat semua item
router.get('/admin/all', verifyToken, (req, res) => {
  if (!req.isAdmin) {
    return res.status(403).send('Unauthorized');
  }

  const sql = 'SELECT * FROM items';
  db.query(sql, (err, results) => {
    if (err) throw err;
    res.json(results);
  });
});

// Endpoint khusus admin untuk menghapus semua item
router.delete('/admin/all', verifyToken, (req, res) => {
  if (!req.isAdmin) {
    return res.status(403).send('Unauthorized');
  }

  const sql = 'DELETE FROM items';
  db.query(sql, (err, result) => {
    if (err) throw err;
    res.json({ message: 'All items deleted' });
  });
});

module.exports = router;
