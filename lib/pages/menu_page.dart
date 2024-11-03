import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../models/menu_model.dart';
import '../widgets/form_pembayaran.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

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
      Menu(nama: 'RuangTamu', deskripsi: 'Klasikal Room', harga: 23000000, gambar: 'assets/images/foto1.jpg'),
      Menu(nama: 'RuangKeluarga', deskripsi: 'Elegant Room', harga: 15000000, gambar: 'assets/images/foto2.jpg'),
      Menu(nama: 'RuangSantai', deskripsi: 'Minimalist Room', harga: 18000000, gambar: 'assets/images/foto3.jpg'),
      Menu(nama: 'RuangTV', deskripsi: 'Comfortable Room', harga: 10000000, gambar: 'assets/images/foto4.jpg'),
      Menu(nama: 'KursiKekinian', deskripsi: 'Futuristik', harga: 10000000, gambar: 'assets/images/foto5.jpg'),
      Menu(nama: 'RuangKumpul', deskripsi: 'Futuristik', harga: 3000000, gambar: 'assets/images/foto3.jpg'),
    ];
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

  // Menampilkan dialog untuk memasukkan username dan password baru
  showDialog(
    context: context,
    builder: (BuildContext context) {
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
                decoration: InputDecoration(labelText: 'Password Baru'),
                obscureText: true,
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
                final prefs = await SharedPreferences.getInstance();
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
}


  void showDeskripsiDialog(Menu menu) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(menu.nama),
          content: Text(menu.deskripsi),
          actions: [
            TextButton(
              child: Text("Tutup"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
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
    }
  }

 void _showSmsCenterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('SMS Center'),
          content: Text('0802-3456-7870'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
          ],
        );
      },
    );
  }

    void _showCallCenterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Call Center'),
          content: Text('0812-3456-7890'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
          ],
        );
      },
    );
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
      showFormPembayaran(context);
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
              return {'Call Center', 'SMS Center', 'Lokasi/Maps', 'Update User & Password'}
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
                            showDeskripsiDialog(listMenu[index]);
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


