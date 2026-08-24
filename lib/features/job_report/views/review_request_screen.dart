import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/buttons/app_button.dart';
import '../../../common_widgets/inputs/app_text_field.dart';
import '../../../common_widgets/inputs/photo_picker_grid.dart';
import '../../../common_widgets/misc/icon_text_row.dart';
import '../../../common_widgets/misc/screen_header.dart';
import '../controller/job_report_controller.dart';

class ReviewRequestScreen extends GetView<JobReportController> {
  const ReviewRequestScreen({super.key});

  void _openNoteSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add a note', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              AppTextField(
                controller: controller.noteController,
                hint: 'Anything else we should know?',
                maxLines: 3,
                onChanged: controller.onNoteChanged,
              ),
              const SizedBox(height: 20),
              AppButton(label: 'Save', onPressed: () => Navigator.of(context).pop()),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ScreenHeader(
                title: 'Review your request',
                subtitle: 'Please check your details before submitting your request.',
              ),
              const SizedBox(height: 24),
              Obx(() {
                final category = controller.selectedCategory.value;
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: scheme.outline),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconTextRow(
                        icon: category?.icon ?? Icons.build_rounded,
                        iconBackground: category?.color.withValues(alpha: 0.14),
                        iconColor: category?.color,
                        title: category?.title ?? '',
                        subtitle: controller.descriptionController.text,
                      ),
                      if (controller.photos.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text('Photos (${controller.photos.length})', style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(height: 10),
                        PhotoPickerGrid(photos: controller.photos.toList(), onChanged: controller.onPhotosChanged),
                      ],
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: scheme.outline),
                ),
                child: Column(
                  children: [
                    Obx(
                      () => _ReviewRow(
                        icon: Icons.location_on_outlined,
                        title: 'Address',
                        value: '${controller.addressLine.value}, ${controller.postcode.value}',
                        onTap: () => Get.back(),
                      ),
                    ),
                    Divider(height: 1, color: scheme.outline),
                    Obx(
                      () => _ReviewRow(
                        icon: Icons.calendar_today_outlined,
                        title: 'When',
                        value: controller.isAsap.value ? 'As soon as possible' : 'Selected time',
                        onTap: () => controller.pickTime(context),
                      ),
                    ),
                    Divider(height: 1, color: scheme.outline),
                    Obx(
                      () => _ReviewRow(
                        icon: Icons.sticky_note_2_outlined,
                        title: 'Add note (optional)',
                        value: controller.note.value.isEmpty ? 'No note added' : controller.note.value,
                        onTap: () => _openNoteSheet(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => AppButton(
                  label: 'Submit request',
                  isLoading: controller.isSubmitting.value,
                  onPressed: controller.submit,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_rounded, size: 14, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text(
                    'Your data is secure and never shared.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.icon, required this.title, required this.value, this.onTap});

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: scheme.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyMedium),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
