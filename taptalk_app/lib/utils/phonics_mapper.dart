class PhonicsMapper {
  // Basic phonics mapping for common words
  final Map<String, String> _phonicsMap = {
    'a': 'ay',
    'the': 'th-uh',
    'cat': 'k-a-t',
    'dog': 'd-o-g',
    'is': 'i-z',
    'and': 'a-n-d',
    'to': 't-oo',
    'in': 'i-n',
    'it': 'i-t',
    'you': 'y-oo',
    'that': 'th-a-t',
    'he': 'h-ee',
    'was': 'w-o-z',
    'for': 'f-or',
    'on': 'o-n',
    'are': 'aa-r',
    'with': 'w-i-th',
    'as': 'a-z',
    'his': 'h-i-z',
    'they': 'th-ay',
    'at': 'a-t',
    'be': 'b-ee',
    'this': 'th-i-s',
    'have': 'h-a-v',
    'from': 'f-r-o-m',
    'or': 'or',
    'one': 'w-u-n',
    'had': 'h-a-d',
    'by': 'b-eye',
    'word': 'w-er-d',
    'but': 'b-u-t',
    'not': 'n-o-t',
    'what': 'w-o-t',
    'all': 'aw-l',
    'were': 'w-er',
    'we': 'w-ee',
    'when': 'w-e-n',
    'your': 'y-or',
    'can': 'k-a-n',
    'said': 's-e-d',
    'there': 'th-air',
    'use': 'y-oo-z',
    'an': 'a-n',
    'each': 'ee-ch',
    'which': 'w-i-ch',
    'she': 'sh-ee',
    'do': 'd-oo',
    'how': 'h-ow',
    'their': 'th-air',
    'if': 'i-f',
    'will': 'w-i-l',
    'up': 'u-p',
    'other': 'u-th-er',
    'about': 'uh-b-ow-t',
    'out': 'ow-t',
    'many': 'm-e-n-ee',
    'then': 'th-e-n',
    'them': 'th-e-m',
    'these': 'th-ee-z',
    'so': 's-oh',
    'some': 's-u-m',
    'her': 'h-er',
    'would': 'w-oo-d',
    'make': 'm-ay-k',
    'like': 'l-eye-k',
    'him': 'h-i-m',
    'into': 'i-n-t-oo',
    'time': 't-eye-m',
    'has': 'h-a-z',
    'look': 'l-oo-k',
    'two': 't-oo',
    'more': 'm-or',
    'write': 'r-eye-t',
    'go': 'g-oh',
    'see': 's-ee',
    'number': 'n-u-m-b-er',
    'no': 'n-oh',
    'way': 'w-ay',
    'could': 'k-oo-d',
    'people': 'p-ee-p-u-l',
    'my': 'm-eye',
    'than': 'th-a-n',
    'first': 'f-er-s-t',
    'water': 'w-o-t-er',
    'been': 'b-i-n',
    'call': 'k-aw-l',
    'who': 'h-oo',
    'oil': 'oy-l',
    'its': 'i-t-s',
    'now': 'n-ow',
    'find': 'f-eye-n-d',
    'long': 'l-o-ng',
    'down': 'd-ow-n',
    'day': 'd-ay',
    'did': 'd-i-d',
    'get': 'g-e-t',
    'come': 'k-u-m',
    'made': 'm-ay-d',
    'may': 'm-ay',
    'part': 'p-aa-r-t',
  };

  // Function to map a word to its phonics representation
  String mapWordToPhonics(String word) {
    final String lowerWord = word.toLowerCase();
    
    // Check if we have a direct mapping
    if (_phonicsMap.containsKey(lowerWord)) {
      return _phonicsMap[lowerWord]!;
    }
    
    // For words without a direct mapping, implement a rule-based system
    return _applyPhonicsRules(lowerWord);
  }
  
  String _applyPhonicsRules(String word) {
    String phonics = '';
    
    for (int i = 0; i < word.length; i++) {
      final String char = word[i];
      final String nextChar = i < word.length - 1 ? word[i + 1] : '';
      final String prevChar = i > 0 ? word[i - 1] : '';
      
      // Apply basic phonics rules
      if (char == 'c' && (nextChar == 'e' || nextChar == 'i' || nextChar == 'y')) {
        phonics += 's';
      } else if (char == 'g' && (nextChar == 'e' || nextChar == 'i' || nextChar == 'y')) {
        phonics += 'j';
      } else if (char == 'a' && nextChar == 'y') {
        phonics += 'ay';
        i++; // Skip the next character
      } else if (char == 'e' && nextChar == 'e') {
        phonics += 'ee';
        i++; // Skip the next character
      } else if (char == 'o' && nextChar == 'o') {
        phonics += 'oo';
        i++; // Skip the next character
      } else if (char == 'o' && nextChar == 'u') {
        phonics += 'ow';
        i++; // Skip the next character
      } else if (char == 'a' && nextChar == 'i') {
        phonics += 'ay';
        i++; // Skip the next character
      } else if (char == 'e' && i == word.length - 1 && word.length > 2) {
        // Silent 'e' at the end of words
        // Don't add anything, but modify the previous vowel if needed
        if (prevChar == 'a') {
          // Replace the last added character with 'ay'
          phonics = phonics.substring(0, phonics.length - 1) + 'ay';
        } else if (prevChar == 'i') {
          // Replace the last added character with 'eye'
          phonics = phonics.substring(0, phonics.length - 1) + 'eye';
        } else if (prevChar == 'o') {
          // Replace the last added character with 'oh'
          phonics = phonics.substring(0, phonics.length - 1) + 'oh';
        } else if (prevChar == 'u') {
          // Replace the last added character with 'yoo'
          phonics = phonics.substring(0, phonics.length - 1) + 'yoo';
        }
      } else if (char == 't' && nextChar == 'h') {
        phonics += 'th';
        i++; // Skip the next character
      } else if (char == 's' && nextChar == 'h') {
        phonics += 'sh';
        i++; // Skip the next character
      } else if (char == 'c' && nextChar == 'h') {
        phonics += 'ch';
        i++; // Skip the next character
      } else if (char == 'p' && nextChar == 'h') {
        phonics += 'f';
        i++; // Skip the next character
      } else if (char == 'w' && nextChar == 'h') {
        phonics += 'w';
        i++; // Skip the next character
      } else {
        phonics += char;
      }
      
      // Add hyphens between characters for clearer pronunciation
      if (i < word.length - 1 && !phonics.endsWith('-')) {
        phonics += '-';
      }
    }
    
    return phonics;
  }
}
