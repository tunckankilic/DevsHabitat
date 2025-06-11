import 'package:devshabitat/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../bloc/profile_form_bloc.dart';
import '../../../../core/services/firebase_service.dart';
import '../../domain/models/developer_profile.dart';

import '../widgets/profile_completion_indicator.dart';
import '../widgets/navigation_buttons.dart';
import '../widgets/skill_selection_widget.dart';
import '../widgets/image_upload_widget.dart';
import '../widgets/github_integration_widget.dart';
import '../widgets/project_showcase_widget.dart';
import '../widgets/certification_widget.dart';
import '../widgets/privacy_settings_widget.dart';
import '../../domain/models/profile_privacy_settings.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final PageController _pageController = PageController();
  final FirebaseService _firebaseService = FirebaseService();
  int _currentStep = 0;
  String? _profileImageUrl;

  Future<void> _uploadImage(String imagePath) async {
    try {
      final storageRef = _firebaseService.storage
          .ref()
          .child('profile_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = await storageRef.putFile(File(imagePath));
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      setState(() {
        _profileImageUrl = downloadUrl;
      });

      context.read<ProfileFormBloc>().add(
            UpdateBasicInfo(
              displayName: '', // Mevcut değerleri koruyun
              profileImageUrl: downloadUrl,
            ),
          );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resim yüklenirken hata oluştu: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      await _uploadImage(pickedFile.path);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 6) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep++;
      });
    } else {
      context.read<ProfileFormBloc>().add(SaveProfile());
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: DevHabitatColors.glassGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Profil Düzenle',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                              ),
                    ),
                  ],
                ),
              ),
              const ProfileCompletionIndicator(
                completionScore: 0.75,
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildBasicInfoStep(),
                    _buildProfessionalDetailsStep(),
                    _buildSkillsStep(),
                    _buildGitHubStep(),
                    _buildProjectsStep(),
                    _buildCertificationsStep(),
                    _buildPrivacyStep(),
                  ],
                ),
              ),
              NavigationButtons(
                currentStep: _currentStep,
                onNext: _nextStep,
                onPrevious: _previousStep,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Temel Bilgiler',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 24),
          ImageUploadWidget(
            aspectRatio: 1,
            currentImageUrl: _profileImageUrl,
            onImageSelected: _uploadImage,
          ),
          const SizedBox(height: 24),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Ad Soyad',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Ünvan',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'E-posta',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Konum',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Hakkımda',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profesyonel Detaylar',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<ExperienceLevel>(
            decoration: const InputDecoration(
              labelText: 'Deneyim Seviyesi',
              border: OutlineInputBorder(),
            ),
            items: ExperienceLevel.values.map((level) {
              return DropdownMenuItem(
                value: level,
                child: Text(level.toString().split('.').last),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                context.read<ProfileFormBloc>().add(
                      UpdateProfessionalDetails(
                        experienceLevel: value,
                      ),
                    );
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Şirket',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Pozisyon',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Website',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Yetenekler',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 24),
          const SkillSelectionWidget(
            skills: [],
            onSkillsChanged: null,
          ),
        ],
      ),
    );
  }

  Widget _buildGitHubStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GitHub Entegrasyonu',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 24),
          const GitHubIntegrationWidget(
            username: '',
            statistics: null,
            featuredRepositories: [],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Projeler',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 24),
          const ProjectShowcaseWidget(
            projects: [],
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sertifikalar',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 24),
          const CertificationWidget(
            certifications: [],
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gizlilik Ayarları',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 24),
          PrivacySettingsWidget(
            settings: ProfilePrivacySettings(
              isProfilePublic: true,
              showEmail: false,
              showLocation: true,
              showSocialLinks: true,
              showGitHubStats: true,
              showProjects: true,
              showCertifications: true,
              allowMessages: true,
              showOnlineStatus: true,
            ),
            onSettingsChanged: (settings) {
              context.read<ProfileFormBloc>().add(
                    UpdatePrivacySettings(settings),
                  );
            },
          ),
        ],
      ),
    );
  }
}
