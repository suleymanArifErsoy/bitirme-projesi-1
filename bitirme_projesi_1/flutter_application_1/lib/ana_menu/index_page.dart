import 'package:bitirme_projesi/form/form_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:bitirme_projesi/ana_menu/settings_page.dart';
import 'package:bitirme_projesi/text_toSpeech/tts.dart';
import 'package:bitirme_projesi/ana_menu/muze_fotograflari.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int currentImageIndex = 0;
  List<String> selectedHobbies = [];

  @override
  void initState() {
    super.initState();
    _loadSelectedHobbies();
  }

  @override
  void didUpdateWidget(covariant IndexPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadSelectedHobbies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
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
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: selectedHobbies.length,
              controller: PageController(initialPage: currentImageIndex),
              onPageChanged: (index) {
                setState(() {
                  currentImageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                String museum = selectedHobbies[index];

                // Kullanıcının seçtiği hobiler arasında müze adı varsa göster
                if (selectedHobbies.any((hobby) => museum.contains(hobby.toLowerCase()))) {
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
                        Expanded(
                          child: Card(
                            child: Image.asset(
                              'lib/assets/images/$museum/1.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Seçilen hobiler arasında müze adı yoksa boş bir Container döndür
                  return Container();
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  _showPreviousImage();
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  _showNextImage();
                },
              ),
              ElevatedButton(
                onPressed: () {
                  _navigateToTextToSpeechPage(context);
                },
                child: const Text('Text to Speech'),
              ),
              ElevatedButton(
                onPressed: () {
                  _navigateToFormPage(context);
                },
                child: const Text('Go to Form Page'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _loadSelectedHobbies() async {
    final Box<String> hobilerBox = await Hive.openBox<String>('hobiler');
    final String hobiler = hobilerBox.get('hobiler') ?? '';
    setState(() {
      selectedHobbies = hobiler.split(', ');
    });
  }

  void _navigateToFormPage(BuildContext context) async {
    final updatedHobbies = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FormPage(),
      ),
    );

    // Eğer updatedHobbies null değilse, yani bir güncelleme yapıldıysa
    if (updatedHobbies != null) {
      setState(() {
        selectedHobbies = updatedHobbies;
      });
    }
  }

  void _showNextImage() {
    setState(() {
      currentImageIndex = (currentImageIndex + 1) % selectedHobbies.length;
    });
  }

  void _navigateToTextToSpeechPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Text_to_speech(),
      ),
    );
  }

  void _showPreviousImage() {
    setState(() {
      currentImageIndex = (currentImageIndex - 1 + selectedHobbies.length) % selectedHobbies.length;
    });
  }
}