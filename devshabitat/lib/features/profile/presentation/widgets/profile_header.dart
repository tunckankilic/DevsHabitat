import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:devshabitat/core/theme/dev_habitat_colors.dart';
import '../../domain/models/developer_profile.dart';

class ProfileHeader extends StatelessWidget {
  final DeveloperProfile profile;
  final bool isEditable;
  final VoidCallback? onEditPressed;

  const ProfileHeader({
    Key? key,
    required this.profile,
    this.isEditable = false,
    this.onEditPressed,
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
            color: DevHabitatColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileImage(context),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                profile.displayName,
                                style: TextStyle(
                                  fontSize: isDesktop
                                      ? 32.sp
                                      : isTablet
                                          ? 28.sp
                                          : 24.sp,
                                  fontWeight: FontWeight.bold,
                                  color: DevHabitatColors.textPrimary,
                                ),
                              ),
                            ),
                            if (isEditable)
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  size: 24.r,
                                  color: DevHabitatColors.primary,
                                ),
                                onPressed: onEditPressed,
                              ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        if (profile.location != null) ...[
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16.r,
                                color: DevHabitatColors.textSecondary,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                profile.location!,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: DevHabitatColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                        ],
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: profile.skills.map((skill) {
                            return Chip(
                              label: Text(
                                skill,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: DevHabitatColors.primary,
                                ),
                              ),
                              backgroundColor:
                                  DevHabitatColors.primary.withOpacity(0.1),
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (profile.bio != null) ...[
                SizedBox(height: 16.h),
                Text(
                  profile.bio!,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: DevHabitatColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    return Container(
      width: 120.r,
      height: 120.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 4.r,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(60.r),
        child: profile.profileImageUrl != null
            ? Image.network(
                profile.profileImageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: DevHabitatColors.surface,
                    child: Icon(
                      Icons.person,
                      size: 48.r,
                      color: DevHabitatColors.primary,
                    ),
                  );
                },
              )
            : Container(
                color: DevHabitatColors.surface,
                child: Icon(
                  Icons.person,
                  size: 48.r,
                  color: DevHabitatColors.primary,
                ),
              ),
      ),
    );
  }
}
