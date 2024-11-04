import 'package:bitirme_projesi/ana_menu/muze_fotograflari.dart';
import 'package:flutter/material.dart';

class IlkFotoGoster extends StatefulWidget {
  const IlkFotoGoster({super.key});

  @override
  State<IlkFotoGoster> createState() => _IlkFotoGosterState();
}

class _IlkFotoGosterState extends State<IlkFotoGoster> {
  final List<String> museums = [
    "arkeoloji",
    "etnografya",
    "sanat",
    "tarih",
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: museums.length,
        itemBuilder: (context, index) {
          String museum = museums[index];
          String imagePath = 'lib/assets/images/$museum/1.jpg';

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MuzeFotograflari(museumPath: museum),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  museum,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Card(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          );
        },
      );
  }
}