import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:taptalk_app/utils/phonics_mapper.dart';

class TextToSpeechService {
  final FlutterTts _flutterTts = FlutterTts();
  final PhonicsMapper _phonicsMapper = PhonicsMapper();
  
  Future<void> initTTS() async {
    try {
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setSpeechRate(0.5); // Slower rate for children
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
    } catch (e) {
      debugPrint('Error initializing TTS: $e');
    }
  }
  
  Future<void> speakWord(String word) async {
    try {
      // Convert word to phonics representation
      final String phonicsRepresentation = _phonicsMapper.mapWordToPhonics(word);
      
      // Use the phonics representation for speech
      await _flutterTts.speak(phonicsRepresentation);
    } catch (e) {
      debugPrint('Error speaking word: $e');
    }
  }
  
  Future<void> speakSentence(List<String> words, {Function(int)? onWordSpoken}) async {
    // Split sentence into words and speak each word with a pause
    for (int i = 0; i < words.length; i++) {
      await speakWord(words[i]);
      
      // Callback to highlight the current word
      if (onWordSpoken != null) {
        onWordSpoken(i);
      }
      
      // Pause between words
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }
  
  void dispose() {
    _flutterTts.stop();
  }
}
