import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String name;
  final String price;
  final String imgUrl;
  HomePage({required this.name, required this.price, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('halaman utama'),
        backgroundColor: const Color.fromARGB(255, 64, 255, 204),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(imgUrl, width: 200, height: 300, fit: BoxFit.cover),
          Text(
            'Harga: $price',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'Nama: $name',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text('lihat detail', style: TextStyle(fontSize: 14)),
            onPressed: () {
              Navigator.pushNamed(context, '/second');
            },
          ),
        ],
      ),
    );
  }
}
