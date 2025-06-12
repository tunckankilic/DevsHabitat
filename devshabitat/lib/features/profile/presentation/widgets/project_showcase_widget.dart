import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:devshabitat/core/theme/dev_habitat_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/models/project_showcase.dart';

class ProjectShowcaseWidget extends StatelessWidget {
  final List<ProjectShowcase> projects;

  const ProjectShowcaseWidget({
    Key? key,
    required this.projects,
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
                  Icons.work,
                  size: 24.r,
                  color: DevHabitatColors.primary,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Projeler',
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return _buildProjectCard(context, project, isTablet, isDesktop);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildProjectCard(
    BuildContext context,
    ProjectShowcase project,
    bool isTablet,
    bool isDesktop,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: DevHabitatColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (project.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.r),
              ),
              child: SizedBox(
                height: isDesktop
                    ? 300.h
                    : isTablet
                        ? 250.h
                        : 200.h,
                child: Image.network(
                  project.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: DevHabitatColors.surface,
                      child: Icon(
                        Icons.broken_image,
                        size: 48.r,
                        color: DevHabitatColors.textSecondary,
                      ),
                    );
                  },
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.title,
                  style: TextStyle(
                    fontSize: isDesktop
                        ? 20.sp
                        : isTablet
                            ? 18.sp
                            : 16.sp,
                    fontWeight: FontWeight.bold,
                    color: DevHabitatColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  project.description,
                  style: TextStyle(
                    fontSize: isDesktop
                        ? 16.sp
                        : isTablet
                            ? 14.sp
                            : 12.sp,
                    color: DevHabitatColors.textSecondary,
                  ),
                ),
                SizedBox(height: 16.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: project.technologies.map((tech) {
                    return Chip(
                      label: Text(
                        tech,
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
                if (project.githubUrl != null || project.liveUrl != null) ...[
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      if (project.githubUrl != null)
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _launchUrl(project.githubUrl!),
                            icon: Icon(
                              Icons.code,
                              size: 20.r,
                            ),
                            label: Text(
                              'GitHub',
                              style: TextStyle(
                                fontSize: 14.sp,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: DevHabitatColors.primary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: 12.h,
                                horizontal: 16.w,
                              ),
                            ),
                          ),
                        ),
                      if (project.githubUrl != null && project.liveUrl != null)
                        SizedBox(width: 16.w),
                      if (project.liveUrl != null)
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _launchUrl(project.liveUrl!),
                            icon: Icon(
                              Icons.launch,
                              size: 20.r,
                            ),
                            label: Text(
                              'Live Demo',
                              style: TextStyle(
                                fontSize: 14.sp,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: DevHabitatColors.secondary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: 12.h,
                                horizontal: 16.w,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}
