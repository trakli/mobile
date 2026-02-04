import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/helpers.dart';

/// Row of camera, gallery, and file-pick actions. Calls [onFileAdded] with the
/// selected file path (or null if cancelled). Reusable for add-transaction form.
class AttachmentSourceRow extends StatelessWidget {
  const AttachmentSourceRow({
    super.key,
    required this.accentColor,
    required this.onFileAdded,
  });

  final Color accentColor;
  final void Function(String? path) onFileAdded;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = colorScheme.onSurface;
    return Row(
      spacing: 8.w,
      children: [
        Expanded(
          child: _AttachmentSourceButton(
            icon: SvgPicture.asset(
              Assets.images.camera,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
            label: LocaleKeys.snapPicture.tr(),
            onTap: () async {
              final file = await pickImageApp(
                sourcePick: ImageSource.camera,
              );
              onFileAdded(file?.path);
            },
          ),
        ),
        Expanded(
          child: _AttachmentSourceButton(
            icon: SvgPicture.asset(
              Assets.images.galleryAdd,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
            label: LocaleKeys.gallery.tr(),
            onTap: () async {
              final file = await pickImageApp(
                sourcePick: ImageSource.gallery,
              );
              onFileAdded(file?.path);
            },
          ),
        ),
        Expanded(
          child: _AttachmentSourceButton(
            icon: SvgPicture.asset(
              Assets.images.documentUpload,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
            label: LocaleKeys.uploadAttachment.tr(),
            subtitle: LocaleKeys.transactionFileType.tr(),
            onTap: () async {
              final file = await pickFile();
              onFileAdded(file?.path);
            },
          ),
        ),
      ],
    );
  }
}

class _AttachmentSourceButton extends StatelessWidget {
  const _AttachmentSourceButton({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.onTap,
  });

  final Widget icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 52.h,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          spacing: 4.w,
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            Expanded(
              child: subtitle != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          label,
                          style: textTheme.bodySmall?.copyWith(
                            fontSize: 12.sp,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          subtitle!,
                          style: textTheme.bodySmall?.copyWith(
                            fontSize: 8.sp,
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )
                  : Text(
                      label,
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        color: colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
