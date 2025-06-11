import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:devshabitat/core/theme/dev_habitat_colors.dart';

class ImageUploadWidget extends StatefulWidget {
  final String? currentImageUrl;
  final Function(String) onImageSelected;
  final bool isCoverPhoto;
  final double aspectRatio;

  const ImageUploadWidget({
    Key? key,
    this.currentImageUrl,
    required this.onImageSelected,
    this.isCoverPhoto = false,
    this.aspectRatio = 1,
  }) : super(key: key);

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(
            ratioX: widget.aspectRatio,
            ratioY: 1,
          ),
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Resmi Düzenle',
              toolbarColor: DevHabitatColors.primary,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
            IOSUiSettings(
              title: 'Resmi Düzenle',
            ),
          ],
        );

        if (croppedFile != null) {
          // TODO: Implement image upload to storage
          widget.onImageSelected(croppedFile.path);
        }
      }
    } catch (e) {
      // TODO: Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: widget.isCoverPhoto ? 200 : 200,
        decoration: BoxDecoration(
          color: DevHabitatColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
        child: Stack(
          children: [
            if (widget.currentImageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.currentImageUrl!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholder();
                  },
                ),
              )
            else
              _buildPlaceholder(),
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: DevHabitatColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.isCoverPhoto ? Icons.photo_library : Icons.person,
            size: 48,
            color: DevHabitatColors.primary,
          ),
          const SizedBox(height: 8),
          Text(
            widget.isCoverPhoto ? 'Upload Cover Photo' : 'Upload Profile Photo',
            style: const TextStyle(
              color: DevHabitatColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
