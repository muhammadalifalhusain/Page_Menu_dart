import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../models/menu_model.dart';
import '../widgets/form_pembayaran.dart';
import 'package:url_launcher/url_launcher.dart';

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
      Menu(nama: 'Interior1', deskripsi: 'Klasikal Room', harga: 20000, gambar: 'assets/images/foto1.jpg'),
      Menu(nama: 'Interior2', deskripsi: 'Elegant Room', harga: 15000, gambar: 'assets/images/foto2.jpg'),
      Menu(nama: 'Interior3', deskripsi: 'Minimalist Room', harga: 18000, gambar: 'assets/images/foto3.jpg'),
      Menu(nama: 'Interior4', deskripsi: 'Comfortable Room', harga: 25000, gambar: 'assets/images/foto4.jpg'),
      Menu(nama: 'Interior5', deskripsi: 'Futuristik', harga: 3000, gambar: 'assets/images/foto5.jpg'),
    ];
  }

  void tambahPenjualan(double harga) {
    setState(() {
      totalJual += harga;
    });
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
        print('Menghubungi Call Center...');
        break;
      case 'SMS Center':
        print('Mengirim SMS...');
        break;
      case 'Lokasi/Maps':
        _openGoogleMaps();
        break;
      case 'Update User & Password':
        print('Update User & Password...');
        break;
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
        title: Text('Produk :'),
        backgroundColor: Colors.deepOrangeAccent,
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
                              color: Colors.deepOrangeAccent,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Harga: ${currencyFormat.format(listMenu[index].harga)}", // Memformat harga
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
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
            color: Colors.deepOrangeAccent,
            child: Center(
              child: Text(
                'Pembayaran: ${currencyFormat.format(totalJual)}', 
                style: TextStyle(
                  color: Colors.white,
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


