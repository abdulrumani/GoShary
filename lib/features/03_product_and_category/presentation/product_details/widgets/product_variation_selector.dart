import 'package:flutter/material.dart';
import 'package:goshary_app/core/config/app_colors.dart';
import '../../../domain/entities/product.dart';

class ProductVariationSelector extends StatefulWidget {
  final List<ProductAttribute> attributes;
  final Function(Map<String, String>) onSelectionChanged;

  const ProductVariationSelector({
    super.key,
    required this.attributes,
    required this.onSelectionChanged,
  });

  @override
  State<ProductVariationSelector> createState() => _ProductVariationSelectorState();
}

class _ProductVariationSelectorState extends State<ProductVariationSelector> {
  // کونسے ایٹریبیوٹ کی کونسی ویلیو سلیکٹ ہے
  final Map<String, String> _selections = {};

  @override
  void initState() {
    super.initState();
    // ڈیفالٹ میں پہلا آپشن منتخب کر لیں
    for (var attr in widget.attributes) {
      if (attr.options.isNotEmpty) {
        _selections[attr.name] = attr.options.first;
      }
    }
  }

  void _selectOption(String attributeName, String option) {
    setState(() {
      _selections[attributeName] = option;
    });
    widget.onSelectionChanged(_selections);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.attributes.map((attr) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Attribute Name (e.g. Size)
              Text(attr.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 8),

              // Options (S, M, L)
              Wrap(
                spacing: 10,
                children: attr.options.map((option) {
                  final isSelected = _selections[attr.name] == option;
                  final isColor = attr.name.toLowerCase() == 'color';

                  return GestureDetector(
                    onTap: () => _selectOption(attr.name, option),
                    child: isColor
                        ? _buildColorOption(option, isSelected)
                        : _buildTextOption(option, isSelected),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Text Option (Size, Weight)
  Widget _buildTextOption(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  // Color Option
  Widget _buildColorOption(String colorName, bool isSelected) {
    // نوٹ: اصلی ایپ میں آپ کو کلر کوڈ میپ کرنا ہوگا (e.g., "Red" -> Color(0xFFFF0000))
    // فی الحال ہم صرف نام دکھا رہے ہیں، لیکن سرکلر شیپ میں
    return Container(
      padding: const EdgeInsets.all(2), // Border space
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.grey[300], // Placeholder color
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          colorName[0], // First letter of color
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}