import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/authentication/presentation/otp_screen.dart';
import 'package:grocery_app/blocs/categories/category_parent_dialog_bloc/cubit/category_parent_dialog_cubit.dart';
import 'package:grocery_app/blocs/products/product_bloc/product_bloc.dart';
import 'package:grocery_app/database_service.dart/product/firestore_product_service.dart';
import 'package:grocery_app/pages/category_pages/category_update_page.dart';
import 'package:grocery_app/pages/category_pages/create_category_page.dart';
import 'package:grocery_app/pages/product_pages/create_product.dart';
import 'package:grocery_app/pages/product_pages/multi_image_file_upload.dart';

import '../authentication/presentation/app.dart';
import '../database_service.dart/category/firestore_category_service.dart';
import '../pages/category_pages/categories.dart';
import '../pages/home.dart';
import '../authentication/presentation/landing_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LandingPage());
      case '/home':
        // return MaterialPageRoute(builder: (_) => const Home());
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => ProductBloc(
                        FirestoreProductService(
                            fireStore: FirebaseFirestore.instance,
                            collectionName: "products"),
                      ),
                    ),
                    BlocProvider(
                      create: (context) => CategoryParentDialogCubit(
                        dbService: FirestoreCategoryService(
                            firestore: FirebaseFirestore.instance,
                            collectionName: "categories"),
                      ),
                    )
                  ],
                  child: CreateProduct(),
                ));
      // return MaterialPageRoute(builder: (_) => MultiImageUploadScreen());
      case '/signinsignup':
        return MaterialPageRoute(builder: (_) => const App());
      case '/otpscreen':
        return MaterialPageRoute(builder: (_) => const OTPScreen());
      case '/createcategory':
        return MaterialPageRoute(builder: (_) => const CreateCategorypage());
      case '/categories':
        return MaterialPageRoute(builder: (_) => const CategoriesPage());

      // case '/category_update':
      //   return MaterialPageRoute(builder: (_) => const CategoryUpdatePage());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
