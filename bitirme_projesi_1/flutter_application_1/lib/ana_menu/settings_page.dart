import 'package:flutter/material.dart';
import 'package:bitirme_projesi/form/form_page.dart';
import 'package:bitirme_projesi/form/muze_page.dart';

// ignore: must_be_immutable
class SettingsPage extends StatelessWidget {
  

  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: const Text('Hobileri Görüntüle'),
            onTap: () {
              Navigator.pop(context); // Ayarlar sayfasını kapat
              Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => const ResultPage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Hobilerimi Değiştir'),
            onTap: () {
              Navigator.pop(context); // Ayarlar sayfasını kapat
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FormPage(),
                ),
              );
            },
          ),
          // Diğer ayarlar eklenebilir
        ],
      ),
    );
  }
}