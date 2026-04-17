import 'package:flutter/material.dart';
import 'second_page.dart';
import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String name = 'product A';
  final String price = '100.000';
  final String imageUrl = 'https://picsum.photos/200/300';
  final String description =
      'ini adalah produk A dengan harga 100.000 dan gambar acak dari picsum photos yang berukuran 200x300';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(name: name, price: price, imgUrl: imageUrl),
        '/second': (context) => SecondPage(
          name: name,
          price: price,
          imgUrl: imageUrl,
          description: description,
        ),
      },
    );
  }
}
