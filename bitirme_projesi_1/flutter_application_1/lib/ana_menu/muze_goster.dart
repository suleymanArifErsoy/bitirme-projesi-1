import 'package:bitirme_projesi/ana_menu/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MuzeGoster extends StatelessWidget {
  final List<String> selectedHobbies;

  const MuzeGoster({Key? key, required this.selectedHobbies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Müzeler'),
         actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getFilteredMuseums(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else {
            List<String> filteredMuseums = (snapshot.data as List<String?>).whereType<String>().toList();
            return ListView.builder(
              itemCount: filteredMuseums.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _navigateToMuseumDetailPage(context, filteredMuseums[index]);
                  },
                  child: Image.asset(
                    'lib/assets/images/${filteredMuseums[index]}/1.jpg',
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<String?>?> _getFilteredMuseums() async {
    final Box<String> hobilerBox = await Hive.openBox<String>('hobiler');
    String? hobiler = hobilerBox.get('hobiler', defaultValue: '');

    List<String>? userHobbies = hobiler?.split(', ');
    Map<String, String> museumHobbies = {
      "arkeoloji": "arkeoloji",
      "sanat": "sanat",
      "tarih": "tarih",
      "etnografya": "etnografya",
    };

    List<String?>? filteredMuseums = userHobbies
        ?.map((hobby) => museumHobbies[hobby])
        .where((museum) => museum != null)
        .toList();

    return filteredMuseums;
  }

  void _navigateToMuseumDetailPage(BuildContext context, String museumName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MuseumDetailPage(museumName: museumName),
      ),
    );
  }
}

class MuseumDetailPage extends StatelessWidget {
  final String museumName;

  const MuseumDetailPage({Key? key, required this.museumName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(museumName),
      ),
      body: FutureBuilder(
        future: _getMuseumImages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else {
            List<String> museumImages = snapshot.data as List<String>;
            return ListView.builder(
              itemCount: museumImages.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  'lib/assets/images/$museumName/${museumImages[index]}',
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<String>> _getMuseumImages() async {
    // Burada, müzenin tüm fotoğraflarının dosya adlarını alabilirsiniz.
    // Örneğin, assets/images/muze_adı/1.jpg, assets/images/muze_adı/2.jpg, ...
    return List.generate(9, (index) => '${index + 1}.jpg');
  }
}