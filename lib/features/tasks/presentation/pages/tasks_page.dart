import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/task.dart' as TaskEntity;
import '../bloc/tasks_bloc.dart';
import '../bloc/tasks_event.dart';
import '../bloc/tasks_state.dart';
import '../widgets/task_card.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final TextEditingController _searchController = TextEditingController();
  TaskFilter _currentFilter = TaskFilter.all;

  @override
  void initState() {
    super.initState();
    context.read<TasksBloc>().add(const LoadTasks());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildSearchBar(context),
          _buildFilterChips(context),
          Expanded(
            child: BlocConsumer<TasksBloc, TasksState>(
              listener: (context, state) {
                if (state is TasksError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                      action: SnackBarAction(
                        label: 'Retry',
                        textColor: Colors.white,
                        onPressed: () {
                          context.read<TasksBloc>().add(const LoadTasks());
                        },
                      ),
                    ),
                  );
                } else if (state is TaskOperationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is TasksInitial || state is TasksLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TasksLoaded) {
                  return _buildTasksList(context, state);
                } else if (state is TasksError) {
                  return _buildErrorView(context, state);
                } else if (state is TaskOperationInProgress) {
                  return _buildOperationInProgress(context, state);
                }
                
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateTaskDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Tasks',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            context.read<TasksBloc>().add(const LoadTasks());
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            switch (value) {
              case 'stats':
                context.go('/stats');
                break;
              case 'export':
                context.go('/export');
                break;
              case 'categories':
                context.go('/categories');
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'categories',
              child: Row(
                children: [
                  Icon(Icons.category),
                  SizedBox(width: 8),
                  Text('Categories'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'stats',
              child: Row(
                children: [
                  Icon(Icons.analytics),
                  SizedBox(width: 8),
                  Text('Statistics'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'export',
              child: Row(
                children: [
                  Icon(Icons.download),
                  SizedBox(width: 8),
                  Text('Export'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search tasks...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<TasksBloc>().add(const SearchTasks(''));
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (query) {
          context.read<TasksBloc>().add(SearchTasks(query));
        },
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: TaskFilter.values.map((filter) {
          final isSelected = _currentFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(_getFilterLabel(filter)),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _currentFilter = filter;
                });
                context.read<TasksBloc>().add(FilterTasks(filter));
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTasksList(BuildContext context, TasksLoaded state) {
    if (state.filteredTasks.isEmpty) {
      return _buildEmptyView(context, state);
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<TasksBloc>().add(const LoadTasks());
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: state.filteredTasks.length,
        itemBuilder: (context, index) {
          final task = state.filteredTasks[index];
          return TaskCard(
            task: task,
            onTap: () {
              context.go('/tasks/${task.id}');
            },
            onToggleComplete: () {
              context.read<TasksBloc>().add(ToggleTaskCompletion(task.id));
            },
            onEdit: () {
              context.go('/tasks/${task.id}/edit');
            },
            onDelete: () {
              _showDeleteConfirmation(context, task);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context, TasksLoaded state) {
    String message;
    String subtitle;
    IconData icon;

    if (state.isSearching) {
      message = 'No tasks found';
      subtitle = 'Try adjusting your search terms';
      icon = Icons.search_off;
    } else if (_currentFilter != TaskFilter.all) {
      message = 'No ${_getFilterLabel(_currentFilter).toLowerCase()}';
      subtitle = 'Try changing your filter or create a new task';
      icon = Icons.filter_list_off;
    } else {
      message = 'No tasks yet';
      subtitle = 'Create your first task to get started';
      icon = Icons.task_alt;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (!state.isSearching && _currentFilter == TaskFilter.all)
            ElevatedButton.icon(
              onPressed: () {
                _showCreateTaskDialog(context);
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Task'),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, TasksError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            state.message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<TasksBloc>().add(const LoadTasks());
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationInProgress(BuildContext context, TaskOperationInProgress state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            state.operation,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  void _showCreateTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => _CreateTaskDialog(),
    );
  }

  void _showDeleteConfirmation(BuildContext context, TaskEntity.Task task) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<TasksBloc>().add(DeleteTask(task.id));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _getFilterLabel(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.all:
        return 'All';
      case TaskFilter.pending:
        return 'Pending';
      case TaskFilter.completed:
        return 'Completed';
      case TaskFilter.highPriority:
        return 'High Priority';
      case TaskFilter.dueToday:
        return 'Due Today';
      case TaskFilter.overdue:
        return 'Overdue';
    }
  }
}

class _CreateTaskDialog extends StatefulWidget {
  @override
  State<_CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<_CreateTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TaskEntity.TaskPriority _priority = TaskEntity.TaskPriority.medium;
  DateTime? _dueDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Task'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TaskEntity.TaskPriority>(
              value: _priority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
              items: TaskEntity.TaskPriority.values.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(_getPriorityLabel(priority)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _priority = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _dueDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() {
                    _dueDate = date;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 8),
                    Text(
                      _dueDate != null
                          ? 'Due: ${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
                          : 'Set due date (optional)',
                    ),
                    const Spacer(),
                    if (_dueDate != null)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _dueDate = null;
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<TasksBloc>().add(CreateTask(
                title: _titleController.text.trim(),
                description: _descriptionController.text.trim(),
                priority: _priority,
                dueDate: _dueDate,
              ));
              Navigator.of(context).pop();
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }

  String _getPriorityLabel(TaskEntity.TaskPriority priority) {
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
}
