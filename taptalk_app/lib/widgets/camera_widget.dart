import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taptalk_app/services/text_recognition.dart';
import 'dart:async';

class CameraWidget extends StatefulWidget {
  final Function(List<RecognizedWord>) onTextRecognized;

  const CameraWidget({
    super.key,
    required this.onTextRecognized,
  });

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isPermissionGranted = false;
  Timer? _frameProcessingTimer;
  final TextRecognitionService _textRecognitionService = TextRecognitionService();
  bool _isProcessingFrame = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopFrameProcessing();
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _isPermissionGranted = status.isGranted;
    });

    if (_isPermissionGranted) {
      await _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    
    if (_cameras == null || _cameras!.isEmpty) {
      return;
    }

    // Use the first available camera (usually the back camera)
    final CameraDescription camera = _cameras!.first;
    
    _controller = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
      
      // Start processing frames
      _startFrameProcessing();
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  void _startFrameProcessing() {
    _frameProcessingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _processFrame();
    });
  }

  void _stopFrameProcessing() {
    _frameProcessingTimer?.cancel();
    _frameProcessingTimer = null;
  }

  Future<void> _processFrame() async {
    if (_isProcessingFrame || 
        _controller == null || 
        !_controller!.value.isInitialized) {
      return;
    }

    _isProcessingFrame = true;

    try {
      final XFile image = await _controller!.takePicture();
      
      // Process the image to recognize text
      final List<RecognizedWord> recognizedWords = 
          await _textRecognitionService.recognizeText(image.path);
      
      // Notify parent widget about recognized text
      widget.onTextRecognized(recognizedWords);
    } catch (e) {
      debugPrint('Error processing frame: $e');
    } finally {
      _isProcessingFrame = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isPermissionGranted) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.camera_alt_off,
              color: Colors.red,
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              'Camera permission is required',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    if (!_isCameraInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: CameraPreview(_controller!),
    );
  }
}
