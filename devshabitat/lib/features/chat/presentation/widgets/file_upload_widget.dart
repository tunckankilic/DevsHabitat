import 'package:devshabitat/core/theme/dev_habitat_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FileUploadWidget extends StatelessWidget {
  final double progress;
  final String fileName;
  final VoidCallback onCancel;

  const FileUploadWidget({
    Key? key,
    required this.progress,
    required this.fileName,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 768;
        final isDesktop = constraints.maxWidth >= 1200;

        return Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: DevHabitatColors.darkSurface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.upload_file,
                    size: 24.r,
                    color: DevHabitatColors.primaryBlue,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      fileName,
                      style: TextStyle(
                        fontSize: isDesktop
                            ? 16.sp
                            : isTablet
                                ? 14.sp
                                : 12.sp,
                        color: DevHabitatColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 20.r,
                      color: DevHabitatColors.textSecondary,
                    ),
                    onPressed: onCancel,
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: DevHabitatColors.darkCard,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  DevHabitatColors.primaryBlue,
                ),
                minHeight: 4.h,
                borderRadius: BorderRadius.circular(2.r),
              ),
              SizedBox(height: 4.h),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: DevHabitatColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
