import 'package:notas_app/features/home/data/models/dashboard_summary_model.dart';
import 'package:notas_app/features/home/domain/entities/dashboard_summary.dart';

void main() {
  print('Testing home module import resolution...');
  
  // Test if we can create instances of the classes
  try {
    final summary = DashboardSummaryModel(
      totalNotes: 5,
      completedTasks: 3,
      totalCategories: 2,
      productivityScore: 0.8,
      quickActions: [],
      recentActivities: [],
      lastUpdated: DateTime.now(),
    );
    print('✅ DashboardSummaryModel created successfully: ${summary.totalNotes} notes');
    
    final action = QuickActionModel(
      id: 'test',
      title: 'Test Action',
      description: 'Test Description',
      iconData: 'icon',
      route: '/test',
      isEnabled: true,
      sortOrder: 1,
      createdAt: DateTime.now(),
    );
    print('✅ QuickActionModel created successfully: ${action.title}');
    
    print('✅ All models working correctly!');
  } catch (e) {
    print('❌ Error creating models: $e');
  }
}
