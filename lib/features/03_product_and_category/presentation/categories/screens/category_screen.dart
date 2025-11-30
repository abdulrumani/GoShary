import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Core Imports
import 'package:goshary_app/core/config/app_colors.dart';
import 'package:goshary_app/core/config/app_typography.dart';
import 'package:goshary_app/core/services/di_container.dart';
import 'package:goshary_app/core/widgets/loading_indicator.dart';
import 'package:goshary_app/core/navigation/route_names.dart';

// Feature Imports
import '../cubit/category_cubit.dart';
import '../cubit/category_state.dart';
import '../../../domain/entities/category.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CategoryCubit>()..loadCategories(),
      child: const _CategoryView(),
    );
  }
}

class _CategoryView extends StatelessWidget {
  const _CategoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Categories"),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: LoadingIndicator());
          } else if (state is CategoryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: AppColors.error, size: 40),
                  const SizedBox(height: 10),
                  Text(state.message),
                  TextButton(
                    onPressed: () => context.read<CategoryCubit>().loadCategories(),
                    child: const Text("Retry"),
                  )
                ],
              ),
            );
          } else if (state is CategoryLoaded) {
            final categories = state.categories;

            if (categories.isEmpty) {
              return const Center(child: Text("No categories found."));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return _buildCategoryCard(context, categories[index]);
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Category category) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Selected: ${category.name}")),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Category Image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: category.imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                  imageUrl: category.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (c, u) => const Icon(Icons.category, color: Colors.grey),
                  errorWidget: (c, u, e) => const Icon(Icons.category, color: Colors.grey),
                )
                    : const Icon(Icons.category, color: AppColors.primary),
              ),
            ),
            const SizedBox(width: 16),

            // Name & Count
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: AppTypography.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${category.count} items",
                    style: AppTypography.textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            // Arrow Icon
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
