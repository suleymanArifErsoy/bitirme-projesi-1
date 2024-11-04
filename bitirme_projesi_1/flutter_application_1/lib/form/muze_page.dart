import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sonuç Sayfası'),
      ),
      body:  Center(
        child: FutureBuilder<String>(
          future: getHobbies(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Hata: ${snapshot.error}');
            } else {
              final String hobiler = snapshot.data ?? '';
              return Text('Hobiler: $hobiler');
            }
          },
        ),
      ),
    );
    
  }
  Future<String> getHobbies() async {
    final Box<String> hobilerBox = await Hive.openBox<String>('hobiler');
    return hobilerBox.get('hobiler') ?? '';
  }
}