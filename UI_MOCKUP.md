# TapTalk UI Mockup

This document provides a text-based description of the user interface for the TapTalk app.

## Main Screen

```
┌─────────────────────────────────────────┐
│              TapTalk                    │ ← App header with logo
├─────────────────────────────────────────┤
│                                         │
│                                         │
│                                         │
│                                         │
│            CAMERA VIEWFINDER            │ ← Camera view for scanning text
│                                         │
│                                         │
│                                         │
│                                         │
├─────────────────────────────────────────┤
│ Point camera at a word or sentence      │ ← Instruction text
├─────────────────────────────────────────┤
│                                         │
│  ┌────┐  ┌────────┐  ┌───┐  ┌────────┐  │
│  │The │  │quick   │  │fox│  │jumps   │  │ ← Recognized words display
│  └────┘  └────────┘  └───┘  └────────┘  │
│                                         │
│  ┌────┐  ┌────┐  ┌───┐  ┌────┐          │
│  │over│  │the │  │lazy│  │dog │         │
│  └────┘  └────┘  └───┘  └────┘          │
│                                         │
├─────────────────────────────────────────┤
│  ┌────────┐  ┌────────┐  ┌────────┐     │
│  │ Camera │  │ Gallery│  │Settings│     │ ← Navigation buttons
│  └────────┘  └────────┘  └────────┘     │
└─────────────────────────────────────────┘
```

## Word Recognition Mode

When a word is recognized by the camera, it is highlighted and read aloud using phonics:

```
┌─────────────────────────────────────────┐
│              TapTalk                    │
├─────────────────────────────────────────┤
│                                         │
│                                         │
│                                         │
│            ┌─────────┐                  │
│            │  cat    │                  │ ← Word detected in camera view
│            └─────────┘                  │
│                                         │
│                                         │
│                                         │
├─────────────────────────────────────────┤
│ Word detected!                          │
├─────────────────────────────────────────┤
│                                         │
│         ┌─────────────────┐             │
│         │      cat        │             │ ← Recognized word (highlighted)
│         └─────────────────┘             │
│                                         │
│         "k-a-t"                         │ ← Phonics pronunciation
│                                         │
│                                         │
├─────────────────────────────────────────┤
│  ┌────────┐  ┌────────┐  ┌────────┐     │
│  │ Camera │  │ Gallery│  │Settings│     │
│  └────────┘  └────────┘  └────────┘     │
└─────────────────────────────────────────┘
```

## Sentence Reading Mode

When the user drags their finger across a sentence, each word is highlighted and read in sequence:

```
┌─────────────────────────────────────────┐
│              TapTalk                    │
├─────────────────────────────────────────┤
│                                         │
│                                         │
│                                         │
│  ┌────┐ ┌───┐ ┌────┐ ┌───┐ ┌────┐ ┌───┐ │
│  │The│ │dog│ │runs│ │and│ │jumps│ │up│  │ ← Sentence detected in camera
│  └────┘ └───┘ └────┘ └───┘ └────┘ └───┘ │
│                                         │
│                                         │
│                                         │
├─────────────────────────────────────────┤
│ Drag across sentence to read            │
├─────────────────────────────────────────┤
│                                         │
│  ┌────┐  ┌───┐  ┌────┐  ┌───┐  ┌────┐   │
│  │The │  │dog│  │runs│  │and│  │jumps│  │
│  └────┘  └───┘  └────┘  └───┘  └────┘   │
│                                         │
│           ↑                             │ ← Currently reading "dog"
│      "d-o-g"                           │ ← Phonics pronunciation
│                                         │
├─────────────────────────────────────────┤
│  ┌────────┐  ┌────────┐  ┌────────┐     │
│  │ Camera │  │ Gallery│  │Settings│     │
│  └────────┘  └────────┘  └────────┘     │
└─────────────────────────────────────────┘
```

## Settings Screen

```
┌─────────────────────────────────────────┐
│              Settings                   │
├─────────────────────────────────────────┤
│                                         │
│  Reading Speed                          │
│  ○───●───○───○───○                      │ ← Speed slider
│  Slow         Fast                      │
│                                         │
│  Voice                                  │
│  ┌────────────────────┐                 │
│  │ Child-friendly     ▼│                │ ← Voice selection dropdown
│  └────────────────────┘                 │
│                                         │
│  Highlight Color                        │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐            │
│  │ 🟨 │ │ 🟦 │ │ 🟩 │ │ 🟥 │            │ ← Color options
│  └────┘ └────┘ └────┘ └────┘            │
│                                         │
│  Show Phonics Spelling                  │
│  ┌────┐                                 │
│  │  ✓ │                                 │ ← Toggle option
│  └────┘                                 │
│                                         │
│  Difficulty Level                       │
│  ○ Beginner                             │
│  ● Intermediate                         │ ← Difficulty selection
│  ○ Advanced                             │
│                                         │
├─────────────────────────────────────────┤
│  ┌────────┐  ┌────────┐  ┌────────┐     │
│  │  Save  │  │ Cancel │  │ Reset  │     │ ← Action buttons
│  └────────┘  └────────┘  └────────┘     │
└─────────────────────────────────────────┘
```

## Help Screen for Parents/Teachers

```
┌─────────────────────────────────────────┐
│                 Help                    │
├─────────────────────────────────────────┤
│                                         │
│  How to Use TapTalk                     │
│                                         │
│  1. Point the camera at a word          │
│     • Hold steady for best results      │
│     • Ensure good lighting              │
│                                         │
│  2. For single words:                   │
│     • The app will automatically        │
│       recognize and read the word       │
│                                         │
│  3. For sentences:                      │
│     • Point camera at full sentence     │
│     • Drag finger across the words      │
│     • Each word will be read as         │
│       your finger passes over it        │
│                                         │
│  4. Tips:                               │
│     • Use books with clear, large text  │
│     • Start with simple words           │
│     • Practice regularly                │
│                                         │
│  5. Troubleshooting:                    │
│     • If words aren't recognized,       │
│       check lighting and focus          │
│     • Restart app if issues persist     │
│                                         │
├─────────────────────────────────────────┤
│  ┌────────┐                             │
│  │  Back  │                             │
│  └────────┘                             │
└─────────────────────────────────────────┘
```

## Kid-Friendly Design Elements

- **Color Scheme**: Bright, primary colors that appeal to children
- **Typography**: Large, clear, rounded fonts that are easy to read
- **Icons**: Simple, intuitive icons with visual cues
- **Animations**: Gentle animations for feedback (e.g., bouncing effect when a word is recognized)
- **Sound Effects**: Pleasant sounds for positive reinforcement
- **Characters**: Optional cartoon mascot to guide children through the app

## Accessibility Features

- **High Contrast Mode**: For children with visual impairments
- **Larger Text Option**: For easier reading
- **Simplified Interface**: Option to reduce UI elements for fewer distractions
- **Parent Controls**: Password-protected settings
