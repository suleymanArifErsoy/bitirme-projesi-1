import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final subscriptionKey =
      "f11954c7372a44cd8918220a2fac5d52"; //'YOUR_AZURE_SUBSCRIPTION_KEY';
  final endpoint =
      "https://virtualmuseumfrance.cognitiveservices.azure.com"; //'YOUR_AZURE_VISION_API_ENDPOINT';
  final localImagePath =
      "./lib/assest/images/sanat/1.jpg"; //'LOCAL_IMAGE_PATH_TO_ANALYZE';
  final FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Azure Vision API Describe Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Azure Vision API'nin describe metodu için uç nokta
            final uriBase = '$endpoint/vision/v3.1/describe';

            // API isteği için başlık oluştur
            final headers = {
              'Content-Type': 'application/json',
              'Ocp-Apim-Subscription-Key': subscriptionKey,
            };

            // API isteği için veri oluştur
            final String base64Image = await base64StringFromFile(localImagePath);

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
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Azure Vision API Describe Result'),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var _ in captions)
                          Text(
                              'Description: ${captions[0]['text']}'),
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
          },
          child: const Text('Describe Image'),
        ),
      ),
    );
  }

  Future<String> base64StringFromFile(String path) async {
    ByteData data = await rootBundle.load(path);
    List<int> imageBytes = data.buffer.asUint8List();
    return base64Encode(imageBytes);
  }
}