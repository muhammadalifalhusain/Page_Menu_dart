import 'package:flutter/material.dart';

// Definisi kelas Menu
class Menu {
  final String nama;
  final String deskripsi;
  final int harga;
  final String gambar;

  Menu({
    required this.nama,
    required this.deskripsi,
    required this.harga,
    required this.gambar,
  });
}

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Menu> listMenu = [];
  double totalHarga = 0.0;

  @override
  void initState() {
    super.initState();
    listMenu = [
      Menu(
        nama: 'Interior1',
        deskripsi: 'Klasikal Room',
        harga: 20000,
        gambar: 'assets/images/foto1.jpg',
      ),
      Menu(
        nama: 'Interior2',
        deskripsi: 'Elegant Room',
        harga: 15000,
        gambar: 'assets/images/foto2.jpg',
      ),
      Menu(
        nama: 'Interior3',
        deskripsi: 'Minimalist Room',
        harga: 18000,
        gambar: 'assets/images/foto3.jpg',
      ),
      Menu(
        nama: 'Interior4',
        deskripsi: 'Comfortable Room',
        harga: 25000,
        gambar: 'assets/images/foto4.jpg',
      ),
      Menu(
        nama: 'Interior5',
        deskripsi: 'Futuristik',
        harga: 3000,
        gambar: 'assets/images/foto5.jpg',
      ),
    ];
  }

  void updateTotalHarga(double harga) {
    setState(() {
      totalHarga += harga;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produk Kami'),
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 4,
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
            return GestureDetector(
              onTap: () {
                updateTotalHarga(listMenu[index].harga.toDouble());
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.asset(
                          listMenu[index].gambar,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            listMenu[index].nama,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrangeAccent,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            listMenu[index].deskripsi,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black.withOpacity(0.7),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis, 
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Harga: Rp ${listMenu[index].harga}",
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
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          color: Colors.deepOrangeAccent,
          child: Center(
            child: Text(
              'Total Harga: Rp. ${totalHarga.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
