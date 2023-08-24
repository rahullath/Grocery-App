import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class BarcodeScannerPage extends StatefulWidget {
  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  CameraController? controller;
  List<CameraDescription>? cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  _initializeCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras![0], ResolutionPreset.high);
    controller!.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  Future<void> _captureAndScan() async {
    final image = await controller!.takePicture();
    final inputImage = InputImage.fromFilePath(image.path);
    final barcodeScanner = BarcodeScanner();
    final barcodes = await barcodeScanner.processImage(inputImage);

    // Handle the scanned barcodes as needed
    for (Barcode barcode in barcodes) {
      print(barcode.displayValue);
      // TODO: Add your logic to handle the barcode data
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CameraPreview(controller!),
          Positioned(
            bottom: 50.0,
            left: 50.0,
            child: ElevatedButton(
              onPressed: _captureAndScan,
              child: Text('Capture & Scan'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
} 
