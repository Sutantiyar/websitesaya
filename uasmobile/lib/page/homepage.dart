import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final String namaPanjang;
  final String username;
  final int idSiswa;  // Menambahkan parameter id_siswa

  HomePage({required this.namaPanjang, required this.username, required this.idSiswa});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isPresensiHadir = false;  // Status presensi (Hadir atau Tidak Hadir)
  String waktuMasuk = '';  // Menyimpan jam masuk
  String waktuPulang = '';  // Menyimpan jam pulang

  // Fungsi untuk menekan tombol presensi
  void presensi() {
    setState(() {
      if (!isPresensiHadir) {
        // Menandakan bahwa user hadir dan mencatat waktu masuk
        isPresensiHadir = true;
        waktuMasuk = TimeOfDay.now().format(context);  // Mendapatkan jam masuk saat ini
      } else {
        // Menandakan bahwa user pulang dan mencatat waktu pulang
        waktuPulang = TimeOfDay.now().format(context);  // Mendapatkan jam pulang saat ini
        isPresensiHadir = false;
      }
      // Kirimkan data absensi ke server setelah mengupdate status
      kirimDataAbsensi();
    });
  }

  // Fungsi untuk mengirim data absensi ke server
  void kirimDataAbsensi() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:3000/add-absensi'),  // Ganti dengan URL server Anda
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'id_siswa': widget.idSiswa,  // Menggunakan id_siswa yang diteruskan dari LoginPage
        'tanggal_presensi': DateTime.now().toString().split(' ')[0],  // Mendapatkan tanggal saat ini
        'jam_masuk': waktuMasuk,
        'jam_pulang': waktuPulang,
        'status_absensi': isPresensiHadir ? 'Hadir' : 'Tidak Hadir',
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data absensi berhasil ditambahkan')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menambah data absensi')));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isTablet = screenWidth >= 820 && screenHeight >= 1180;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Text(
          'Hello, ${widget.namaPanjang}',
          style: TextStyle(
            fontSize: isTablet ? 24 : 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        toolbarHeight: isTablet ? 100 : 60,
      ),
      body: SizedBox.expand(  // Menggunakan SizedBox.expand untuk mengisi seluruh area body
        child: Container(
          color: Colors.purple[50],  // Menetapkan warna latar belakang
          child: Column(
            children: [
              // Gambar yang akan ditampilkan di bawah navbar
              SizedBox(
                width: screenWidth,
                height: isTablet ? 430 : 230,  // Mengatur ukuran gambar responsif
                child: Image.asset(
                  'assets/images/StayHome.jpg',  // Ganti dengan lokasi gambar Anda
                  fit: BoxFit.cover,  // Mengatur gambar agar menyesuaikan dengan container
                ),
              ),

              SizedBox(height: isTablet ? 30 : 15),
              // Padding dan konten lainnya
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(isTablet ? 40.0 : 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Card untuk menunjukkan informasi absensi
                        SizedBox(
                          width: isTablet ? 500 : 320,  // Mengatur lebar Card
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(isTablet ? 20.0 : 3),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Presensi Status: ${isPresensiHadir ? 'HADIR' : 'TIDAK HADIR'}',
                                    style: TextStyle(fontSize: isTablet ? 24 : 16, color: Colors.black),
                                  ),
                                  Text('Waktu Masuk: $waktuMasuk', style: TextStyle(fontSize: isTablet ? 24 : 16, color: Colors.black)),
                                  Text('Waktu Pulang: $waktuPulang', style: TextStyle(fontSize: isTablet ? 24 : 16, color: Colors.black)),
                                  SizedBox(height: 20),

                                  ElevatedButton(
                                    onPressed: presensi,
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(vertical: isTablet ? 20 : 15, horizontal: isTablet ? 80 : 40),
                                      backgroundColor: Colors.purple,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Text(isPresensiHadir ? 'Pulang' : 'Hadirkan', style: TextStyle(fontSize: isTablet ? 20 : 16)),
                                  ),
                                  SizedBox(height: 20), // Jarak antar tombol
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
