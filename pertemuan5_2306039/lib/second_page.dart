import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  //widgetbuilder overide build
  final String name;
  final String price;
  final String imgUrl;
  final String description;

  const SecondPage({
    required this.name,
    required this.price,
    required this.imgUrl,
    required this.description,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("halaman kedua"),
        backgroundColor: const Color.fromARGB(255, 64, 255, 204),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imgUrl,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
          ),
          Text(
            name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            price,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(description, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
