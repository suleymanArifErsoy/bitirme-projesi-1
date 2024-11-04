import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  List<String> selectedHobbies = [] ;
  
 Future<void> _saveHobbies() async {
  final Box<String> hobilerBox = await Hive.openBox<String>('hobiler');
  final String hobiler = selectedHobbies.join(', '); 
  hobilerBox.put('hobiler', hobiler);

  // ignore: use_build_context_synchronously
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Hobiler kaydedildi: $hobiler'),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Hobi Formu')) 
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hobilerinizi Seçin:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            CheckboxListTile(
              title: const Text('arkeoloji'),
              value: selectedHobbies.contains('arkeoloji'),
              onChanged: (value) {
                setState(() {
                  if (value!) {
                    selectedHobbies.add('arkeoloji');
                  } else {
                    selectedHobbies.remove('arkeoloji');
                  }
                });
              },
            ),
            CheckboxListTile(
              title: const Text('etnografya'),
              value: selectedHobbies.contains('etnografya'),
              onChanged: (value) {
                setState(() {
                  if (value!) {
                    selectedHobbies.add('etnografya');
                  } else {
                    selectedHobbies.remove('etnografya');
                  }
                });
              },
            ),
            CheckboxListTile(
              title: const Text('sanat'),
              value: selectedHobbies.contains('sanat'),
              onChanged: (value) {
                setState(() {
                  if (value!) {
                    selectedHobbies.add('sanat');
                  } else {
                    selectedHobbies.remove('sanat');
                  }
                });
              },
            ),
            CheckboxListTile(
              title: const Text('tarih'),
              value: selectedHobbies.contains('tarih'),
              onChanged: (value) {
                setState(() {
                  if (value!) {
                    selectedHobbies.add('tarih');
                  } else {
                    selectedHobbies.remove('tarih');
                  }
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
              await _saveHobbies();
             // ignore: use_build_context_synchronously
             Navigator.pop(context, selectedHobbies); // Form sayfasını kapat
            },
              child: const Text('Kaydet'),
      ),
          ],
        ),
      ),
    );
  }
}
