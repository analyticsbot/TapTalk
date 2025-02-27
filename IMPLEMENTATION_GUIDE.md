# TapTalk Implementation Guide

This guide provides code examples for the key components of the TapTalk app. These examples can be adapted to your preferred mobile development framework.

## 1. Camera Implementation (React Native)

```javascript
// src/components/Camera.js
import React, { useState, useRef } from 'react';
import { StyleSheet, View, TouchableOpacity, Text } from 'react-native';
import { RNCamera } from 'react-native-camera';
import { recognizeText } from '../services/textRecognition';

const Camera = ({ onTextRecognized }) => {
  const cameraRef = useRef(null);
  const [processing, setProcessing] = useState(false);

  const captureFrame = async () => {
    if (processing || !cameraRef.current) return;
    
    setProcessing(true);
    try {
      const options = { quality: 0.8, base64: true };
      const data = await cameraRef.current.takePictureAsync(options);
      
      // Process the image to recognize text
      const recognizedText = await recognizeText(data.uri);
      onTextRecognized(recognizedText);
    } catch (error) {
      console.error('Error capturing image:', error);
    } finally {
      setProcessing(false);
    }
  };

  // Continuous frame capture for real-time text recognition
  const startContinuousCapture = () => {
    const interval = setInterval(() => {
      captureFrame();
    }, 1000); // Capture every second
    
    return () => clearInterval(interval);
  };

  return (
    <View style={styles.container}>
      <RNCamera
        ref={cameraRef}
        style={styles.camera}
        type={RNCamera.Constants.Type.back}
        captureAudio={false}
        onCameraReady={startContinuousCapture}
      />
      <View style={styles.overlay}>
        <Text style={styles.instructions}>
          Point camera at a word or sentence
        </Text>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  camera: {
    flex: 1,
  },
  overlay: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    padding: 20,
    backgroundColor: 'rgba(0,0,0,0.3)',
  },
  instructions: {
    color: 'white',
    fontSize: 18,
    textAlign: 'center',
  },
});

export default Camera;
```

## 2. Text Recognition Service (React Native)

```javascript
// src/services/textRecognition.js
import { MLKitTextRecognition } from 'react-native-mlkit-text-recognition';

export const recognizeText = async (imageUri) => {
  try {
    const result = await MLKitTextRecognition.recognize(imageUri);
    return processRecognizedText(result);
  } catch (error) {
    console.error('Text recognition failed:', error);
    return null;
  }
};

const processRecognizedText = (recognitionResult) => {
  // Extract words and their positions from the recognition result
  const words = [];
  
  recognitionResult.blocks.forEach(block => {
    block.lines.forEach(line => {
      line.elements.forEach(element => {
        words.push({
          text: element.text,
          bounds: element.frame, // Position information
        });
      });
    });
  });
  
  return words;
};
```

## 3. Text-to-Speech with Phonics (React Native)

```javascript
// src/services/textToSpeech.js
import Tts from 'react-native-tts';
import { mapWordToPhonics } from '../utils/phonicsMapper';

export const initTTS = async () => {
  try {
    await Tts.setDefaultLanguage('en-US');
    await Tts.setDefaultRate(0.5); // Slower rate for children
    await Tts.setDefaultPitch(1.0);
  } catch (error) {
    console.error('TTS initialization failed:', error);
  }
};

export const speakWord = async (word) => {
  try {
    // Convert word to phonics representation
    const phonicsRepresentation = mapWordToPhonics(word);
    
    // Use the phonics representation for speech
    await Tts.speak(phonicsRepresentation);
  } catch (error) {
    console.error('TTS speak failed:', error);
  }
};

export const speakSentence = async (words, onWordSpoken) => {
  // Split sentence into words and speak each word with a pause
  for (let i = 0; i < words.length; i++) {
    await speakWord(words[i]);
    
    // Callback to highlight the current word
    if (onWordSpoken) {
      onWordSpoken(i);
    }
    
    // Pause between words
    await new Promise(resolve => setTimeout(resolve, 500));
  }
};
```

## 4. Phonics Mapping Utility

```javascript
// src/utils/phonicsMapper.js

// Basic phonics mapping for common words
const phonicsMap = {
  'a': 'ay',
  'the': 'th-uh',
  'cat': 'k-a-t',
  'dog': 'd-o-g',
  // Add more mappings as needed
};

// Function to map a word to its phonics representation
export const mapWordToPhonics = (word) => {
  const lowerWord = word.toLowerCase();
  
  // Check if we have a direct mapping
  if (phonicsMap[lowerWord]) {
    return phonicsMap[lowerWord];
  }
  
  // For words without a direct mapping, we can implement a rule-based system
  // This is a simplified example - a real implementation would be more complex
  let phonics = '';
  for (let i = 0; i < lowerWord.length; i++) {
    const char = lowerWord[i];
    const nextChar = lowerWord[i + 1] || '';
    
    // Apply basic phonics rules
    if (char === 'c' && (nextChar === 'e' || nextChar === 'i' || nextChar === 'y')) {
      phonics += 's';
    } else if (char === 'g' && (nextChar === 'e' || nextChar === 'i' || nextChar === 'y')) {
      phonics += 'j';
    } else {
      phonics += char;
    }
    
    // Add hyphens between characters for clearer pronunciation
    if (i < lowerWord.length - 1) {
      phonics += '-';
    }
  }
  
  return phonics;
};
```

## 5. Gesture Handler for Sentence Reading

```javascript
// src/services/gestureHandler.js
import { PanResponder } from 'react-native';
import { speakSentence } from './textToSpeech';

export const createSentenceDragHandler = (recognizedWords, onWordHighlight) => {
  let currentWordIndex = -1;
  
  const panResponder = PanResponder.create({
    onStartShouldSetPanResponder: () => true,
    onMoveShouldSetPanResponder: () => true,
    
    onPanResponderGrant: (evt, gestureState) => {
      // Check if the touch is on a word
      const touchX = evt.nativeEvent.locationX;
      const touchY = evt.nativeEvent.locationY;
      
      // Find which word was touched
      const touchedWordIndex = recognizedWords.findIndex(word => {
        const { bounds } = word;
        return (
          touchX >= bounds.x &&
          touchX <= bounds.x + bounds.width &&
          touchY >= bounds.y &&
          touchY <= bounds.y + bounds.height
        );
      });
      
      if (touchedWordIndex !== -1) {
        // Speak the touched word
        currentWordIndex = touchedWordIndex;
        onWordHighlight(currentWordIndex);
        speakWord(recognizedWords[currentWordIndex].text);
      }
    },
    
    onPanResponderMove: (evt, gestureState) => {
      // Check if dragging over a new word
      const touchX = evt.nativeEvent.locationX;
      const touchY = evt.nativeEvent.locationY;
      
      // Find which word is being dragged over
      const draggedWordIndex = recognizedWords.findIndex(word => {
        const { bounds } = word;
        return (
          touchX >= bounds.x &&
          touchX <= bounds.x + bounds.width &&
          touchY >= bounds.y &&
          touchY <= bounds.y + bounds.height
        );
      });
      
      // If dragged to a new word, speak it
      if (draggedWordIndex !== -1 && draggedWordIndex !== currentWordIndex) {
        currentWordIndex = draggedWordIndex;
        onWordHighlight(currentWordIndex);
        speakWord(recognizedWords[currentWordIndex].text);
      }
    },
    
    onPanResponderRelease: () => {
      // Reset current word index
      currentWordIndex = -1;
    },
  });
  
  return panResponder;
};
```

## 6. Main App Screen

```javascript
// src/screens/HomeScreen.js
import React, { useState, useEffect } from 'react';
import { StyleSheet, View, Text, SafeAreaView } from 'react-native';
import Camera from '../components/Camera';
import { initTTS } from '../services/textToSpeech';
import { createSentenceDragHandler } from '../services/gestureHandler';

const HomeScreen = () => {
  const [recognizedWords, setRecognizedWords] = useState([]);
  const [highlightedWordIndex, setHighlightedWordIndex] = useState(-1);
  
  useEffect(() => {
    // Initialize text-to-speech
    initTTS();
  }, []);
  
  const handleTextRecognized = (words) => {
    setRecognizedWords(words);
  };
  
  // Create pan responder for sentence dragging
  const panResponder = createSentenceDragHandler(
    recognizedWords,
    setHighlightedWordIndex
  );
  
  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>TapTalk</Text>
      </View>
      
      <View style={styles.cameraContainer}>
        <Camera onTextRecognized={handleTextRecognized} />
      </View>
      
      <View 
        style={styles.wordsContainer}
        {...panResponder.panHandlers}
      >
        {recognizedWords.map((word, index) => (
          <Text
            key={`${word.text}-${index}`}
            style={[
              styles.word,
              index === highlightedWordIndex && styles.highlightedWord
            ]}
          >
            {word.text}
          </Text>
        ))}
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F5F5F5',
  },
  header: {
    padding: 16,
    backgroundColor: '#4CAF50',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: 'white',
    textAlign: 'center',
  },
  cameraContainer: {
    flex: 2,
    overflow: 'hidden',
    borderRadius: 12,
    margin: 16,
  },
  wordsContainer: {
    flex: 1,
    margin: 16,
    padding: 16,
    backgroundColor: 'white',
    borderRadius: 12,
    flexDirection: 'row',
    flexWrap: 'wrap',
    alignItems: 'center',
  },
  word: {
    fontSize: 24,
    marginRight: 8,
    marginBottom: 8,
    padding: 8,
    backgroundColor: '#E0E0E0',
    borderRadius: 8,
  },
  highlightedWord: {
    backgroundColor: '#FFC107',
  },
});

export default HomeScreen;
```

## Flutter Implementation

Similar components would be implemented in Flutter using:
- `camera` package for camera functionality
- `google_ml_kit` for text recognition
- `flutter_tts` for text-to-speech
- `GestureDetector` for handling touch gestures

The implementation would follow the same logical structure but with Flutter-specific syntax and patterns.
