import 'professional_insight.dart';

class NetworkAnalytics {
  final int totalConnections;
  final Map<String, int> connectionGrowth;
  final List<SkillCount> topSkillsInNetwork;
  final Map<String, int> locationDistribution;
  final Map<String, int> experienceLevelDistribution;
  final int networkReach;
  final List<ProfessionalInsight> professionalInsights;

  NetworkAnalytics({
    required this.totalConnections,
    required this.connectionGrowth,
    required this.topSkillsInNetwork,
    required this.locationDistribution,
    required this.experienceLevelDistribution,
    required this.networkReach,
    required this.professionalInsights,
  });

  Map<String, dynamic> toJson() => {
        'totalConnections': totalConnections,
        'connectionGrowth': connectionGrowth,
        'topSkillsInNetwork':
            topSkillsInNetwork.map((s) => s.toJson()).toList(),
        'locationDistribution': locationDistribution,
        'experienceLevelDistribution': experienceLevelDistribution,
        'networkReach': networkReach,
        'professionalInsights':
            professionalInsights.map((i) => i.toJson()).toList(),
      };

  factory NetworkAnalytics.fromJson(Map<String, dynamic> json) =>
      NetworkAnalytics(
        totalConnections: json['totalConnections'] as int,
        connectionGrowth:
            Map<String, int>.from(json['connectionGrowth'] as Map),
        topSkillsInNetwork: (json['topSkillsInNetwork'] as List)
            .map((s) => SkillCount.fromJson(s as Map<String, dynamic>))
            .toList(),
        locationDistribution:
            Map<String, int>.from(json['locationDistribution'] as Map),
        experienceLevelDistribution:
            Map<String, int>.from(json['experienceLevelDistribution'] as Map),
        networkReach: json['networkReach'] as int,
        professionalInsights: (json['professionalInsights'] as List)
            .map((i) => ProfessionalInsight.fromJson(i as Map<String, dynamic>))
            .toList(),
      );
}

class SkillCount {
  final String skill;
  final int count;

  SkillCount({required this.skill, required this.count});

  Map<String, dynamic> toJson() => {
        'skill': skill,
        'count': count,
      };

  factory SkillCount.fromJson(Map<String, dynamic> json) => SkillCount(
        skill: json['skill'] as String,
        count: json['count'] as int,
      );
}
