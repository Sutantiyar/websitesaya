import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'register.dart'; // Import halaman Register
import 'package:uasmobile/page/homepage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:3000/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];
      final namaPanjang = responseData['nama_panjang'] ?? 'User';
      final username = responseData['username'] ?? 'Username';
      final idSiswa = responseData['id_siswa'];  // Menyimpan id_siswa

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login berhasil, token: $token')),
      );

      // Navigasikan ke halaman homepage dan kirimkan nama panjang, username, dan id_siswa
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(namaPanjang: namaPanjang, username: username, idSiswa: idSiswa),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login gagal!')),
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
                'Login',
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
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                    color: Colors.purple[900],
                    fontSize: isTablet ? 30 : 13,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  prefixIcon: Icon(Icons.email, color: Colors.purple[900]),
                ),
                style: TextStyle(fontSize: isTablet ? 30 : 18),
            ),
            SizedBox(height: isTablet ? 40 : 20),
            TextField(
              controller: _passwordController,
              obscureText:  !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                    color: Colors.purple[900],
                    fontSize: isTablet ? 30 : 13,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.purple[900]),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.purple[900],
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                style: TextStyle(fontSize: isTablet ? 30 : 18),
            ),
            SizedBox(height: isTablet ? 70 : 30),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: isTablet ? 25 : 20, horizontal: isTablet ? 80 : 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                elevation: 5,
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: isTablet ? 30 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: isTablet ? 40 : 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text('Belum punya akun? Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}
