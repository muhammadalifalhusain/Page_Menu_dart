import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../models/menu_model.dart';
import '../widgets/form_pembayaran.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'package:permission_handler/permission_handler.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Menu> listMenu = [];
  double totalJual = 0.0;

  // Inisialisasi NumberFormat
  final NumberFormat currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  @override
  void initState() {
    super.initState();
    listMenu = [
      Menu(nama: 'RuangTamu', deskripsi: 'Nikmati waktu berkualitas bersama orang terkasih di Sofa Keluarga Nyaman kami. Didesain dengan kenyamanan maksimal, sofa ini dilengkapi dengan bantalan empuk dan bahan berkualitas yang tahan lama. Dengan desain modern yang stylish dan pilihan warna yang beragam, sofa ini akan menjadi elemen kunci dalam menciptakan atmosfer hangat di ruang keluarga Anda. ', harga: 23000000, gambar: 'assets/images/foto1.jpg'),
      Menu(nama: 'RuangKeluarga', deskripsi: 'Elegant Room', harga: 15000000, gambar: 'assets/images/foto2.jpg'),
      Menu(nama: 'RuangSantai', deskripsi: 'Minimalist Room', harga: 18000000, gambar: 'assets/images/foto3.jpg'),
      Menu(nama: 'RuangTV', deskripsi: 'Comfortable Room', harga: 10000000, gambar: 'assets/images/foto4.jpg'),
      Menu(nama: 'KursiKekinian', deskripsi: 'Futuristik', harga: 10000000, gambar: 'assets/images/foto5.jpg'),
      Menu(nama: 'RuangKumpul', deskripsi: 'Futuristik', harga: 3000000, gambar: 'assets/images/foto3.jpg'),
    ];
  }
   Future<void> requestPermissions() async {
    await Permission.phone.request(); // Meminta izin telepon
    await Permission.sms.request();   // Meminta izin SMS
  }

  void tambahPenjualan(double harga) {
    setState(() {
      totalJual += harga;
    });
  }

 void _updateUserAndPassword() async {
  // Controllers untuk input username dan password baru
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Global key untuk form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Mendapatkan data dari SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  String? currentUsername = prefs.getString('username');
  String? currentPassword = prefs.getString('password');

  // Mengisi field dengan data lama
  _usernameController.text = currentUsername ?? '';
  _passwordController.text = currentPassword ?? '';

  // State untuk mengontrol visibilitas password
  bool _isPasswordVisible = true;

  // Menampilkan dialog untuk memasukkan username dan password baru
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Update User & Password'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: 'Username Baru'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harap isi data'; // Pesan kesalahan jika kosong
                      }
                      return null; // Tidak ada kesalahan
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password Baru',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isPasswordVisible, // Tampilkan atau sembunyikan password
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harap isi data'; // Pesan kesalahan jika kosong
                      }
                      return null; // Tidak ada kesalahan
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Simpan'),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Menyimpan username dan password baru
                    await prefs.setString('username', _usernameController.text);
                    await prefs.setString('password', _passwordController.text);
                    Navigator.of(context).pop(); // Menutup dialog
                    // Redirect ke halaman login
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  }
                },
              ),
              TextButton(
                child: Text('Batal'),
                onPressed: () {
                  Navigator.of(context).pop(); // Menutup dialog
                },
              ),
            ],
          );
        },
      );
    },
  );
}



void showDeskripsiDialog(BuildContext context, Menu menu) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Menambahkan sudut yang membulat
        ),
        child: Container(
          width: 600, // Mengatur lebar card
          padding: const EdgeInsets.all(16.0), // Padding di dalam card
          color: const Color(0xFF944645), // Mengatur warna latar belakang card
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ukuran minimal untuk kolom
            children: [
              Image.asset(
                menu.gambar,
                height: 150, // Mengatur tinggi gambar
                fit: BoxFit.cover, // Mengatur ukuran gambar
              ),
              SizedBox(height: 10), // Jarak antara gambar dan teks
              Text(
                menu.nama,
                style: TextStyle(
                  color: const Color(0xFFF0EB8F), // Mengubah warna teks nama produk
                  fontSize: 20, // Ukuran font untuk nama produk
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5), // Jarak antara nama dan deskripsi
              Text(
                menu.deskripsi,
                style: TextStyle(
                  fontSize: 16,
                  color: const Color(0xFFF0EB8F), // Mengubah warna teks deskripsi
                ), // Ukuran font untuk deskripsi
                textAlign: TextAlign.center, // Menyelaraskan teks di tengah
              ),
              SizedBox(height: 10), // Jarak sebelum tombol
              Text(
                'Harga: Rp${menu.harga}',
                style: TextStyle(
                  fontSize: 16,
                  color: const Color(0xFFF0EB8F), // Mengubah warna harga
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}


  void handleMenuOption(String value) {
    switch (value) {
      case 'Call Center':
        _showCallCenterDialog(context);
        break;
      case 'SMS Center':
        _showSmsCenterDialog(context);
        break;
      case 'Lokasi/Maps':
        _openGoogleMaps();
        break;
      case 'Update User & Password':
        _updateUserAndPassword();
        break;
      case 'Logout':
        logout(context);
        break;

    }
  }

 void _showSmsCenterDialog(BuildContext context) async {
  final String phoneNumber = '+62882006826730';
  var status = await Permission.sms.status;

  if (status.isGranted) {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
    );
    // Use launchUrl instead of launch
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak dapat membuka aplikasi SMS')),
      );
    }
  } else {
    // Jika izin belum diberikan, minta izin
    await Permission.sms.request();
    // Check status again after requesting permission
    if (await Permission.sms.isGranted) {
      final Uri smsUri = Uri(
        scheme: 'sms',
        path: phoneNumber,
      );
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      }
    }
  }
}

    void logout(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => LoginPage()),
    (Route<dynamic> route) => false,
  );
}

    void resetTotalJual() {
  setState(() {
    totalJual = 0.0;
  });
}

void _showCallCenterDialog(BuildContext context) async {
  final String phoneNumber = '+62882006826730';
  var status = await Permission.phone.status;

  if (status.isGranted) {
    final Uri telUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    // Use launchUrl instead of launch
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak dapat membuka aplikasi telepon')),
      );
    }
  } else {
    // Jika izin belum diberikan, minta izin
    await Permission.phone.request();
    // Check status again after requesting permission
    if (await Permission.phone.isGranted) {
      final Uri telUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      if (await canLaunchUrl(telUri)) {
        await launchUrl(telUri);
      }
    }
  }
}
   
  void _openGoogleMaps() async {
  const String googleMapsUrl = 'https://maps.app.goo.gl/YCXT4wbUkkGMBLqQ8'; // URL Google Maps
  final Uri url = Uri.parse(googleMapsUrl); // Membuat objek Uri dari URL

  // Menggunakan canLaunchUrl untuk memeriksa apakah URL bisa diluncurkan
  if (await canLaunchUrl(url)) {
    await launchUrl(url); // Menggunakan launchUrl untuk membuka URL
  } else {
    throw 'Could not launch $googleMapsUrl';
  }
}
  void showPaymentForm() {
  if (totalJual > 0) {
    showFormPembayaran(context, resetTotalJual);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Tidak ada total jual untuk dibayar!"),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
          'Produk ',
          style: TextStyle(
          color: const Color(0xFFF0EB8F), // Mengatur warna teks
        ),
      ),
        
        backgroundColor: const Color(0xFF944645),
        actions: [
          PopupMenuButton<String>(
            onSelected: handleMenuOption,
            itemBuilder: (BuildContext context) {
              return {'Call Center', 'SMS Center', 'Lokasi/Maps', 'Update User & Password','Logout'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3 / 4,
          ),
          itemCount: listMenu.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 5,
              color: const Color(0xFF944645),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      tambahPenjualan(listMenu[index].harga);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.asset(
                          listMenu[index].gambar,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDeskripsiDialog(context,listMenu[index]);
                          },
                          child: Text(
                            listMenu[index].nama,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFF0EB8F),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Harga: ${currencyFormat.format(listMenu[index].harga)}", // Memformat harga
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFF0EB8F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      
      
      
      bottomNavigationBar: BottomAppBar(
        child: GestureDetector(
          onTap: showPaymentForm, 
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            color: const Color(0xFF944645),
            child: Center(
              child: Text(
                '${currencyFormat.format(totalJual)}', 
                style: TextStyle(
                  color: const Color(0xFFF0EB8F),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


