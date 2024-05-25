import 'package:flutter/material.dart';
import 'package:responsi_123210187/database_helper.dart';
import 'package:responsi_123210187/kopi_data.dart';
import 'package:responsi_123210187/favorite.dart';

class JenisKopiDetailPage extends StatefulWidget {
  final JenisKopi jenisKopi;

  JenisKopiDetailPage({required this.jenisKopi});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<JenisKopiDetailPage> {
  late DatabaseHelper database;
  bool isFavorite = false; // State to track if the coffee is favorited

  @override
  void initState() {
    super.initState();
    database = DatabaseHelper();
    _checkFavorite(); // Check if the coffee is already favorited
  }

  Future<void> _checkFavorite() async {
    bool favoriteStatus = await database.isFavorite(widget.jenisKopi.id!);
    setState(() {
      isFavorite = favoriteStatus;
    });
  }

  Future<void> _addToFavorites(JenisKopi kopi) async {
    await database.insertFavorite(kopi);
    setState(() {
      isFavorite = true; // Update the state to reflect the coffee is favorited
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => FavoritePage()),
    );
  }

  Widget _buildTextWithBoldTitle(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4.0),
        Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: content.contains(',')
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: content.split(',').map((item) {
              return Text(item.trim());
            }).toList(),
          )
              : Text(content.trim()),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final kopi = widget.jenisKopi;
    return Scaffold(
      appBar: AppBar(
        title: Text(kopi.name ?? 'Detail Kopi'),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null, // Color the icon if favorited
            ),
            onPressed: () async {
              if (!isFavorite) {
                await _addToFavorites(kopi);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                child: Image.network(
                  kopi.imageUrl ?? '',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                kopi.name ?? '',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              _buildTextWithBoldTitle('Description', kopi.description ?? ''),
              SizedBox(height: 8.0),
              _buildTextWithBoldTitle('Region', kopi.region ?? ''),
              SizedBox(height: 8.0),
              _buildTextWithBoldTitle('Price', '\$${kopi.price?.toStringAsFixed(2) ?? ''}'),
              SizedBox(height: 8.0),
              _buildTextWithBoldTitle('Weight', '${kopi.weight ?? ''}'),
              SizedBox(height: 8.0),
              _buildTextWithBoldTitle('Flavor Profile', kopi.flavorProfile?.join(', ') ?? ''),
              SizedBox(height: 8.0),
              _buildTextWithBoldTitle('Grind Options', kopi.grindOption?.join(', ') ?? ''),
              SizedBox(height: 8.0),
              _buildTextWithBoldTitle('Roast Level', '${kopi.roastLevel ?? ''}'),
            ],
          ),
        ),
      ),
    );
  }
}