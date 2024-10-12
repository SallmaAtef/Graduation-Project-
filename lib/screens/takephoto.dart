import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:snapmart/screens/profile.dart';
import 'package:snapmart/screens/servicesAPI.dart';

import '../widgets/constant.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});
  static const String id = 'upload_image_screen';
  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  String isImageUploade = "";
  bool isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        isLoading = true;
      });
      try {
        // Correct the image orientation
        Uint8List correctedBytes = await _correctImageOrientation(image);

        // Upload the corrected image
        final value =
            await UploadApiImage().uploadImage(correctedBytes, image.name);
        setState(() {
          isImageUploade = value['location'].toString();
          isLoading = false;
        });
        print("Uploaded Successfully with link ${value.toString()}");
      } catch (error) {
        setState(() {
          isLoading = false;
        });
        print(error.toString());
      }
    }
  }

  Future<Uint8List> _correctImageOrientation(XFile imageFile) async {
    final Uint8List bytes = await imageFile.readAsBytes();
    final img.Image image = img.decodeImage(bytes)!;

    // Rotate the image based on its orientation
    final img.Image orientedImage = img.bakeOrientation(image);

    // Convert the image back to bytes
    final Uint8List orientedBytes =
        Uint8List.fromList(img.encodeJpg(orientedImage));
    return orientedBytes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                          height: 60), // Ensure space for SnapMart text
                      isImageUploade.isEmpty
                          ? const SizedBox()
                          : Container(
                              height: 350,
                              width: 350,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: kPrimaryColor, width: 4),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  isImageUploade,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      const SizedBox(
                          height: 20), // Add space between image and buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 18.0, horizontal: 24.0),
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              onPressed: () => _pickImage(ImageSource.gallery),
                              icon: const Icon(Icons.photo_library,
                                  color: Colors.white),
                              label: const Text(
                                "Gallery",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 24.0),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 18.0, horizontal: 24.0),
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              onPressed: () => _pickImage(ImageSource.camera),
                              icon: const Icon(Icons.camera_alt,
                                  color: Colors.white),
                              label: const Text(
                                "Camera",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                    ],
                  ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
                clipper: RoundedAppBarClipper(),
                child: Container(
                  color: Colors.blue,
                  height: 200,
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    // leading: IconButton(
                    //   icon: Icon(Icons.arrow_back),
                    //   color: Colors.white,
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //   },
                    // ),
                    centerTitle: true,
                    title: Text(
                      'SNAPMART',
                      style: TextStyle(
                        fontFamily: 'Pacifico',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    // actions: [
                    //
                    //   IconButton(
                    //     icon: Icon(Icons.person),
                    //     color: Colors.white,
                    //     onPressed: () {
                    //       // Navigate to profile screen
                    //       Navigator.pushNamed(context, ProfileApp.id);
                    //     },
                    //   ),
                    // ],
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }
}
class RoundedAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}