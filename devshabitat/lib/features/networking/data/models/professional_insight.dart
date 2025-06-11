enum InsightType {
  skillGap,
  networkDiversity,
  careerGrowth,
  industryTrend,
  collaborationOpportunity
}

enum InsightPriority { low, medium, high }

class ProfessionalInsight {
  final InsightType type;
  final String title;
  final String description;
  final bool actionable;
  final InsightPriority priority;

  ProfessionalInsight({
    required this.type,
    required this.title,
    required this.description,
    required this.actionable,
    required this.priority,
  });

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'title': title,
        'description': description,
        'actionable': actionable,
        'priority': priority.name,
      };

  factory ProfessionalInsight.fromJson(Map<String, dynamic> json) =>
      ProfessionalInsight(
        type: InsightType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => InsightType.skillGap,
        ),
        title: json['title'],
        description: json['description'],
        actionable: json['actionable'],
        priority: InsightPriority.values.firstWhere(
          (e) => e.name == json['priority'],
          orElse: () => InsightPriority.medium,
        ),
      );
}
