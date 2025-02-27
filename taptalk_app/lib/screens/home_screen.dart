import 'package:flutter/material.dart';
import 'package:taptalk_app/widgets/camera_widget.dart';
import 'package:taptalk_app/widgets/word_display.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:taptalk_app/services/text_to_speech.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<RecognizedWord> _recognizedWords = [];
  int _highlightedWordIndex = -1;
  final TextToSpeechService _ttsService = TextToSpeechService();
  
  @override
  void initState() {
    super.initState();
    _initTTS();
  }
  
  Future<void> _initTTS() async {
    await _ttsService.initTTS();
  }
  
  void _onTextRecognized(List<RecognizedWord> words) {
    setState(() {
      _recognizedWords.clear();
      _recognizedWords.addAll(words);
      _highlightedWordIndex = -1;
    });
  }
  
  void _onWordTapped(int index) {
    setState(() {
      _highlightedWordIndex = index;
    });
    
    if (index >= 0 && index < _recognizedWords.length) {
      _ttsService.speakWord(_recognizedWords[index].text);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TapTalk',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Camera preview takes 2/3 of the screen
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: CameraWidget(
                  onTextRecognized: _onTextRecognized,
                ),
              ),
            ),
          ),
          
          // Instruction text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              _recognizedWords.isEmpty 
                  ? 'Point camera at a word or sentence'
                  : 'Tap on a word to hear it',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Recognized words display takes 1/3 of the screen
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: WordDisplay(
                words: _recognizedWords,
                highlightedWordIndex: _highlightedWordIndex,
                onWordTapped: _onWordTapped,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _ttsService.dispose();
    super.dispose();
  }
}
