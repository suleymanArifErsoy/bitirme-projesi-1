import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;

class MuzeFotograflari extends StatefulWidget {
  final String museumPath;

  const MuzeFotograflari({required this.museumPath});

  @override
  _MuzeFotograflariState createState() => _MuzeFotograflariState();
}

class _MuzeFotograflariState extends State<MuzeFotograflari> {
  late PageController _pageController;
  int _currentPage = 0;

  final subscriptionKey = "f11954c7372a44cd8918220a2fac5d52";
  final endpoint = "https://virtualmuseumfrance.cognitiveservices.azure.com";
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    // Otomatik kaydırma işlemi
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 10), () {
      if (_currentPage < _getTotalImages() - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      _startAutoScroll();
    });
  }

  Future<void> _analyzeImage(int imageIndex) async {
    // Azure Vision API'nin describe metodu için uç nokta
    final uriBase = '$endpoint/vision/v3.1/describe';

    // API isteği için başlık oluştur
    final headers = {
      'Content-Type': 'application/json',
      'Ocp-Apim-Subscription-Key': subscriptionKey,
    };

    // API isteği için veri oluştur
    final imageAssetPath =
        'lib/assets/images/${widget.museumPath}/$imageIndex.jpg';
    final imageBytes = await _loadImageBytes(imageAssetPath);
    final base64Image = base64Encode(imageBytes);

    final Map<String, dynamic> body = {
      'data': base64Image,
    };

    // API isteği gönder
    final response = await http.post(Uri.parse(uriBase),
        headers: headers, body: jsonEncode(body));

    // İsteğin başarılı olup olmadığını kontrol et
    if (response.statusCode == 200) {
      // JSON yanıtını çözümle
      final Map<String, dynamic> data = jsonDecode(response.body);

      // Açıklama bilgilerini al
      final Map<String, dynamic> description = data['description'];
      final List<dynamic> captions = description['captions'];

      // Sesli yanıtı oluştur
      String voiceResponse = 'Image description: ';
      for (var caption in captions) {
        voiceResponse += '${caption['text']}  ';
      }

      // Sesli yanıtı oku
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.speak(voiceResponse);

      // Açıklamayı ekrana yazdır
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Azure Vision API Describe Result'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var _ in captions)
                  Text('Description: ${captions[0]['text']}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Hata durumunda hata mesajını yazdır
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'Error: ${response.statusCode} - ${response.reasonPhrase}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<List<int>> _loadImageBytes(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    List<String> imagePaths = _getImagePaths();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Müze Fotoğrafları'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tıklanan Müze: ${widget.museumPath}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: imagePaths.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _analyzeImage(index + 1);
                  },
                  child: Card(
                    child: Image.asset(
                      imagePaths[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getImagePaths() {
    List<String> imagePaths = [];

    for (int i = 1; i <= _getTotalImages(); i++) {
      imagePaths.add('lib/assets/images/${widget.museumPath}/$i.jpg');
    }

    return imagePaths;
  }

  int _getTotalImages() {
    switch (widget.museumPath) {
      case 'arkeoloji':
        return 8;
      case 'etnografya':
        return 9;
      case 'sanat':
        return 9;
      case 'tarih':
        return 7;
      default:
        return 0;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}