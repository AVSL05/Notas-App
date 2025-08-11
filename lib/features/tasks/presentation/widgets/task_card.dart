import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/task.dart' as TaskEntity;

class TaskCard extends StatelessWidget {
  final TaskEntity.Task task;
  final VoidCallback? onTap;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showMenu;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onToggleComplete,
    this.onEdit,
    this.onDelete,
    this.showMenu = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = task.isCompleted;
    final isOverdue = _isOverdue();
    final priorityColor = _getPriorityColor(task.priority);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: isCompleted ? 1 : 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: priorityColor.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with checkbox and menu
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Checkbox
                  GestureDetector(
                    onTap: onToggleComplete,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCompleted ? priorityColor : Colors.grey,
                          width: 2,
                        ),
                        color: isCompleted ? priorityColor : Colors.transparent,
                      ),
                      child: isCompleted
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Task content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          task.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            decoration: isCompleted 
                                ? TextDecoration.lineThrough 
                                : null,
                            color: isCompleted 
                                ? theme.colorScheme.onSurface.withOpacity(0.6)
                                : null,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        
                        // Description
                        if (task.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            task.description,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              decoration: isCompleted 
                                  ? TextDecoration.lineThrough 
                                  : null,
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        
                        const SizedBox(height: 8),
                        
                        // Meta information row
                        _buildMetaRow(theme, isOverdue),
                      ],
                    ),
                  ),
                  
                  // Menu button
                  if (showMenu)
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            onEdit?.call();
                            break;
                          case 'delete':
                            onDelete?.call();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 20),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 20, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              
              // Progress for subtasks (if any)
              if (task.steps.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildProgressIndicator(theme),
              ],
              
              // Tags
              if (task.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildTags(theme),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetaRow(ThemeData theme, bool isOverdue) {
    return Row(
      children: [
        // Priority indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _getPriorityColor(task.priority).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _getPriorityText(task.priority),
            style: theme.textTheme.labelSmall?.copyWith(
              color: _getPriorityColor(task.priority),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        const SizedBox(width: 8),
        
        // Due date
        if (task.dueDate != null) ...[
          Icon(
            Icons.schedule,
            size: 14,
            color: isOverdue 
                ? Colors.red 
                : theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(width: 4),
          Text(
            _formatDueDate(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: isOverdue 
                  ? Colors.red 
                  : theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
        
        const Spacer(),
        
        // Created date
        Text(
          DateFormat('MMM dd').format(task.createdAt),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(ThemeData theme) {
    final completedSteps = task.steps.where((step) => step.isCompleted).length;
    final totalSteps = task.steps.length;
    final progress = totalSteps > 0 ? completedSteps / totalSteps : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Subtasks',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            Text(
              '$completedSteps/$totalSteps',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: theme.colorScheme.outline.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(
            _getPriorityColor(task.priority),
          ),
        ),
      ],
    );
  }

  Widget _buildTags(ThemeData theme) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: task.tags.take(3).map((tag) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '#$tag',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
      )).toList(),
    );
  }

  Color _getPriorityColor(TaskEntity.TaskPriority priority) {
    switch (priority) {
      case TaskEntity.TaskPriority.low:
        return Colors.green;
      case TaskEntity.TaskPriority.medium:
        return Colors.orange;
      case TaskEntity.TaskPriority.high:
        return Colors.red;
      case TaskEntity.TaskPriority.critical:
        return Colors.purple;
    }
  }

  String _getPriorityText(TaskEntity.TaskPriority priority) {
    switch (priority) {
      case TaskEntity.TaskPriority.low:
        return 'Low';
      case TaskEntity.TaskPriority.medium:
        return 'Medium';  
      case TaskEntity.TaskPriority.high:
        return 'High';
      case TaskEntity.TaskPriority.critical:
        return 'Critical';
    }
  }

  bool _isOverdue() {
    if (task.dueDate == null || task.isCompleted) return false;
    return task.dueDate!.isBefore(DateTime.now());
  }

  String _formatDueDate() {
    if (task.dueDate == null) return '';
    
    final now = DateTime.now();
    final dueDate = task.dueDate!;
    final difference = dueDate.difference(now).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference == -1) {
      return 'Yesterday';
    } else if (difference > 1 && difference <= 7) {
      return DateFormat('EEEE').format(dueDate);
    } else {
      return DateFormat('MMM dd').format(dueDate);
    }
  }
}
