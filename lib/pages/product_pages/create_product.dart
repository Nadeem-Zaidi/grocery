import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/categories/fetch_category_bloc/fetch_category_bloc.dart';
import 'package:grocery_app/blocs/products/product_bloc/product_bloc.dart';
import 'package:grocery_app/database_service.dart/category/firestore_category_service.dart';
import 'package:grocery_app/database_service.dart/product/firestore_product_service.dart';
import 'package:grocery_app/pages/select_category/select_category.dart';
import 'package:grocery_app/widgets/overlay.dart';
import '../../models/category.dart';
import '../../utils/screen_utils.dart';
import '../../widgets/textfield.dart';
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
  final TextEditingController _summary = TextEditingController();
  final TextEditingController _keyFeatures = TextEditingController();
  bool isChecked = false;
  FirestoreCategoryService categoryService = FirestoreCategoryService(
      firestore: FirebaseFirestore.instance, collectionName: "categories");
  FirestoreProductService productService = FirestoreProductService(
      fireStore: FirebaseFirestore.instance, collectionName: "products");

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
    _summary.dispose();
    _keyFeatures.dispose();
    super.dispose();
  }

  void setCategory(Category category) {
    context.read<ProductBloc>().add(SetCategory(category.path!));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = ScreenUtils.getScreenWidth(context);
    final screenHeight = ScreenUtils.getScreenHeight(context);

    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state.isLoading) {
          OverlayHelper.showOverlay(context, "Creating Product");
        } else {
          OverlayHelper.removeOverlay();
        }
      },
      child: Scaffold(
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
              buildTextField(context,
                  controller: _productNameController,
                  label: "Product Name",
                  hint: "Enter product name",
                  icon: Icons.shopping_bag_outlined, onChanged: (value) {
                context.read<ProductBloc>().add(ProductName(value));
              }),
              const SizedBox(height: 16),

              // Brand Field
              buildTextField(context,
                  controller: _brandController,
                  label: "Brand",
                  hint: "Enter brand name",
                  icon: Icons.branding_watermark_outlined, onChanged: (value) {
                context.read<ProductBloc>().add(ProductBrand(value));
              }),
              const SizedBox(height: 16),

              Row(
                children: [
                  BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      return Text(
                        overflow: TextOverflow.clip,
                        state.productCategory ?? "No Category Selected",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      );
                    },
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (context) => FetchCategoryBloc(
                                      categoryService, productService)
                                    ..add(FetchCategories()),
                                )
                              ],
                              child: SelectCategory(
                                onCategorySelect: (category) {
                                  setCategory(category);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.search))
                ],
              ),
              const SizedBox(height: 24),
              buildTextField(
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
                return buildTextField(context,
                    keyboardType: TextInputType.numberWithOptions(),
                    controller: _quantityInUnit,
                    label: "Quantity In Box",
                    hint: "Enter Quantity In Box",
                    icon: Icons.branding_watermark_outlined,
                    onChanged: (value) {
                  context.read<ProductBloc>().add(QuantityInBox(value));
                });
              }),
              SizedBox(height: 30),

              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  return buildTextField(context,
                      keyboardType: TextInputType.numberWithOptions(),
                      errorText: state.mrpInputError,
                      controller: _mrp,
                      label: "MRP",
                      hint: "Enter the MRP",
                      icon: Icons.currency_rupee, onChanged: (value) {
                    context.read<ProductBloc>().add(Mrp(value));
                  });
                },
              ),
              const SizedBox(height: 24),
              buildTextField(context,
                  keyboardType: TextInputType.numberWithOptions(),
                  controller: _discount,
                  label: "Discount",
                  hint: "0.00",
                  icon: Icons.percent_rounded, onChanged: (value) {
                context.read<ProductBloc>().add(SetDiscount(value));
              }),
              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  _sellingPrice.text = state.sellingPrice.toString();
                  return buildTextField(context,
                      keyboardType: TextInputType.numberWithOptions(),
                      controller: _sellingPrice,
                      isSelectable: true,
                      label: "Selling Price",
                      hint: "Enter the Selling Price",
                      icon: Icons.currency_rupee, onChanged: (value) {
                    context.read<ProductBloc>().add(SellingPrice(value));
                  });
                },
              ),
              const SizedBox(height: 24),
              buildTextField(context,
                  keyboardType: TextInputType.numberWithOptions(),
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
              buildTextField(
                context,
                controller: _descriptionController,
                label: "Add description",
                hint: "Enter product details",
                maxLines: 3,
                suffixIcon: IconButton(
                  icon: Icon(Icons.check_circle,
                      color: theme.colorScheme.primary),
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
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: List.generate(
                              state.description.length,
                              (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
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
              SizedBox(
                height: 5,
              ),
              BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
                return buildTextField(
                  context,
                  controller: _summary,
                  label: "Product Summary",
                  hint: "Add Product Summary",
                  maxLines: 3,
                  onTap: () {},
                  onChanged: (value) {
                    context.read<ProductBloc>().add(SetSummary(value));
                  },
                );
              }),
              SizedBox(
                height: 5,
              ),
              BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
                return buildTextField(
                  context,
                  controller: _keyFeatures,
                  label: "Key Features",
                  hint: "Add Product key Feature",
                  maxLines: 3,
                  onTap: () {},
                  onChanged: (value) {
                    context.read<ProductBloc>().add(SetKeyFeatures(value));
                  },
                );
              }),

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
      ),
    );
  }
}
