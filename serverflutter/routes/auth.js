const express = require('express');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const db = require('../config/database');

const router = express.Router();

router.post('/register', (req, res) => {
  const { username, password } = req.body;
  
  // Validasi input
  if (!username || !password) {
    return res.status(400).send('Please provide username and password');
  }
  
  // Hash password
  const hashedPassword = bcrypt.hashSync(password, 8);

  // Insert into database
  const query = 'INSERT INTO users (username, password) VALUES (?, ?)';
  db.query(query, [username, hashedPassword], (err, results) => {
    if (err) {
      console.error('Error registering user:', err); // Log error here
      return res.status(500).send('Failed to register user');
    }

    // Generate token
    const token = jwt.sign({ id: results.insertId, isAdmin: false }, 'your_jwt_secret', {
      expiresIn: 86400, // expires in 24 hours
    });

    // Send response with token
    res.status(201).send({ auth: true, token });
  });
});
// Login
router.post('/login', (req, res) => {
  const { username, password } = req.body;
  let isAdmin = false; // Initialize isAdmin variable

  // Query user from database
  const sql = 'SELECT * FROM users WHERE username = ?';
  db.query(sql, [username], (err, results) => {
    if (err) {
      console.error('Error querying user:', err);
      return res.status(500).send('There was a problem on the server.');
    }
    if (!results.length) {
      return res.status(404).send('No user found.');
    }

    // Validate password
    const user = results[0];
    const passwordIsValid = bcrypt.compareSync(password, user.password);
    if (!passwordIsValid) {
      return res.status(401).send({ auth: false, token: null });
    }

    // Set isAdmin if username is 'admin'
    if (user.username === 'admin') {
      isAdmin = true;
    }

    // Generate token
    const token = jwt.sign({ id: user.id, isAdmin }, 'your_jwt_secret', { expiresIn: 86400 }); // expires in 24 hours
    res.status(200).send({ auth: true, token });
  });
});

// Logout
router.post('/logout', (req, res) => {
  // In a stateless authentication system, client handles token removal
  res.status(200).send({ auth: false, token: null });
});

module.exports = router;
