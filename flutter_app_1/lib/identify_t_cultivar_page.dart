import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class IdentifyTCultivarPage extends StatefulWidget {
  final String username;

  IdentifyTCultivarPage({required this.username});

  @override
  _IdentifyTCultivarPageState createState() => _IdentifyTCultivarPageState();
}

class _IdentifyTCultivarPageState extends State<IdentifyTCultivarPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  final TextEditingController _plantAgeController = TextEditingController();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _plantAgeController.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller?.initialize();
    setState(() {});
  }

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _submitData() {
    // Implement the logic to handle the form submission
    String plantAge = _plantAgeController.text;
    print('Plant Age: $plantAge');
    // You can add more logic to handle the submission
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Identify Tea Cultivar'),
        backgroundColor: Colors.blue[100],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.blue[50],
            child: Row(
              children: [
                CircleAvatar(
                  child: Icon(Icons.person),
                ),
                SizedBox(width: 10),
                Text(
                  'Hello, ${widget.username}',
                  style: TextStyle(fontSize: 20),
                ),
                Spacer(),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      prefixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          _controller == null
              ? CircularProgressIndicator()
              : FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: CameraPreview(_controller!),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          SizedBox(height: 20),
          _selectedImage == null
              ? Text('No image selected.')
              : Image.file(_selectedImage!),
          ElevatedButton(
            onPressed: _uploadImage,
            child: Text('Upload Image'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[100],
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _plantAgeController,
            decoration: InputDecoration(
              labelText: 'Plant Age',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitData,
            child: Text('Submit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[100],
            ),
          ),
        ],
      ),
    );
  }
}
