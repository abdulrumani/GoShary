import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../features/03_product_and_category/domain/entities/category.dart';

class HomeCategoryList extends StatelessWidget {
  final List<Category> categories;

  const HomeCategoryList({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100, // Height for Circle + Text
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.inputFill,
                  border: Border.all(color: AppColors.border),
                ),
                child: ClipOval(
                  child: cat.imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                    imageUrl: cat.imageUrl,
                    fit: BoxFit.cover,
                    errorWidget: (c, u, e) => const Icon(Icons.category, color: AppColors.textSecondary),
                  )
                      : const Icon(Icons.category, color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 60,
                child: Text(
                  cat.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}