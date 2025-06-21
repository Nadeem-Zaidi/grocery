import 'package:flutter/material.dart';
import 'package:grocery_app/authentication/presentation/otp_screen.dart';
import 'package:grocery_app/forms/cosmetic.dart';
import 'package:grocery_app/pages/category_pages/create_category_page.dart';
import 'package:grocery_app/pages/product_pages/new_product.dart';
import 'package:grocery_app/pages/product_pages/product_list.dart';

import '../authentication/presentation/app.dart';
import '../pages/category_pages/categories.dart';
import '../pages/home.dart';
import '../authentication/presentation/landing_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case '/':
        // return MaterialPageRoute(builder: (_) => const NewProduct());
        return MaterialPageRoute(builder: (_) => const LandingPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => const Home());
      // return MaterialPageRoute(
      //     builder: (context) => MultiBlocProvider(
      //           providers: [
      //             BlocProvider(
      //               create: (context) => ProductBloc(
      //                   FirestoreProductService(
      //                       fireStore: FirebaseFirestore.instance,
      //                       collectionName: "products"),
      //                   FirestoreInventoryService(
      //                       fireStore: FirebaseFirestore.instance,
      //                       collectionName: "inventory")),
      //             ),
      //             BlocProvider(
      //               create: (context) => CategoryParentDialogCubit(
      //                 dbService: FirestoreCategoryService(
      //                     firestore: FirebaseFirestore.instance,
      //                     collectionName: "categories"),
      //               ),
      //             )
      //           ],
      //           child: CreateProduct(),
      //         ));
      // return MaterialPageRoute(builder: (_) => MultiImageUploadScreen());
      case '/signinsignup':
        return MaterialPageRoute(builder: (_) => const App());
      case '/otpscreen':
        return MaterialPageRoute(builder: (_) => const OTPScreen());
      case '/createcategory':
        return MaterialPageRoute(builder: (_) => const CreateCategorypage());
      case '/categories':
        return MaterialPageRoute(builder: (_) => const CategoriesPage());

      case '/productlist':
        return MaterialPageRoute(builder: (_) => const ProductList());

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
