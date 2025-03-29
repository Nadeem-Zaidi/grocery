import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/categories/category_parent_dialog_bloc/cubit/category_parent_dialog_cubit.dart';
import 'package:grocery_app/blocs/products/product_bloc/product_bloc.dart';
import 'package:grocery_app/widgets/checkbox.dart';
import '../../utils/screen_utils.dart';
import '../../widgets/category_parent_selection_dialog.dart';
import '../../widgets/category_selection_for_product.dart';
import 'multi_image_file_upload.dart';

class CreateProduct extends StatefulWidget {
  const CreateProduct({super.key});

  @override
  State<CreateProduct> createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  final TextEditingController _categoryNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _sellingUnit = TextEditingController();
  final TextEditingController _quantityInUnit = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  final TextEditingController _sellingPrice = TextEditingController();
  final TextEditingController _mrp = TextEditingController();
  final TextEditingController _discount = TextEditingController();
  bool isChecked = false;

  @override
  void dispose() {
    _categoryNameController.dispose();
    _descriptionController.dispose();
    _productNameController.dispose();
    _brandController.dispose();
    _sellingPrice.dispose();
    _sellingUnit.dispose();
    _mrp.dispose();
    _discount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = ScreenUtils.getScreenWidth(context);
    final screenHeight = ScreenUtils.getScreenHeight(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Product"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Product Details',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),

            // Product Name Field
            _buildModernTextField(context,
                controller: _productNameController,
                label: "Product Name",
                hint: "Enter product name",
                icon: Icons.shopping_bag_outlined, onChanged: (value) {
              context.read<ProductBloc>().add(ProductName(value));
            }),
            const SizedBox(height: 16),

            // Brand Field
            _buildModernTextField(context,
                controller: _brandController,
                label: "Brand",
                hint: "Enter brand name",
                icon: Icons.branding_watermark_outlined, onChanged: (value) {
              context.read<ProductBloc>().add(ProductBrand(value));
            }),
            const SizedBox(height: 16),

            // Category Selection
            BlocBuilder<CategoryParentDialogCubit, CategoryParentDialogState>(
              builder: (context, state) {
                _categoryNameController.text = state.selectedCategory ?? "";
                return _buildModernTextField(context,
                    controller: _categoryNameController,
                    label: "Category",
                    hint: "Select category",
                    isSelectable: true,
                    suffixIcon: IconButton(
                        onPressed: () {
                          context
                              .read<CategoryParentDialogCubit>()
                              .fetchCategories();
                          categorySelectionForProduct(
                              context, screenWidth, screenHeight);
                        },
                        icon: Icon(Icons.arrow_drop_down)), onTap: () {
                  context.read<CategoryParentDialogCubit>().fetchCategories();
                  categorySelectionForProduct(
                      context, screenWidth, screenHeight);
                }, onChanged: (value) {
                  context.read<ProductBloc>().add(ProductCategory(value));
                });
              },
            ),
            const SizedBox(height: 24),
            _buildModernTextField(
              context,
              controller: _sellingUnit,
              label: "Selling Unit",
              hint: "Add Selling Unit",
              onTap: () {},
              onChanged: (value) {
                context.read<ProductBloc>().add(SellingUnit(value));
              },
            ),
            SizedBox(
              height: 30,
            ),
            BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
              if (state.showQuantityInBox == true) {
                return _buildModernTextField(context,
                    controller: _quantityInUnit,
                    label: "Quantity In Box",
                    hint: "Enter Quantity In Box",
                    icon: Icons.branding_watermark_outlined,
                    onChanged: (value) {
                  context.read<ProductBloc>().add(QuantityInBox(value));
                });
              }
              return Container();
            }),
            SizedBox(height: 30),
            // _buildModernTextField(
            //   context,
            //   controller: _brandController,
            //   label: "",
            //   hint: "Enter Quantity In Box",
            //   icon: Icons.branding_watermark_outlined,
            // ),

            _buildModernTextField(context,
                controller: _mrp,
                label: "MRP",
                hint: "Enter the MRP",
                icon: Icons.currency_rupee, onChanged: (value) {
              context.read<ProductBloc>().add(Mrp(value));
            }),
            const SizedBox(height: 24),
            _buildModernTextField(context,
                controller: _sellingPrice,
                label: "Selling Price",
                hint: "Enter the Selling Price",
                icon: Icons.currency_rupee, onChanged: (value) {
              context.read<ProductBloc>().add(SellingPrice(value));
            }),

            _buildModernTextField(context,
                controller: _discount,
                label: "Discount",
                hint: "0.00",
                icon: Icons.currency_rupee, onChanged: (value) {
              context.read<ProductBloc>().add(SetDiscount(value));
            }),
            const SizedBox(height: 24),
            _buildModernTextField(context,
                controller: _quantity,
                label: "Quantity Available",
                hint: "1",
                icon: Icons.currency_rupee, onChanged: (value) {
              context.read<ProductBloc>().add(SetQuantity(value));
            }),

            // Image Upload Section
            Text(
              'Product Images',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.3),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: const MultiImageUploadScreen(),
              ),
            ),
            const SizedBox(height: 24),

            // Description Section
            Text(
              'Description',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            _buildModernTextField(
              context,
              controller: _descriptionController,
              label: "Add description",
              hint: "Enter product details",
              maxLines: 3,
              suffixIcon: IconButton(
                icon:
                    Icon(Icons.check_circle, color: theme.colorScheme.primary),
                onPressed: () {
                  context
                      .read<ProductBloc>()
                      .add(AddDescription(_descriptionController.text));
                  _descriptionController.clear();
                },
              ),
            ),
            const SizedBox(height: 16),

            // Description List
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state.description.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Added Descriptions:',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: List.generate(
                            state.description.length,
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Icon(Icons.circle,
                                      size: 8,
                                      color: theme.colorScheme.primary),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(state.description[index])),
                                  IconButton(
                                    onPressed: () {
                                      context
                                          .read<ProductBloc>()
                                          .add(RemoveDescription(index));
                                    },
                                    icon: Icon(Icons.delete,
                                        color: theme.colorScheme.error),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
            const SizedBox(height: 32),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                context.read<ProductBloc>().add(ProductCreate());
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Create Product',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? icon,
    bool isSelectable = false,
    int maxLines = 1,
    int? maxLength,
    VoidCallback? onTap,
    ValueChanged<String>? onChanged, // Added onChanged callback
    Widget? suffixIcon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator, // Added validation support
    FocusNode? focusNode,
    EdgeInsetsGeometry? contentPadding,
    InputBorder? focusedBorder,
    InputBorder? errorBorder,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: isSelectable ? onTap : null,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.3),
              ),
            ),
            child: TextFormField(
              controller: controller,
              maxLines: maxLines,
              maxLength: maxLength,
              readOnly: isSelectable,
              obscureText: obscureText,
              keyboardType: keyboardType,
              focusNode: focusNode,
              validator: validator,
              onChanged: onChanged, // Added onChanged parameter
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                contentPadding: contentPadding ??
                    const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                prefixIcon: icon != null
                    ? Icon(icon, color: theme.colorScheme.primary)
                    : null,
                suffixIcon: suffixIcon,
                counterText: '', // Remove default counter text
                focusedBorder: focusedBorder,
                errorBorder: errorBorder,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
