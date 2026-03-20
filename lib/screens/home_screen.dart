import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TaskService _taskService = TaskService();
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final all = _taskService.getAllTasks();
    final done = _taskService.getCompletedTasks();
    final active = _taskService.getActiveTasks();
    final progress = all.isEmpty ? 0.0 : done.length / all.length;
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),
        body: Column(
          children: [
            // ── Gradient Header ──
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Good Morning,',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Ashish 👋',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.notifications_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ── Stat Cards ──
                      Row(
                        children: [
                          _statCard('Total', '${all.length}',
                              Icons.list_alt_rounded),
                          const SizedBox(width: 10),
                          _statCard('Active', '${active.length}',
                              Icons.pending_actions_rounded),
                          const SizedBox(width: 10),
                          _statCard(
                              'Done', '${done.length}', Icons.check_circle_rounded),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── Progress ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Overall Progress',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                          Text('${(progress * 100).toInt()}%',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.white24,
                          color: Colors.white,
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── My Tasks + Tab ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Tasks',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F1F3C),
                    ),
                  ),
                  Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE9FE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      labelColor: Colors.white,
                      unselectedLabelColor: const Color(0xFF6366F1),
                      labelStyle: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600),
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        color: const Color(0xFF6366F1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelPadding:
                      const EdgeInsets.symmetric(horizontal: 14),
                      tabs: const [
                        Tab(text: 'All', height: 36),
                        Tab(text: 'Active', height: 36),
                        Tab(text: 'Done', height: 36),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── Task List ──
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTaskList(_taskService.getAllTasks()),
                  _buildTaskList(_taskService.getActiveTasks()),
                  _buildTaskList(_taskService.getCompletedTasks()),
                ],
              ),
            ),
          ],
        ),

        // ── Bottom Nav ──
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, -2),
              )
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: BottomAppBar(
              color: Colors.white,
              elevation: 0,
              notchMargin: 8,
              shape: const CircularNotchedRectangle(),
              child: SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _navItem(Icons.home_rounded, 'Home', 0),
                    _navItem(Icons.check_circle_outline_rounded, 'Tasks', 1),
                    const SizedBox(width: 48), // FAB space
                    _navItem(Icons.bar_chart_rounded, 'Stats', 2),
                    _navItem(Icons.person_outline_rounded, 'Profile', 3),
                  ],
                ),
              ),
            ),
          ),
        ),

        // ── FAB ──
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF6366F1),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          onPressed: () async {
            final newTask = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddTaskScreen()),
            );
            if (newTask != null) {
              setState(() => _taskService.addTask(newTask));
            }
          },
          child:
          const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        ),
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected
                ? const Color(0xFF6366F1)
                : const Color(0xFF9CA3AF),
            size: 22,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight:
              isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected
                  ? const Color(0xFF6366F1)
                  : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFEDE9FE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.task_alt_rounded,
                size: 40,
                color: Color(0xFF6366F1),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'No tasks here!',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tap + to add a new task',
              style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 90),
      itemCount: tasks.length,
      itemBuilder: (_, i) {
        final task = tasks[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withOpacity(0.07),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Circle checkbox
                GestureDetector(
                  onTap: () => setState(() => _taskService.updateTask(
                    task.id,
                    isCompleted: !task.isCompleted,
                  )),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: task.isCompleted
                          ? const Color(0xFF6366F1)
                          : Colors.transparent,
                      border: Border.all(
                        color: task.isCompleted
                            ? const Color(0xFF6366F1)
                            : const Color(0xFFD1D5DB),
                        width: 2,
                      ),
                    ),
                    child: task.isCompleted
                        ? const Icon(Icons.check_rounded,
                        size: 13, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),

                // Task info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: task.isCompleted
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF1F1F3C),
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDE9FE),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              task.category,
                              style: const TextStyle(
                                color: Color(0xFF6366F1),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.calendar_today_rounded,
                              size: 10, color: Colors.grey[400]),
                          const SizedBox(width: 3),
                          Text(
                            '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                            style: TextStyle(
                                fontSize: 10, color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Delete button
                GestureDetector(
                  onTap: () =>
                      setState(() => _taskService.deleteTask(task.id)),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.delete_outline_rounded,
                        color: Color(0xFFEF4444), size: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}