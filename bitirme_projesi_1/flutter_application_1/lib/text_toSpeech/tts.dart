import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Text_to_speech extends StatelessWidget {
  const Text_to_speech({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FlutterTts flutterTts;
  late TextEditingController textController;
  String audioUrl = "";

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    textController = TextEditingController();
  }

  Future<void> speakText(String text) async {
    await flutterTts.setLanguage("tr-TR");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    return flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seslendirme Sayfası'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                labelText: 'Text to Speak',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String text = textController.text;
                await speakText(text);
              },
              child: const Text('Söyle Bir tanem'),
            ),
            const SizedBox(height: 16.0),
            const SizedBox(height: 16.0),
            if (audioUrl.isNotEmpty)
              Text(
                'Generated Audio URL: $audioUrl',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}

class TextToSpeech {
  late FlutterTts flutterTts;

  TextToSpeech() {
    // Diğer başlatma işlemleri
  }
  Future<void> speak(String text) async {
    flutterTts = FlutterTts();
    await flutterTts.setLanguage("tr-TR");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    return flutterTts.speak(text);
  }
}

