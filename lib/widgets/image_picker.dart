import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/categories/create_category_bloc/category_create_bloc.dart'; // Import your cubit

class WImagePicker extends StatelessWidget {
  const WImagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    print("running ImagePicker");

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular Avatar with Image Preview
          BlocBuilder<CreateCategoryBloc, CreateCategoryState>(
            builder: (context, state) {
              return Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: state.imageFile != null
                      ? Image.file(
                          state.imageFile!,
                          fit: BoxFit.cover,
                        )
                      : state.uploadedUrl != null
                          ? Image.network(
                              state.uploadedUrl!,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.image_outlined,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                ),
              );
            },
          ),

          // Camera Icon Overlay
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                // Trigger image picker
                context.read<CreateCategoryBloc>().add(PickImage());
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
