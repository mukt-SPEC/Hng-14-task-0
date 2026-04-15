import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:unitcoverter/Model/todo_model.dart';
import 'package:unitcoverter/presentation/widget/todo_bottom_sheet.dart';
import 'package:unitcoverter/provider/theme_provider.dart';
import 'package:unitcoverter/provider/todo_provider.dart';
import 'package:unitcoverter/theme/appcolor.dart';
import 'package:unitcoverter/theme/text_styles.dart';
import 'package:unitcoverter/utils/extensions.dart';

class TodoPage extends ConsumerWidget {
  const TodoPage({super.key});

  void _openSheet(BuildContext context, {TodoModel? todo}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => TodoBottomSheet(todo: todo),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);
    final colors = isDark ? AppColors.dark : AppColors.light;
    final todos = ref.watch(todoNotifierProvider);

    return Scaffold(
      backgroundColor: colors.backgroundColor,
      appBar: AppBar(
        titleSpacing: 16,
        elevation: 0,
        title: Text('Todo', style: AppTextStyles.titleLarge),
        backgroundColor: Colors.transparent,
        foregroundColor: colors.textColor,
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () => _openSheet(context),
        backgroundColor: colors.buttonColor,
        child: const PhosphorIcon(PhosphorIconsBold.plus, color: Colors.white),
      ),
      body: todos.isEmpty
          ? _EmptyState(colors: colors)
          : _TodoList(
              todos: todos,
              colors: colors,
              onEdit: (todo) => _openSheet(context, todo: todo),
              ref: ref,
            ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final AppColors colors;
  const _EmptyState({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PhosphorIcon(
              PhosphorIconsRegular.clipboardText,
              size: 72,
              color: colors.secondaryTextColor.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 20),
            Text(
              'No tasks yet',
              style: AppTextStyles.monoTitleLarge.copyWith(
                color: colors.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button below to create your first task.',
              style: AppTextStyles.monoBodyMedium.copyWith(
                color: colors.secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _TodoList extends ConsumerWidget {
  final List<TodoModel> todos;
  final AppColors colors;
  final void Function(TodoModel) onEdit;
  final WidgetRef ref;

  const _TodoList({
    required this.todos,
    required this.colors,
    required this.onEdit,
    required this.ref,
  });

  @override
  Widget build(BuildContext context, WidgetRef widgetRef) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: todos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final todo = todos[index];
        return _TodoCard(
          todo: todo,
          colors: colors,
          onEdit: () => onEdit(todo),
          onToggle: () => widgetRef
              .read(todoNotifierProvider.notifier)
              .toggleComplete(todo),
          onDelete: () =>
              widgetRef.read(todoNotifierProvider.notifier).deleteTodo(todo),
        );
      },
    );
  }
}

class _TodoCard extends StatelessWidget {
  final TodoModel todo;
  final AppColors colors;
  final VoidCallback onEdit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _TodoCard({
    required this.todo,
    required this.colors,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isOverdue =
        !todo.isCompleted && todo.dueDate.isBefore(DateTime.now());

    return Dismissible(
      key: ValueKey(todo.key),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const PhosphorIcon(
          PhosphorIconsBold.trash,
          color: Colors.white,
          size: 22,
        ),
      ),
      child: GestureDetector(
        onTap: onEdit,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: colors.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: todo.isCompleted
                  ? Colors.green.withValues(alpha: 0.3)
                  : isOverdue
                  ? Colors.red.withValues(alpha: 0.3)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox
              GestureDetector(
                onTap: onToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: todo.isCompleted ? Colors.green : Colors.transparent,
                    border: Border.all(
                      color: todo.isCompleted
                          ? Colors.green
                          : colors.secondaryTextColor,
                      width: 2,
                    ),
                  ),
                  child: todo.isCompleted
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 14),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title.capitalize(),
                      style: AppTextStyles.monoBodyLarge.copyWith(
                        color: todo.isCompleted
                            ? colors.secondaryTextColor
                            : colors.textColor,

                        fontWeight: FontWeight.w600,
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: colors.secondaryTextColor,
                      ),
                    ),
                    if (todo.note.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        todo.note,
                        style: AppTextStyles.monoBodyMedium.copyWith(
                          color: colors.secondaryTextColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        PhosphorIcon(
                          PhosphorIconsFill.calendar,
                          size: 16,
                          color: isOverdue
                              ? Colors.red.shade400
                              : colors.secondaryTextColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM d, y').format(todo.dueDate),
                          style: AppTextStyles.labelMedium.copyWith(
                            color: isOverdue
                                ? Colors.red.shade400
                                : colors.secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: PhosphorIcon(
                  PhosphorIconsFill.pencilSimple,
                  size: 16,
                  color: colors.secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
