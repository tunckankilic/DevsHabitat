import 'package:flutter/material.dart';
import 'package:devshabitat/core/themes/colors.dart';

class SkillSelectionWidget extends StatefulWidget {
  final List<String> skills;
  final bool readOnly;
  final Function(List<String>)? onSkillsChanged;

  const SkillSelectionWidget({
    Key? key,
    required this.skills,
    this.readOnly = false,
    this.onSkillsChanged,
  }) : super(key: key);

  @override
  State<SkillSelectionWidget> createState() => _SkillSelectionWidgetState();
}

class _SkillSelectionWidgetState extends State<SkillSelectionWidget> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _suggestedSkills = [
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
    'NoSQL',
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
    'Shell',
    'Bash',
  ];

  List<String> _filteredSkills = [];

  @override
  void initState() {
    super.initState();
    _filteredSkills = _suggestedSkills;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterSkills(String query) {
    setState(() {
      _filteredSkills = _suggestedSkills
          .where((skill) =>
              skill.toLowerCase().contains(query.toLowerCase()) &&
              !widget.skills.contains(skill))
          .toList();
    });
  }

  void _addSkill(String skill) {
    if (!widget.skills.contains(skill)) {
      final updatedSkills = List<String>.from(widget.skills)..add(skill);
      widget.onSkillsChanged?.call(updatedSkills);
    }
    _searchController.clear();
    _filterSkills('');
  }

  void _removeSkill(String skill) {
    final updatedSkills = List<String>.from(widget.skills)..remove(skill);
    widget.onSkillsChanged?.call(updatedSkills);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.readOnly)
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Yetenek Ara',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: _filterSkills,
          ),
        if (!widget.readOnly && _filteredSkills.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: DevHabitatColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredSkills.length,
              itemBuilder: (context, index) {
                final skill = _filteredSkills[index];
                return ListTile(
                  title: Text(skill),
                  onTap: () => _addSkill(skill),
                );
              },
            ),
          ),
        ],
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.skills.map((skill) {
            return Chip(
              label: Text(skill),
              backgroundColor: DevHabitatColors.primary.withOpacity(0.2),
              labelStyle: const TextStyle(
                color: DevHabitatColors.primary,
              ),
              onDeleted: widget.readOnly ? null : () => _removeSkill(skill),
            );
          }).toList(),
        ),
      ],
    );
  }
}
