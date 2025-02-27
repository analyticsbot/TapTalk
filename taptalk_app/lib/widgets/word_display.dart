import 'package:flutter/material.dart';
import 'package:taptalk_app/services/text_recognition.dart';

class WordDisplay extends StatelessWidget {
  final List<RecognizedWord> words;
  final int highlightedWordIndex;
  final Function(int) onWordTapped;

  const WordDisplay({
    super.key,
    required this.words,
    required this.highlightedWordIndex,
    required this.onWordTapped,
  });

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'No words detected',
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: List.generate(
            words.length,
            (index) => _buildWordChip(index),
          ),
        ),
      ),
    );
  }

  Widget _buildWordChip(int index) {
    final bool isHighlighted = index == highlightedWordIndex;
    
    return GestureDetector(
      onTap: () => onWordTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        decoration: BoxDecoration(
          color: isHighlighted ? Colors.amber : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: isHighlighted
              ? [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          words[index].text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            color: isHighlighted ? Colors.black : Colors.black87,
          ),
        ),
      ),
    );
  }
}
