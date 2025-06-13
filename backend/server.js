const express = require('express');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const bodyParser = require('body-parser');
const db = require('./db'); // Import koneksi database

const app = express();
const port = 3000;

// Gunakan CORS middleware
app.use(cors());

// Middleware untuk meng-handle request body
app.use(bodyParser.json());

// Endpoint untuk mendaftar pengguna
app.post('/register', (req, res) => {
    const { email, password } = req.body;
  
    if (!email || !password) {
      return res.status(400).send('Email dan password wajib diisi');
    }
  
    const query = 'INSERT INTO Pengguna (email, password) VALUES (?, ?)';
  
    const hashedPassword = bcrypt.hashSync(password, 10);
  
    db.query(query, [email, hashedPassword], (err, result) => {
      if (err) {
        console.error('Error inserting data:', err);
        return res.status(500).send('Gagal mendaftar pengguna');
      }
      res.status(201).send('Pendaftaran berhasil');
    });
});

// Endpoint untuk login pengguna
app.post('/login', (req, res) => {
    const { email, password } = req.body;
  
    if (!email || !password) {
      return res.status(400).send('Email dan password wajib diisi');
    }
  
    const query = 'SELECT * FROM Pengguna WHERE email = ?';
  
    db.query(query, [email], (err, results) => {
      if (err) {
        console.error('Error querying database:', err);
        return res.status(500).send('Gagal login');
      }
  
      if (results.length === 0) {
        return res.status(401).send('Email atau password salah');
      }
  
      const user = results[0];
  
      if (!bcrypt.compareSync(password, user.password)) {
        return res.status(401).send('Email atau password salah');
      }
  
      const token = jwt.sign(
        { 
          id: user.id_siswa, 
          role: user.role, 
          nama_panjang: user.nama_panjang, 
          username: user.username
        },
        'secret_key',
        { expiresIn: '1h' }
      );
  
      res.json({
        token,
        nama_panjang: user.nama_panjang,
        username: user.username,
        id_siswa: user.id_siswa  // Pastikan id_siswa dikirim
      });
    });
});

// Endpoint untuk menambah data absensi
app.post('/add-absensi', (req, res) => {
  const { id_siswa, tanggal_presensi, jam_masuk, jam_pulang, status_absensi } = req.body;

  if (!id_siswa || !tanggal_presensi || !jam_masuk || !jam_pulang) {
    return res.status(400).send('Semua field absensi harus diisi');
  }

  // Tentukan status absensi
  let statusAbsensi = 'Tidak Hadir'; // Default status

  // Jika jam masuk dan jam pulang ada, set status menjadi Hadir
  if (jam_masuk != null && jam_pulang != null) {
    statusAbsensi = 'Hadir';
  }

  const query = 'INSERT INTO Absensi (id_siswa, tanggal_presensi, jam_masuk, jam_pulang, status_absensi) VALUES (?, ?, ?, ?, ?)';

  db.query(query, [id_siswa, tanggal_presensi, jam_masuk, jam_pulang, statusAbsensi], (err, result) => {
    if (err) {
      console.error('Error inserting data into Absensi:', err);
      return res.status(500).send('Gagal menambah data absensi');
    }
    res.status(201).send('Data absensi berhasil ditambahkan');
  });
});


// Endpoint untuk menambah data lokasi
app.post('/add-lokasi', (req, res) => {
  const { id_absensi, alamat, lat, lng } = req.body;

  if (!id_absensi || !alamat || !lat || !lng) {
    return res.status(400).send('Semua field lokasi harus diisi');
  }

  const query = 'INSERT INTO Lokasi (id_absensi, alamat, lat, lng) VALUES (?, ?, ?, ?)';

  db.query(query, [id_absensi, alamat, lat, lng], (err, result) => {
    if (err) {
      console.error('Error inserting data into Lokasi:', err);
      return res.status(500).send('Gagal menambah data lokasi');
    }
    res.status(201).send('Data lokasi berhasil ditambahkan');
  });
});

// Menjalankan server
app.listen(port, () => {
  console.log(`Server berjalan di http://localhost:${port}`);
});
