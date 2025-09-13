import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/beauty_cosmetics/bloc/form_bloc.dart';
import 'package:grocery_app/widgets/multi_image_picker.dart';
import 'package:grocery_app/widgets/overlay.dart';
import 'package:grocery_app/widgets/textfield.dart';
import 'package:grocery_app/blocs/beauty_cosmetics/bloc/form_bloc.dart'
    as formState;

import '../models/form_config/form_config.dart';
import '../pages/product_pages/product_detail.dart';

class CosmeticForm extends StatefulWidget {
  const CosmeticForm({super.key});

  @override
  State<CosmeticForm> createState() => _CosmeticFormState();
}

class _CosmeticFormState extends State<CosmeticForm> {
  final _scrollController = ScrollController();
  final Map<String, TextEditingController> _textControllers = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    final bloc = context.read<FormBloc>();
    bloc.add(FormInitialized());

    final fieldMap = bloc.state.formConfigMap;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = bloc.state;
      if (state.category != null &&
          state.formConfigMap.containsKey("category")) {
        bloc.add(
          FieldChanged(
            fieldKey: 'category',
            value: state.category?.path,
            datatype: 'text',
          ),
        );
      }
    });

    fieldMap.forEach((key, config) {
      _textControllers[key] =
          TextEditingController(text: config.defaultValue?.toString() ?? '');
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !context.read<FormBloc>().state.hasReachedMax) {
      context.read<FormBloc>().add(FormInitialized());
    }
  }

  @override
  void dispose() {
    _textControllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FormBloc, formState.FormState>(
      listener: (context, state) {
        if (state.error != null) {}
        if (state.creatingProduct) {
          OverlayHelper.showOverlay(context, "Creating Product");
        } else {
          OverlayHelper.removeOverlay();
        }

        if (state.creatingVariation) {
          OverlayHelper.showOverlay(context, "Creating Variation");
        } else {
          OverlayHelper.removeOverlay();
        }
        if (state.createdProduct != null) {
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => ProductDetailPage(
          //       product: state.createdProduct!,
          //     ),
          //   ),
          // );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<FormBloc, formState.FormState>(
            builder: (context, state) {
              if (state.category != null) {
                return Text(state.category!.path!);
              }
              return const Text("Product Creation");
            },
          ),
        ),
        body: Stack(
          children: [
            BlocBuilder<FormBloc, formState.FormState>(
              buildWhen: (previous, current) =>
                  previous.formConfigMap.length != current.formConfigMap.length,
              builder: (context, state) {
                print("hurray this is product");
                print(state.formConfigMap);
                print("hurray this is product");
                return _RebuildAware(
                  state: state,
                  scrollController: _scrollController,
                  textControllers: _textControllers,
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<FormBloc>().add(FormSave());
                  },
                  child: const Text("Save"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// ✅ This widget detects when the parent BlocBuilder triggers a rebuild:
class _RebuildAware extends StatefulWidget {
  final formState.FormState state;
  final ScrollController scrollController;
  final Map<String, TextEditingController> textControllers;

  const _RebuildAware({
    required this.state,
    required this.scrollController,
    required this.textControllers,
  });

  @override
  State<_RebuildAware> createState() => _RebuildAwareState();
}

class _RebuildAwareState extends State<_RebuildAware> {
  @override
  void didUpdateWidget(covariant _RebuildAware oldWidget) {
    super.didUpdateWidget(oldWidget);

    debugPrint("✅ _RebuildAware detected: BlocBuilder rebuilt!");

    // 👉 Example: side effect after rebuild
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint("✅ Post-frame callback: you can do side effects here.");
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuilding whole form");
    final formKeys =
        widget.state.formConfigMap.entries.map((entry) => entry.key).toList();

    if (formKeys.isEmpty) {
      return const Center(
        child: Text("Form not configured for this category"),
      );
    }

    return ListView.builder(
      controller: widget.scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: formKeys.length,
      itemBuilder: (context, index) {
        final fieldKey = formKeys[index];
        final controller = widget.textControllers.putIfAbsent(fieldKey, () {
          final config = widget.state.formConfigMap[fieldKey];
          return TextEditingController(
              text: config?.defaultValue?.toString() ?? '');
        });
        return _FieldRenderer(
          fieldKey: fieldKey,
          controller: controller,
        );
      },
    );
  }
}

class _FieldRenderer extends StatefulWidget {
  final String fieldKey;
  final TextEditingController controller;

  const _FieldRenderer({
    required this.fieldKey,
    required this.controller,
  });

  @override
  State<_FieldRenderer> createState() => _FieldRendererState();
}

class _FieldRendererState extends State<_FieldRenderer> {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<FormBloc, formState.FormState, FormConfig?>(
      selector: (state) => state.formConfigMap[widget.fieldKey],
      builder: (context, config) {
        if (config == null || config.hidden) return const SizedBox.shrink();

        final fieldName = config.fieldname;
        final label = config.label;
        if (fieldName == null || label == null) return const SizedBox.shrink();

        if (config.defaultValue != null &&
            config.fieldname == widget.fieldKey) {
          widget.controller.text = config.defaultValue.toString();
        }

        final errorText = context.select<FormBloc, String?>(
          (bloc) => bloc.state.errors[widget.fieldKey],
        );

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildFieldByType(
            widget.controller,
            context,
            config,
            errorText,
            (value) {
              context.read<FormBloc>().add(
                    FieldChanged(
                      fieldKey: widget.fieldKey,
                      value: value,
                      datatype: config.datatype!,
                    ),
                  );
            },
          ),
        );
      },
    );
  }

  Widget _buildFieldByType(
    TextEditingController controller,
    BuildContext context,
    FormConfig config,
    String? errorText, [
    void Function(String value)? onChange,
  ]) {
    switch (config.display) {
      case 'text':
        if (config.fieldname == "category") {
          return buildTextField(
            controller: controller,
            keyboardType: TextInputType.text,
            context,
            label: config.label ?? "Unbound",
            hint: config.hint ?? "",
            maxLength: 250,
            errorText: errorText,
          );
        }
        return buildTextField(
          controller: controller,
          context,
          keyboardType: TextInputType.text,
          label: config.label ?? "Unbound",
          hint: config.hint ?? "",
          maxLength: 250,
          onChanged: onChange,
          errorText: errorText,
        );
      case 'number_input':
        return buildTextField(
          controller: controller,
          context,
          label: config.label ?? "Unbound",
          hint: config.hint ?? "",
          keyboardType: TextInputType.numberWithOptions(decimal: false),
          inputFormatter: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
          ],
          maxLength: 10,
          errorText: errorText,
          onChanged: onChange,
        );
      case 'double_input':
        return buildTextField(
          controller: controller,
          context,
          label: config.label ?? "Unbound",
          hint: config.hint ?? "",
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatter: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
          ],
          maxLength: 10,
          errorText: errorText,
          onChanged: onChange,
        );
      case 'textarea':
        return Column(
          children: [
            buildTextField(
              controller: controller,
              context,
              keyboardType: TextInputType.text,
              label: config.label ?? "Unbound",
              hint: config.hint ?? "",
              maxLines: 3,
              errorText: errorText,
              onChanged: onChange,
            ),
          ],
        );
      case 'image_uploader':
        return SizedBox(
          height: 300,
          child: MultiImageUploadScreen(),
        );
      case 'switch':
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              config.label ?? "",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Switch(
              activeColor: Colors.amber,
              activeTrackColor: Theme.of(context).primaryColor,
              inactiveThumbColor: Colors.blueGrey.shade600,
              inactiveTrackColor: Colors.grey.shade400,
              splashRadius: 50.0,
              value: config.defaultValue.toString() == "true",
              onChanged: (value) {
                context.read<FormBloc>().add(
                      FieldChanged(
                        fieldKey: config.fieldname!,
                        value: value.toString(),
                        datatype: config.datatype ?? 'bool',
                      ),
                    );
              },
            ),
          ],
        );
      default:
        return buildTextField(
          controller: controller,
          context,
          label: config.label ?? "Unbound",
          hint: config.hint ?? "",
          keyboardType: TextInputType.number,
          maxLength: 10,
          errorText: errorText,
          onChanged: onChange,
        );
    }
  }
}
