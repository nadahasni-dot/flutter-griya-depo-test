import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';

import '../models/achievement_model.dart';
import '../providers/achievement_provider.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  late AchievementProvider _achievementProvider;
  File? _selectedImage;
  bool isSetup = false;

  @override
  void dispose() {
    _achievementProvider.resetInput();
    super.dispose();
  }

  Future<File?> pickImage(ImageSource source) async {
    try {
      final image =
          await ImagePicker().pickImage(source: source, imageQuality: 25);

      if (image == null) {
        return null;
      }

      File? imageTemp;

      if (source == ImageSource.camera) {
        imageTemp = await saveImagePermanently(image.path);
      } else {
        imageTemp = File(image.path);
      }

      return imageTemp;
    } on PlatformException catch (e) {
      log('failed pick image: ${e.toString()}');
      return null;
    }
  }

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationSupportDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  showImagePicker(
      {required BuildContext context,
      required Function() onGallery,
      required Function onCamera}) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              onGallery();
            },
            title: const Text('Select from gallery'),
            leading: const Icon(Icons.image),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              onCamera();
            },
            title: const Text('Select from camera'),
            leading: const Icon(Icons.camera_alt),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  setupInput(Achievement? detail, AchievementProvider provider) {
    if (detail != null && !isSetup) {
      provider.inputAchievement.text = detail.achievementName;
      provider.inputLevel.text = detail.level;
      provider.inputOrganizer.text = detail.organizer;
      provider.inputYear.text = detail.year;
      isSetup = true;
    }    
  }

  @override
  Widget build(BuildContext context) {
    Achievement? detail =
        ModalRoute.of(context)!.settings.arguments as Achievement?;
    _achievementProvider =
        Provider.of<AchievementProvider>(context, listen: false);

    setupInput(detail, _achievementProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(detail == null ? 'Add Achievement' : 'Edit Achievement'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _achievementProvider.inputAchievement,
              decoration: const InputDecoration(hintText: "Achievement name"),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _achievementProvider.inputLevel,
              decoration: const InputDecoration(hintText: "Level"),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _achievementProvider.inputOrganizer,
              decoration: const InputDecoration(hintText: "Organizer"),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _achievementProvider.inputYear,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: "Year"),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: GestureDetector(
                onTap: () => showImagePicker(
                  context: context,
                  onGallery: () async {
                    final image = await pickImage(ImageSource.gallery);

                    if (image != null) {
                      setState(() {
                        _selectedImage = image;
                      });
                    }
                  },
                  onCamera: () async {
                    final image = await pickImage(ImageSource.camera);

                    if (image != null) {
                      setState(() {
                        _selectedImage = image;
                      });
                    }
                  },
                ),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(color: Colors.grey.shade400),
                  child: Builder(builder: (context) {
                    if (_selectedImage == null) {
                      return const Center(child: Text('Select Image'));
                    }

                    return Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                bool isValid = true;
                if (_achievementProvider.inputAchievement.text.trim().isEmpty) {
                  isValid = false;
                }
                if (_achievementProvider.inputLevel.text.trim().isEmpty) {
                  isValid = false;
                }
                if (_achievementProvider.inputOrganizer.text.trim().isEmpty) {
                  isValid = false;
                }
                if (_achievementProvider.inputYear.text.trim().isEmpty) {
                  isValid = false;
                }
                if (_selectedImage == null) {
                  isValid = false;
                }

                if (!isValid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please provide all data & image'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }

                if (detail != null) {
                  // UPDATE
                  showDialog(
                    context: context,
                    builder: (context) => const Dialog(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );

                  final status = await _achievementProvider.editAchievement(
                    id: detail.id,
                    name: _achievementProvider.inputAchievement.text.trim(),
                    level: _achievementProvider.inputLevel.text.trim(),
                    organizer: _achievementProvider.inputOrganizer.text.trim(),
                    year: _achievementProvider.inputYear.text.trim(),
                    file: _selectedImage!,
                  );

                  if (status) {
                    _achievementProvider.getListAchievement(false);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  } else {
                    Navigator.of(context).pop();
                  }
                } else {
                  // CREATE
                  showDialog(
                    context: context,
                    builder: (context) => const Dialog(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );

                  final status = await _achievementProvider.createAchievement(
                    name: _achievementProvider.inputAchievement.text.trim(),
                    level: _achievementProvider.inputLevel.text.trim(),
                    organizer: _achievementProvider.inputOrganizer.text.trim(),
                    year: _achievementProvider.inputYear.text.trim(),
                    file: _selectedImage!,
                  );

                  if (status) {
                    _achievementProvider.getListAchievement(false);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  } else {
                    Navigator.of(context).pop();
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
