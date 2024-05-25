import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detail.dart';
import 'kopi_data.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<JenisKopi> _kopiList = [];
  late List<JenisKopi> _filteredKopiList = [];

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchKopi();
  }

  Future<void> fetchKopi() async {
    final response = await http.get(Uri.parse('https://fake-coffee-api.vercel.app/api'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      List<JenisKopi> kopiList = jsonList.map((json) => JenisKopi.fromJson(json)).toList();
      setState(() {
        _kopiList = kopiList;
        _filteredKopiList = kopiList;
      });
    } else {
      throw Exception('Failed to load kopi');
    }
  }

  void _filterKopiList(String query) {
    setState(() {
      _filteredKopiList = _kopiList.where((kopi) {
        final name = kopi.name?.toLowerCase() ?? '';
        return name.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coffee Types'),
        backgroundColor: Colors.brown[700],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterKopiList,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredKopiList.length,
              itemBuilder: (context, index) {
                final kopi = _filteredKopiList[index];
                return Card(
                  child: ListTile(
                    title: Text(kopi.name ?? 'No name'),
                    subtitle: Text(kopi.region ?? 'No region'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JenisKopiDetailPage(jenisKopi: kopi),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
