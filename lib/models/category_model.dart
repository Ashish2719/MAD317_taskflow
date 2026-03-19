class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});
}

final List<Category> defaultCategories = [
  Category(id: '1', name: 'Work'),
  Category(id: '2', name: 'Personal'),
  Category(id: '3', name: 'Shopping'),
  Category(id: '4', name: 'Health'),
  Category(id: '5', name: 'Study'),
];