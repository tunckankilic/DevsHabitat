import 'package:devshabitat/core/themes/colors.dart';
import 'package:flutter/material.dart';

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
  int _currentStep = 0;

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
      // TODO: Implement save functionality
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
            onImageSelected: (file) {
              // TODO: Implement image upload
            },
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
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Deneyim Seviyesi',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: 'JUNIOR',
                child: Text('Junior'),
              ),
              DropdownMenuItem(
                value: 'MID_LEVEL',
                child: Text('Mid Level'),
              ),
              DropdownMenuItem(
                value: 'SENIOR',
                child: Text('Senior'),
              ),
              DropdownMenuItem(
                value: 'LEAD',
                child: Text('Lead'),
              ),
            ],
            onChanged: (value) {
              // TODO: Implement experience level change
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
              isEmailPublic: false,
              isGitHubPublic: true,
              isProjectsPublic: true,
              isCertificationsPublic: true,
              isSocialLinksPublic: true,
            ),
            onSettingsChanged: (settings) {
              // TODO: Implement privacy settings update
            },
          ),
        ],
      ),
    );
  }
}
