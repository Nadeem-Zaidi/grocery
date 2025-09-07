import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/change_variation/bloc/change_variation_bloc.dart';
import '../../models/product/productt.dart';

Future showModalBottom(
    BuildContext context,
    Productt product,
    Widget Function(BuildContext context, Variation variation)? buildCarAction,
    Function addEvent) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true, // allow full height if needed
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white, // background color
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, -3), // shadow towards top
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${product.name}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                SizedBox(height: 10),
                ...List.generate(
                  product.variations.length,
                  (index) {
                    return InkWell(
                      onTap: () {
                        context.read<ChangeVariationBloc>().add(ChangeVariation(
                            variationId: product.variations[index].id!));
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.grey.withOpacity(0.1), // soft shadow
                              blurRadius: 6,
                              spreadRadius: 2,
                              offset: Offset(
                                  0, 3), // shadow direction: bottom right
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.network(
                              product.variations[index].images[0],
                              height: 50,
                              width: 50,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "${product.variations[index].unitSize} ${product.variations[index].unitOfMeasure}",
                            ),
                            SizedBox(width: 20),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "${product.variations[index].sellingPrice}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "${product.variations[index].mrp}",
                                      style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    SizedBox(
                                      width: 75,
                                      height: 40,
                                      child: buildCarAction!(
                                        context,
                                        product.getVariation(
                                            product.variations[index].id!),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
