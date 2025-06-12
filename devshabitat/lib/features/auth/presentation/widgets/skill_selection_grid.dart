import 'package:devshabitat/core/theme/dev_habitat_colors.dart';
import 'package:devshabitat/core/theme/devhabitat_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:devshabitat/features/auth/presentation/blocs/register/register_bloc.dart';
import 'package:devshabitat/features/auth/presentation/cubits/form_validation_cubit.dart';

class SkillSelectionGrid extends StatefulWidget {
  const SkillSelectionGrid({super.key});

  @override
  State<SkillSelectionGrid> createState() => _SkillSelectionGridState();
}

class _SkillSelectionGridState extends State<SkillSelectionGrid> {
  final List<String> _selectedSkills = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _allSkills = [
    'Flutter',
    'Dart',
    'React',
    'React Native',
    'JavaScript',
    'TypeScript',
    'Node.js',
    'Python',
    'Java',
    'Kotlin',
    'Swift',
    'Objective-C',
    'C#',
    '.NET',
    'PHP',
    'Ruby',
    'Go',
    'Rust',
    'C++',
    'C',
    'HTML',
    'CSS',
    'SASS',
    'LESS',
    'SQL',
    'MongoDB',
    'PostgreSQL',
    'MySQL',
    'Redis',
    'Docker',
    'Kubernetes',
    'AWS',
    'Azure',
    'GCP',
    'Firebase',
    'GraphQL',
    'REST',
    'gRPC',
    'WebSocket',
    'Git',
    'CI/CD',
    'Agile',
    'Scrum',
    'TDD',
    'BDD',
    'DevOps',
    'Linux',
    'Shell Scripting',
    'UI/UX Design',
    'Figma',
    'Adobe XD',
    'Sketch',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _filteredSkills {
    if (_searchQuery.isEmpty) {
      return _allSkills;
    }
    return _allSkills
        .where(
            (skill) => skill.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _toggleSkill(String skill) {
    setState(() {
      if (_selectedSkills.contains(skill)) {
        _selectedSkills.remove(skill);
      } else {
        _selectedSkills.add(skill);
      }
    });

    context.read<FormValidationCubit>().validateSkills(_selectedSkills);
    context.read<RegisterBloc>().add(
          FormDataUpdated({'skills': _selectedSkills}),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Beceri ara...',
            hintStyle: DevHabitatTheme.bodyMedium.copyWith(
              color: DevHabitatColors.textTertiary,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: DevHabitatColors.textSecondary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: DevHabitatColors.glassBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: DevHabitatColors.glassBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: DevHabitatColors.primary,
              ),
            ),
            filled: true,
            fillColor: DevHabitatColors.glassBackground,
          ),
        ),
        const SizedBox(height: 16),
        if (_selectedSkills.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedSkills.map((skill) {
              return Chip(
                label: Text(skill),
                onDeleted: () => _toggleSkill(skill),
                backgroundColor: DevHabitatColors.primary,
                labelStyle: DevHabitatTheme.labelMedium.copyWith(
                  color: DevHabitatColors.textPrimary,
                ),
                deleteIconColor: DevHabitatColors.textPrimary,
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
        Container(
          decoration: BoxDecoration(
            color: DevHabitatColors.glassBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: DevHabitatColors.glassBorder,
            ),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _filteredSkills.length,
            itemBuilder: (context, index) {
              final skill = _filteredSkills[index];
              final isSelected = _selectedSkills.contains(skill);

              return InkWell(
                onTap: () => _toggleSkill(skill),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? DevHabitatColors.primary
                        : DevHabitatColors.glassBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? DevHabitatColors.primary
                          : DevHabitatColors.glassBorder,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      skill,
                      style: DevHabitatTheme.labelMedium.copyWith(
                        color: isSelected
                            ? DevHabitatColors.textPrimary
                            : DevHabitatColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
