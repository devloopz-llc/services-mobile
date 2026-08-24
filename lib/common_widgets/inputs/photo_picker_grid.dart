import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../feedback/app_toast.dart';

/// Grid of picked-photo thumbnails with a trailing "Add photo" tile — job
/// report photos, technician findings photos, and anywhere else the API
/// accepts a `photos[]` multipart array.
///
/// Rejects HEIC/HEIF at pick time with a clear message: the backend
/// rejects that format outright (see conventions.md), and iPhones shoot it
/// by default, so catching it here saves a confusing 422 later.
class PhotoPickerGrid extends StatelessWidget {
  const PhotoPickerGrid({
    super.key,
    required this.photos,
    required this.onChanged,
    this.maxPhotos = 6,
  });

  final List<XFile> photos;
  final ValueChanged<List<XFile>> onChanged;
  final int maxPhotos;

  static const _rejectedExtensions = {'heic', 'heif'};

  Future<void> _pickFrom(BuildContext context, ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source, imageQuality: 85);
    if (picked == null) return;

    final extension = picked.path.split('.').last.toLowerCase();
    if (_rejectedExtensions.contains(extension)) {
      AppToast.error('HEIC photos aren\'t supported yet. Please choose a JPG or PNG instead.');
      return;
    }

    onChanged([...photos, picked]);
  }

  void _openSourceSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_rounded),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _pickFrom(context, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _pickFrom(context, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _remove(int index) {
    final updated = [...photos]..removeAt(index);
    onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final canAddMore = photos.length < maxPhotos;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (var i = 0; i < photos.length; i++)
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(File(photos[i].path), width: 88, height: 88, fit: BoxFit.cover),
              ),
              Positioned(
                top: -6,
                right: -6,
                child: GestureDetector(
                  onTap: () => _remove(i),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.2), blurRadius: 4)],
                    ),
                    child: Icon(Icons.close_rounded, size: 16, color: scheme.onSurface),
                  ),
                ),
              ),
            ],
          ),
        if (canAddMore)
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _openSourceSheet(context),
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: scheme.outline, style: BorderStyle.solid),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_outlined, color: scheme.onSurfaceVariant, size: 22),
                  const SizedBox(height: 4),
                  Text(
                    'Add photo',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
