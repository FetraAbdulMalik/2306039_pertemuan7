import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';

//membuat model produk
class Product {
  //initial variable
  String name;
  int price;
  String? imagePath;
  Uint8List? imageBytes; // untuk web support
  //constructor
  Product({
    required this.name,
    required this.price,
    this.imagePath,
    this.imageBytes,
  });
}

// Helper function untuk build image widget yang support web dan native
Widget buildProductImage(
  Product product, {
  double width = 80,
  double height = 80,
}) {
  if (product.imageBytes != null) {
    return Image.memory(
      product.imageBytes!,
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }

  if (product.imagePath != null) {
    try {
      return Image.file(
        File(product.imagePath!),
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    } catch (e) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: Icon(Icons.broken_image, size: 40),
      );
    }
  }

  return Container(
    width: width,
    height: height,
    color: Colors.grey[300],
    child: Icon(Icons.image, size: 40),
  );
}

void main() {
  runApp(MaterialApp(home: ProductPage()));
}

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

//class state untuk menampung isi widget
class _ProductPageState extends State<ProductPage> {
  List<Product> products = [];
  final ImagePicker _imagePicker = ImagePicker();
  String? _selectedImagePath;
  Uint8List? _selectedImageBytes;

  //funcion createdata
  void addProduct(Product product) {
    setState(() {
      products.add(product);
    });
  }

  void deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  //function untuk pick image
  Future<void> pickImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      // Baca bytes dari gambar
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImagePath = pickedFile.path;
        _selectedImageBytes = bytes;
      });
    }
  }

  // Build image preview untuk dialog
  Widget _buildImagePreview() {
    if (_selectedImageBytes != null) {
      return Image.memory(
        _selectedImageBytes!,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    }

    if (_selectedImagePath != null) {
      try {
        return Image.file(
          File(_selectedImagePath!),
          height: 150,
          width: 150,
          fit: BoxFit.cover,
        );
      } catch (e) {
        return Container(
          height: 150,
          width: 150,
          color: Colors.grey[300],
          child: Icon(Icons.broken_image, size: 50),
        );
      }
    }
    return SizedBox.shrink();
  }

  void showfrom({Product? product, int? index}) {
    TextEditingController namecontroller = TextEditingController(
      text: product?.name ?? '',
    );
    TextEditingController pricecontroller = TextEditingController(
      text: product?.price.toString() ?? '',
    );

    _selectedImagePath = product?.imagePath;
    _selectedImageBytes = product?.imageBytes;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(product == null ? 'Tambah Produk' : 'Edit Produk'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: namecontroller,
                  decoration: InputDecoration(labelText: 'Nama Produk'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: pricecontroller,
                  decoration: InputDecoration(labelText: 'Harga Produk'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 15),
                // Display selected image
                (_selectedImagePath != null || _selectedImageBytes != null)
                    ? Column(
                        children: [
                          _buildImagePreview(),
                          SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: () async {
                              await pickImage();
                              setState(() {});
                            },
                            icon: Icon(Icons.image),
                            label: Text('Ubah Gambar'),
                          ),
                        ],
                      )
                    : ElevatedButton.icon(
                        onPressed: () async {
                          await pickImage();
                          setState(() {});
                        },
                        icon: Icon(Icons.add_photo_alternate),
                        label: Text('Pilih Gambar'),
                      ),
              ],
            ),
          ),
          actions: [
            if (index != null)
              TextButton(
                onPressed: () {
                  deleteProduct(index);
                  Navigator.pop(context);
                },
                child: Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final newProduct = Product(
                  name: namecontroller.text,
                  price: int.parse(pricecontroller.text),
                  imagePath: _selectedImagePath,
                  imageBytes: _selectedImageBytes,
                );
                if (index != null) {
                  setState(() {
                    products[index] = newProduct;
                  });
                } else {
                  addProduct(newProduct);
                }
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Produk')),
      body: products.isEmpty
          ? Center(child: Text('Tidak ada produk. Tambahkan produk baru!'))
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        // Gambar produk
                        buildProductImage(product, width: 80, height: 80),
                        SizedBox(width: 12),
                        // Informasi produk
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Harga: Rp${product.price}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Tombol Edit dan Hapus
                        Column(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                showfrom(product: product, index: index);
                              },
                              tooltip: 'Edit',
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteProduct(index),
                              tooltip: 'Hapus',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _selectedImagePath = null;
          _selectedImageBytes = null;
          showfrom();
        },
        child: Icon(Icons.add),
        tooltip: 'Tambah Produk',
      ),
    );
  }
}
