const mysql = require('mysql2');

// Setup koneksi ke database
const db = mysql.createConnection({
  host: 'localhost',     // atau IP server jika menggunakan server remote
  user: 'root',          // ganti dengan username MySQL Anda
  password: '',  // ganti dengan password MySQL Anda
  database: 'myapp'      // ganti dengan nama database Anda
});

db.connect((err) => {
  if (err) {
    console.error('Error connecting to the database:', err);
    return;
  }
  console.log('Connected to the MySQL database');
});

module.exports = db;
