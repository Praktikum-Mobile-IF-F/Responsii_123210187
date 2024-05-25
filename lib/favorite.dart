import 'package:flutter/material.dart';
import 'package:responsi_123210187/database_helper.dart';
import 'package:responsi_123210187/kopi_data.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoritePage> {
  late List<JenisKopi> favoriteKopis = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteKopis();
  }

  Future<void> _loadFavoriteKopis() async {
    List<JenisKopi> favorites = await DatabaseHelper().getFavorites();
    setState(() {
      favoriteKopis = favorites;
    });
  }

  Future<void> _removeFavorite(JenisKopi jenisKopi) async {
    await DatabaseHelper().removeFavorite(jenisKopi.id!);
    await _loadFavoriteKopis(); // Refresh the favorite list after removal
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Kopis'),
      ),
      body: ListView.builder(
        itemCount: favoriteKopis.length,
        itemBuilder: (context, index) {
          final kopi = favoriteKopis[index];
          return ListTile(
            title: Text(kopi.name ?? 'No name'),
            subtitle: Text(kopi.region ?? 'No region'),
            trailing: IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () async {
                await _removeFavorite(kopi);
              },
            ),
          );
        },
      ),
    );
  }
}
