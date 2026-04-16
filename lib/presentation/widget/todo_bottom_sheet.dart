import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:unitcoverter/model/todo_model.dart';
import 'package:unitcoverter/provider/theme_provider.dart';
import 'package:unitcoverter/provider/todo_provider.dart';
import 'package:unitcoverter/theme/appcolor.dart';
import 'package:unitcoverter/theme/text_styles.dart';

class TodoBottomSheet extends ConsumerStatefulWidget {
  /// Pass an existing [todo] to edit; leave null to create a new one.
  final TodoModel? todo;

  const TodoBottomSheet({super.key, this.todo});

  @override
  ConsumerState<TodoBottomSheet> createState() => _TodoBottomSheetState();
}

class _TodoBottomSheetState extends ConsumerState<TodoBottomSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _noteController;
  late DateTime _selectedDate;
  bool _showDatePicker = false;
  bool _titleTouched = false;

  bool get _isEditing => widget.todo != null;

  bool get _titleValid => _titleController.text.trim().isNotEmpty;
  bool get _canSubmit => _titleValid;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    _noteController = TextEditingController(text: widget.todo?.note ?? '');
    _selectedDate = widget.todo?.dueDate ?? DateTime.now();
    _titleController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _titleTouched = true);
    if (!_canSubmit) return;

    final title = _titleController.text.trim();
    final note = _noteController.text.trim();
    final notifier = ref.read(todoNotifierProvider.notifier);

    if (_isEditing) {
      final updated = widget.todo!.copyWith(
        title: title,
        note: note,
        dueDate: _selectedDate,
      );
      await notifier.editTodo(widget.todo!.key as int?, updated);
    } else {
      await notifier.addTodo(
        todo: TodoModel(
          title: title,
          note: note,
          dueDate: _selectedDate,
          isCompleted: false,
        ),
      );
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDark =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);
    final colors = isDark ? AppColors.dark : AppColors.light;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final keyboardOpen = bottomInset > 0;
    final showInlineDatePicker = _showDatePicker && !keyboardOpen;
    final now = DateTime.now();

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: bottomInset + 24,
      ),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isEditing ? 'Edit Task' : 'New Task',
                    style: AppTextStyles.monoTitleLarge.copyWith(
                      color: colors.textColor,
                    ),
                  ),
                  IconButton.filled(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: PhosphorIcon(
                      PhosphorIconsBold.x,
                      size: 16,
                      color: colors.textColor,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: colors.cardColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _InputField(
                controller: _titleController,
                label: 'Title',
                hint: 'What needs to be done?',
                colors: colors,
                errorText: (_titleTouched && !_titleValid)
                    ? 'Title cannot be empty'
                    : null,
                onChanged: (_) => setState(() => _titleTouched = true),
              ),
              const SizedBox(height: 12),

              _InputField(
                controller: _noteController,
                label: 'Note',
                hint: 'Add a note (optional)',
                colors: colors,
                maxLines: 3,
              ),
              const SizedBox(height: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 6),
                    child: Text(
                      'Due Date',
                      style: AppTextStyles.monoLabel.copyWith(
                        color: colors.secondaryTextColor,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      setState(() => _showDatePicker = !_showDatePicker);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: colors.cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          PhosphorIcon(
                            PhosphorIconsRegular.calendar,
                            color: colors.secondaryTextColor,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            DateFormat('EEE, MMM d y').format(_selectedDate),
                            style: AppTextStyles.monoBodyMedium.copyWith(
                              color: colors.textColor,
                            ),
                          ),
                          const Spacer(),
                          PhosphorIcon(
                            showInlineDatePicker
                                ? PhosphorIconsRegular.caretUp
                                : PhosphorIconsRegular.caretDown,
                            color: colors.secondaryTextColor,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: showInlineDatePicker
                    ? Container(
                        height: 180,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          color: colors.cardColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: _selectedDate,
                          minimumDate: DateTime(now.year, now.month, now.day),
                          maximumDate: DateTime(2100),
                          onDateTimeChanged: (date) {
                            setState(() {
                              _selectedDate = date;
                            });
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 24),

              FilledButton(
                onPressed: _canSubmit ? _submit : null,
                style: FilledButton.styleFrom(
                  backgroundColor: _canSubmit
                      ? colors.buttonColor
                      : colors.secondaryTextColor.withValues(alpha: 0.3),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _isEditing ? 'Save Changes' : 'Add Task',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: _canSubmit
                        ? Colors.white
                        : colors.secondaryTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final AppColors colors;
  final int maxLines;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.colors,
    this.maxLines = 1,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: AppTextStyles.monoLabel.copyWith(
              color: hasError ? Colors.red.shade400 : colors.secondaryTextColor,
            ),
          ),
        ),
        TextField(
          controller: controller,
          maxLines: maxLines,
          onChanged: onChanged,
          style: AppTextStyles.monoBodyMedium.copyWith(color: colors.textColor),
          cursorColor: colors.textColor,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.monoBodyMedium.copyWith(
              color: colors.secondaryTextColor.withValues(alpha: 0.6),
            ),
            filled: true,
            fillColor: colors.cardColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: hasError
                  ? BorderSide(color: Colors.red.shade400, width: 1.2)
                  : BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: hasError
                  ? BorderSide(color: Colors.red.shade400, width: 1.5)
                  : BorderSide(color: colors.buttonColor, width: 1.5),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 5),
            child: Text(
              errorText!,
              style: AppTextStyles.labelSmall.copyWith(
                color: Colors.red.shade400,
              ),
            ),
          ),
      ],
    );
  }
}
