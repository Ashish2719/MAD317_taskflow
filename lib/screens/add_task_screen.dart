import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../models/category_model.dart';
import 'dart:math';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  String _selectedCategory = 'Work';

  InputDecoration _inputDecor(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF6B7280)),
      prefixIcon: Icon(icon, color: const Color(0xFF6366F1), size: 20),
      filled: true,
      fillColor: const Color(0xFFF8F7FF),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                )
              ],
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: Color(0xFF1F1F3C)),
          ),
        ),
        title: const Text(
          'New Task',
          style: TextStyle(
            color: Color(0xFF1F1F3C),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: _inputDecor('Task Title', Icons.edit_rounded),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descController,
                    maxLines: 3,
                    decoration: _inputDecor('Description (optional)', Icons.notes_rounded),
                  ),
                  const SizedBox(height: 16),

                  // Category
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: _inputDecor('Category', Icons.label_outline_rounded),
                    borderRadius: BorderRadius.circular(16),
                    items: defaultCategories
                        .map((c) => DropdownMenuItem(
                      value: c.name,
                      child: Text(c.name),
                    ))
                        .toList(),
                    onChanged: (val) =>
                        setState(() => _selectedCategory = val!),
                  ),
                  const SizedBox(height: 16),

                  // Due date
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _dueDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF6366F1),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) setState(() => _dueDate = picked);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F7FF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month_rounded,
                              color: Color(0xFF6366F1), size: 20),
                          const SizedBox(width: 12),
                          Text(
                            'Due: ${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                            style: const TextStyle(
                              color: Color(0xFF374151),
                              fontSize: 15,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.chevron_right_rounded,
                              color: Color(0xFF9CA3AF)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Add button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  if (_titleController.text.isEmpty) return;
                  final task = Task(
                    id: Random().nextInt(99999).toString(),
                    title: _titleController.text,
                    description: _descController.text,
                    dueDate: _dueDate,
                    category: _selectedCategory,
                  );
                  Navigator.pop(context, task);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Add Task',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}