/// Category domain entity on mobile.
class Category {
  final String id;
  final String name;
  final String slug;
  final String? description;

  const Category({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
  });
}
