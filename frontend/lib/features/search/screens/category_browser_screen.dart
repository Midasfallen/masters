import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/mock/mock_categories.dart';

class CategoryBrowserScreen extends StatefulWidget {
  const CategoryBrowserScreen({super.key});

  @override
  State<CategoryBrowserScreen> createState() => _CategoryBrowserScreenState();
}

class _CategoryBrowserScreenState extends State<CategoryBrowserScreen> {
  ServiceCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedCategory == null ? 'Каталог услуг' : _selectedCategory!.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: _selectedCategory != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _selectedCategory = null;
                  });
                },
              )
            : IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              ),
      ),
      body: _selectedCategory == null
          ? _buildMainCategories()
          : _buildSubcategories(_selectedCategory!),
    );
  }

  Widget _buildMainCategories() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: mockCategories.length,
      itemBuilder: (context, index) {
        final category = mockCategories[index];
        return _CategoryCard(
          category: category,
          onTap: () {
            if (category.subcategories != null &&
                category.subcategories!.isNotEmpty) {
              setState(() {
                _selectedCategory = category;
              });
            } else {
              // Navigate to search with this category filter
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Фильтр: ${category.name}')),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildSubcategories(ServiceCategory parentCategory) {
    if (parentCategory.subcategories == null ||
        parentCategory.subcategories!.isEmpty) {
      return const Center(
        child: Text('Нет подкатегорий'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: parentCategory.subcategories!.length,
      itemBuilder: (context, index) {
        final subcategory = parentCategory.subcategories![index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  subcategory.icon,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            title: Text(
              subcategory.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to search with this category filter
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Фильтр: ${subcategory.name}'),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final ServiceCategory category;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasSubcategories =
        category.subcategories != null && category.subcategories!.isNotEmpty;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    category.icon,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Name
              Text(
                category.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Subcategory count badge
              if (hasSubcategories) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${category.subcategories!.length}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
