import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:notas_app/features/home/domain/entities/dashboard_summary.dart';

part 'dashboard_summary_model.g.dart';

// Helper functions for JSON serialization of ActivityType enum
ActivityType _activityTypeFromJson(String type) =>
    ActivityType.values.firstWhere((e) => e.toString().split('.').last == type, orElse: () => ActivityType.noteCreated);
String _activityTypeToJson(ActivityType type) => type.toString().split('.').last;

@HiveType(typeId: 15)
@JsonSerializable()
class DashboardSummaryModel extends DashboardSummary {
  @override
  @JsonKey(name: 'quickActions')
  final List<QuickActionModel> quickActions;

  @override
  @JsonKey(name: 'recentActivities')
  final List<RecentActivityModel> recentActivities;

  const DashboardSummaryModel({
    required super.totalNotes,
    required super.completedTasks,
    required super.totalCategories,
    required super.productivityScore,
    required this.quickActions,
    required this.recentActivities,
    required super.lastUpdated,
  }) : super(
          quickActions: quickActions,
          recentActivities: recentActivities,
        );

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardSummaryModelToJson(this);

  factory DashboardSummaryModel.fromEntity(DashboardSummary entity) {
    return DashboardSummaryModel(
      totalNotes: entity.totalNotes,
      completedTasks: entity.completedTasks,
      totalCategories: entity.totalCategories,
      productivityScore: entity.productivityScore,
      quickActions: entity.quickActions
          .map((action) => QuickActionModel.fromEntity(action))
          .toList(),
      recentActivities: entity.recentActivities
          .map((activity) => RecentActivityModel.fromEntity(activity))
          .toList(),
      lastUpdated: entity.lastUpdated,
    );
  }

  @override
  DashboardSummary toEntity() {
    return DashboardSummary(
      totalNotes: totalNotes,
      completedTasks: completedTasks,
      totalCategories: totalCategories,
      productivityScore: productivityScore,
      quickActions: quickActions.map((action) => action.toEntity()).toList(),
      recentActivities:
          recentActivities.map((activity) => activity.toEntity()).toList(),
      lastUpdated: lastUpdated,
    );
  }
}

@HiveType(typeId: 16)
@JsonSerializable()
class QuickActionModel extends QuickAction {
  const QuickActionModel({
    required super.id,
    required super.title,
    required super.description,
    required super.iconData,
    required super.route,
    required super.isEnabled,
    required super.sortOrder,
    required super.createdAt,
  });

  factory QuickActionModel.fromJson(Map<String, dynamic> json) =>
      _$QuickActionModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuickActionModelToJson(this);

  factory QuickActionModel.fromEntity(QuickAction entity) {
    return QuickActionModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      iconData: entity.iconData,
      route: entity.route,
      isEnabled: entity.isEnabled,
      sortOrder: entity.sortOrder,
      createdAt: entity.createdAt,
    );
  }

  @override
  QuickAction toEntity() {
    return QuickAction(
      id: id,
      title: title,
      description: description,
      iconData: iconData,
      route: route,
      isEnabled: isEnabled,
      sortOrder: sortOrder,
      createdAt: createdAt,
    );
  }
}

@HiveType(typeId: 19)
@JsonSerializable()
class RecentActivityModel extends RecentActivity {
  const RecentActivityModel({
    required super.id,
    required super.type,
    required super.title,
    required super.description,
    required super.timestamp,
    required super.entityId,
    required super.metadata,
  });

  factory RecentActivityModel.fromJson(Map<String, dynamic> json) =>
      _$RecentActivityModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecentActivityModelToJson(this);

  factory RecentActivityModel.fromEntity(RecentActivity entity) {
    return RecentActivityModel(
      id: entity.id,
      type: entity.type,
      title: entity.title,
      description: entity.description,
      timestamp: entity.timestamp,
      entityId: entity.entityId,
      metadata: entity.metadata,
    );
  }

  @override
  RecentActivity toEntity() {
    return RecentActivity(
      id: id,
      type: type,
      title: title,
      description: description,
      timestamp: timestamp,
      entityId: entityId,
      metadata: metadata,
    );
  }
}
