import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:devshabitat/core/theme/dev_habitat_colors.dart';

class SocialLinksWidget extends StatelessWidget {
  final Map<String, String> socialLinks;
  final bool readOnly;
  final Function(String, String)? onLinkChanged;

  const SocialLinksWidget({
    Key? key,
    required this.socialLinks,
    this.readOnly = false,
    this.onLinkChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 768;
        final isDesktop = constraints.maxWidth >= 1200;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.link,
                  size: 24.r,
                  color: DevHabitatColors.primary,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Sosyal Medya',
                  style: TextStyle(
                    fontSize: isDesktop
                        ? 24.sp
                        : isTablet
                            ? 20.sp
                            : 18.sp,
                    fontWeight: FontWeight.bold,
                    color: DevHabitatColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _buildSocialLinkField(
              context,
              'GitHub',
              'github.com/',
              Icons.code,
              isTablet,
              isDesktop,
            ),
            SizedBox(height: 8.h),
            _buildSocialLinkField(
              context,
              'LinkedIn',
              'linkedin.com/in/',
              Icons.work,
              isTablet,
              isDesktop,
            ),
            SizedBox(height: 8.h),
            _buildSocialLinkField(
              context,
              'Twitter',
              'twitter.com/',
              Icons.chat,
              isTablet,
              isDesktop,
            ),
            SizedBox(height: 8.h),
            _buildSocialLinkField(
              context,
              'Instagram',
              'instagram.com/',
              Icons.camera_alt,
              isTablet,
              isDesktop,
            ),
            SizedBox(height: 8.h),
            _buildSocialLinkField(
              context,
              'Medium',
              'medium.com/@',
              Icons.article,
              isTablet,
              isDesktop,
            ),
            SizedBox(height: 8.h),
            _buildSocialLinkField(
              context,
              'Dev.to',
              'dev.to/',
              Icons.computer,
              isTablet,
              isDesktop,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSocialLinkField(
    BuildContext context,
    String platform,
    String prefix,
    IconData icon,
    bool isTablet,
    bool isDesktop,
  ) {
    final controller = TextEditingController(
      text: socialLinks[platform] ?? '',
    );

    return Container(
      decoration: BoxDecoration(
        color: DevHabitatColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 8.h,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24.r,
              color: DevHabitatColors.primary,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: readOnly
                  ? Text(
                      '${socialLinks[platform] ?? ''}',
                      style: TextStyle(
                        fontSize: isDesktop
                            ? 16.sp
                            : isTablet
                                ? 14.sp
                                : 12.sp,
                        color: DevHabitatColors.textPrimary,
                      ),
                    )
                  : TextField(
                      controller: controller,
                      style: TextStyle(
                        fontSize: isDesktop
                            ? 16.sp
                            : isTablet
                                ? 14.sp
                                : 12.sp,
                        color: DevHabitatColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: prefix,
                        hintStyle: TextStyle(
                          fontSize: isDesktop
                              ? 16.sp
                              : isTablet
                                  ? 14.sp
                                  : 12.sp,
                          color: DevHabitatColors.textSecondary,
                        ),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        if (onLinkChanged != null) {
                          onLinkChanged!(platform, value);
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
