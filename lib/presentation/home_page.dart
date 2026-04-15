import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:unitcoverter/Model/todo_model.dart';
import 'package:unitcoverter/provider/theme_provider.dart';
import 'package:unitcoverter/provider/todo_provider.dart';
import 'package:unitcoverter/theme/appcolor.dart';
import 'package:unitcoverter/theme/text_styles.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
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
    final todayTasks = todos.where((t) => _isToday(t.dueDate)).toList();
    final pendingTodayCount = todayTasks.where((t) => !t.isCompleted).length;

    return Scaffold(
      backgroundColor: colors.backgroundColor,
      appBar: AppBar(
        titleSpacing: 16,
        elevation: 0,
        title: Text("Quattro", style: AppTextStyles.titleLarge),
        backgroundColor: Colors.transparent,
        foregroundColor: colors.textColor,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headline row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: colors.secondaryTextColor,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    children: [
                      const TextSpan(text: 'Your all in one \n'),
                      TextSpan(
                        text: 'Productivity',
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: colors.buttonColor,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const TextSpan(text: ' Suite'),
                    ],
                  ),
                ),
                IconButton.filled(
                  onPressed: () {
                    ref
                        .read(themeProvider.notifier)
                        .setTheme(isDark ? ThemeMode.light : ThemeMode.dark);
                  },
                  icon: PhosphorIcon(
                    isDark ? PhosphorIconsFill.sun : PhosphorIconsFill.moon,
                    size: 22,
                    color: colors.textColor,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: colors.cardColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Today reminder card
            _TodayReminderCard(
              colors: colors,
              isDark: isDark,
              todayTasks: todayTasks,
              pendingCount: pendingTodayCount,
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayReminderCard extends StatelessWidget {
  final AppColors colors;
  final bool isDark;
  final List<TodoModel> todayTasks;
  final int pendingCount;

  const _TodayReminderCard({
    required this.colors,
    required this.isDark,
    required this.todayTasks,
    required this.pendingCount,
  });

  @override
  Widget build(BuildContext context) {
    final hasTasksToday = todayTasks.isNotEmpty;
    final allDone = hasTasksToday && pendingCount == 0;

    final String header;
    final String subtitle;
    final IconData icon;
    final Color accent;

    if (!hasTasksToday) {
      header = 'A clear slate today 🌿';
      subtitle =
          'No tasks scheduled — enjoy the breathing room, or plan something great.';
      icon = PhosphorIconsFill.coffee;
      accent = colors.secondaryTextColor;
    } else if (allDone) {
      header = 'You crushed it! 🎉';
      subtitle =
          'All ${todayTasks.length} task${todayTasks.length > 1 ? 's' : ''} for today are done. Take a bow.';
      icon = PhosphorIconsFill.checkCircle;
      accent = Colors.green;
    } else {
      header = pendingCount == 1
          ? 'One more to go 💪'
          : '$pendingCount tasks left today';
      subtitle = pendingCount == todayTasks.length
          ? 'You\'ve got ${todayTasks.length} task${todayTasks.length > 1 ? 's' : ''} lined up — let\'s get moving!'
          : '${todayTasks.length - pendingCount} of ${todayTasks.length} done. Keep the momentum going!';
      icon = PhosphorIconsFill.flame;
      accent = colors.buttonColor;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.25), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date chip
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  DateFormat('EEEE, MMM d').format(DateTime.now()),
                  style: AppTextStyles.monoLabel.copyWith(color: accent),
                ),
              ),
              const Spacer(),
              PhosphorIcon(icon, color: accent, size: 22),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            header,
            style: AppTextStyles.titleSmall.copyWith(color: colors.textColor),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: colors.secondaryTextColor,
              height: 1.5,
            ),
          ),
          if (hasTasksToday && !allDone) ...[
            const SizedBox(height: 16),

            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (todayTasks.length - pendingCount) / todayTasks.length,
                minHeight: 4,
                backgroundColor: accent.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(accent),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${todayTasks.length - pendingCount} / ${todayTasks.length} complete',
              style: AppTextStyles.labelSmall.copyWith(
                color: colors.secondaryTextColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
