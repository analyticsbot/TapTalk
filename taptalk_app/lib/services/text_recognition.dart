import 'package:flutter/foundation.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class RecognizedWord {
  final String text;
  final Rect bounds;

  RecognizedWord({
    required this.text,
    required this.bounds,
  });
}

class TextRecognitionService {
  final TextRecognizer _textRecognizer = GoogleMlKit.vision.textRecognizer();

  Future<List<RecognizedWord>> recognizeText(String imagePath) async {
    try {
      final InputImage inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

      final List<RecognizedWord> words = [];

      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            words.add(
              RecognizedWord(
                text: element.text,
                bounds: element.boundingBox,
              ),
            );
          }
        }
      }

      return words;
    } catch (e) {
      debugPrint('Error recognizing text: $e');
      return [];
    }
  }

  void dispose() {
    _textRecognizer.close();
  }
}
