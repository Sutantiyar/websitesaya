import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart'; // Import halaman Login

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Fungsi untuk menangani proses registrasi
Future<void> _register() async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:3000/register'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'email': _emailController.text,
      'password': _passwordController.text,
    }),
  );

  print("Status Code: ${response.statusCode}");
  print("Response Body: ${response.body}");

  if (response.statusCode == 201) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pendaftaran berhasil!')),
    );
    Navigator.pop(context); // Kembali ke halaman login setelah berhasil
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pendaftaran gagal!')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isTablet = screenWidth >= 820 && screenHeight >= 1180;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.purple[50], // Warna latar belakang
        ),
        padding: EdgeInsets.only(
          top: isTablet ? 20.0 : 60.0, // Menambahkan margin pada teks
          left: 10.0,
          right: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Mengatur posisi kolom agar di tengah
          children: <Widget>[
            Center(
              child: Image.asset(
                'assets/images/ASW.png', // Ganti dengan path gambar yang sesuai
                height: isTablet ? 100 : 200, // Sesuaikan ukuran gambar
              ),
            ),
            SizedBox(height: isTablet ? 50 : 10),
            Align(
              alignment: Alignment.center, // Menempatkan teks di tengah
              child: Text(
                'Daftar',
                style: TextStyle(
                  fontSize: isTablet ? 48 : 28,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            SizedBox(height: isTablet ? 60 : 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Ulangi Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Daftar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Kembali ke halaman login
              },
              child: Text('Sudah punya akun? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
