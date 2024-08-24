import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(VoiceRecognitionApp());
}

class VoiceRecognitionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Recognition App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VoiceRecognitionHomePage(),
    );
  }
}

class VoiceRecognitionHomePage extends StatefulWidget {
  @override
  _VoiceRecognitionHomePageState createState() => _VoiceRecognitionHomePageState();
}

class _VoiceRecognitionHomePageState extends State<VoiceRecognitionHomePage> {
  late stt.SpeechToText speech;
  String recognizedWords = '';

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();
    initializeSpeechRecognition();
  }

  Future<void> initializeSpeechRecognition() async {
    bool isPermissionGranted = await getMicrophonePermission();
    await handlePermissionResponse(isPermissionGranted);
  }

  Future<bool> getMicrophonePermission() async {
    bool hasPermission = await speech.initialize(
      onError: (error) => print('Error initializing speech recognition: $error'),
    );

    if (!hasPermission) {
      bool isPermissionGranted = await speech.requestPermission();

      if (!isPermissionGranted) {
        print('Microphone permission not granted');
      }

      return isPermissionGranted;
    }

    return true;
  }

  Future<void> handlePermissionResponse(bool isPermissionGranted) async {
    if (!isPermissionGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Microphone permission not granted')),
      );
    }
  }

  bool isSpeechRecognitionAvailable() {
    return speech.isAvailable;
  }

  void startSpeechRecognition() {
    speech.listen(
      onResult: (result) {
        setState(() {
          recognizedWords = result.recognizedWords;
        });
      },
      listenFor: Duration(minutes: 1),
      cancelOnError: true,
    );
  }

  void stopSpeechRecognition() {
    speech.stop();
  }

  void disposeSpeechRecognition() {
    speech.cancel();
  }

  @override
  void dispose() {
    disposeSpeechRecognition();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Recognition App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Recognized Words:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              recognizedWords,
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (isSpeechRecognitionAvailable()) {
                  startSpeechRecognition();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Speech recognition not available')),
                  );
                }
              },
              child: Text('Start Listening'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: stopSpeechRecognition,
              child: Text('Stop Listening'),
            ),
          ],
        ),
      ),
    );
  }
}
