
import 'package:bitirme_projesi/ana_menu/index_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Hive'ı Flutter ile entegre etmek için

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive'ı başlat
  await Hive.initFlutter();

  // Hive kutusunu aç
  await Hive.openBox<String>('hobiler');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      title: 'Flutter Hobiler Formu',
      home: IndexPage(),
    );
  }
}