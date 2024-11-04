import 'package:flutter/material.dart';

void showFormPembayaran(BuildContext context, VoidCallback resetTotalJual) {
  final _formKey = GlobalKey<FormState>();
  String? namaPembeli;
  String? nomorTelepon;
  String? metodePembayaran;

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Form Pembayaran",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Nama Pembeli",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Pembeli tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) {
                  namaPembeli = value;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Nomor Telepon",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor Telepon tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) {
                  nomorTelepon = value;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Metode Pembayaran",
                  border: OutlineInputBorder(),
                ),
                items: ["Cash", "Kartu Kredit", "Transfer Bank"]
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  metodePembayaran = value;
                },
                validator: (value) {
                  if (value == null) {
                    return 'Metode Pembayaran harus dipilih';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Pembayaran berhasil!",
                        style: TextStyle(
                        color: Colors.yellow, // Mengatur warna teks menjadi kuning
                        ),
                        ),
                        
                        backgroundColor: const Color(0xFF944645),
                      ),
                    );

                    // Panggil fungsi reset totalJual setelah pembayaran berhasil
                    resetTotalJual();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Harap lengkapi semua field!"),
                        
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Center(child: Text("Bayar Sekarang")),
              ),
            ],
          ),
        ),
      );
    },
  );
}
