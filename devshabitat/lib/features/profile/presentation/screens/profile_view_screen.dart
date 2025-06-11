import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/presentation/widgets/responsive_base.dart';
import '../bloc/profile_form_bloc.dart';
import '../../domain/models/developer_profile.dart';

class ProfileViewScreen extends StatelessWidget {
  final String userId;

  const ProfileViewScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileFormBloc, ProfileFormState>(
      builder: (context, state) {
        if (state is ProfileFormLoaded) {
          return ResponsiveBase(
            mobile: _buildMobileLayout(state.developerProfile),
            tablet: _buildTabletLayout(state.developerProfile),
            desktop: _buildDesktopLayout(state.developerProfile),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildMobileLayout(DeveloperProfile profile) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(profile),
              SizedBox(height: 16.h),
              _buildProfileContent(profile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(DeveloperProfile profile) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: _buildProfileHeader(profile),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: _buildProfileContent(profile),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(DeveloperProfile profile) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: _buildProfileHeader(profile),
          ),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(32.w),
                child: _buildProfileContent(profile),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(DeveloperProfile profile) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50.r,
            backgroundImage: profile.profileImageUrl != null
                ? NetworkImage(profile.profileImageUrl!)
                : null,
            child: profile.profileImageUrl == null
                ? Icon(Icons.person, size: 50.r)
                : null,
          ),
          SizedBox(height: 16.h),
          Text(
            profile.displayName,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(DeveloperProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (profile.bio != null)
          _buildSection(
            title: 'Hakkımda',
            content: profile.bio!,
          ),
        SizedBox(height: 24.h),
        if (profile.skills.isNotEmpty)
          _buildSection(
            title: 'Yetenekler',
            content: profile.skills.join(', '),
          ),
        SizedBox(height: 24.h),
        if (profile.projects.isNotEmpty)
          _buildSection(
            title: 'Projeler',
            content: profile.projects.map((p) => p.title).join('\n'),
          ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          content,
          style: TextStyle(
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }
}
