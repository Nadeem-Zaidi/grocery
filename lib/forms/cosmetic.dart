import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/beauty_cosmetics/bloc/form_bloc.dart';
import 'package:grocery_app/widgets/multi_image_picker.dart';
import 'package:grocery_app/widgets/textfield.dart';
import 'package:grocery_app/blocs/beauty_cosmetics/bloc/form_bloc.dart'
    as formState;

import '../models/form_config/form_config.dart';

class CosmeticForm extends StatefulWidget {
  const CosmeticForm({super.key});

  @override
  State<CosmeticForm> createState() => _CosmeticFormState();
}

class _CosmeticFormState extends State<CosmeticForm> {
  final _scrollController = ScrollController();
  Map<String, TextEditingController> _textControllers = {};
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    final bloc = context.read<FormBloc>();
    bloc.add(FormInitialized());
    final fieldMap = context.read<FormBloc>().state.formConfigMap;

    // Wait for next microtask (after state updates)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = bloc.state;
      if (state.category != null &&
          state.formConfigMap.containsKey("category")) {
        final updatedConfig = state.formConfigMap["category"]!.copyWith(
          defaultValue: state.category?.path,
        );
        bloc.add(
          FieldChanged(
              fieldKey: 'category',
              value: state.category?.path,
              datatype: 'text'),
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
    return Scaffold(
      appBar: AppBar(title: BlocBuilder<FormBloc, formState.FormState>(
        builder: (context, state) {
          if (state.category != null) {
            return Text(state.category!.path!);
          }
          return Text("Product Creation");
        },
      )),
      body: Stack(
        children: [
          BlocSelector<FormBloc, formState.FormState, List<String>>(
            selector: (state) => state.formConfigMap.entries
                .where((entry) => entry.value.toString().isNotEmpty)
                .map((entry) => entry.key)
                .toList(),
            builder: (context, visibleFieldKeys) {
              if (visibleFieldKeys.isEmpty) {
                return Center(
                    child: Container(
                  child: Text("Form not configured for this category"),
                ));
              }
              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: visibleFieldKeys.length,
                itemBuilder: (context, index) {
                  final fieldKey = visibleFieldKeys[index];
                  TextEditingController controller =
                      _textControllers.putIfAbsent(fieldKey, () {
                    final config =
                        context.read<FormBloc>().state.formConfigMap[fieldKey];
                    return TextEditingController(
                        text: config?.defaultValue?.toString() ?? '');
                  });
                  return _FieldRenderer(
                    fieldKey: fieldKey,
                    controller: controller,
                  );
                },
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
                child: Text("Save"),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _FieldRenderer extends StatefulWidget {
  final String fieldKey;
  final TextEditingController controller;

  const _FieldRenderer({required this.fieldKey, required this.controller});

  @override
  State<_FieldRenderer> createState() => _FieldRendererState();
}

class _FieldRendererState extends State<_FieldRenderer> {
  bool toggleSwitch = true;
  @override
  Widget build(BuildContext context) {
    return BlocSelector<FormBloc, formState.FormState, FormConfig?>(
      selector: (state) => state.formConfigMap[widget.fieldKey],
      builder: (context, config) {
        if (config == null || config.hidden) return const SizedBox.shrink();

        final fieldName = config.fieldname;
        final label = config.label;
        if (fieldName == null || label == null) return const SizedBox.shrink();

        final errorText = context.select<FormBloc, String?>(
          (bloc) => bloc.state.errors[widget.fieldKey],
        );

        return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildFieldByType(
                widget.controller, context, config, errorText, (value) {
              context.read<FormBloc>().add(FieldChanged(
                  fieldKey: widget.fieldKey,
                  value: value,
                  datatype: config.datatype!));
            }));
      },
    );
  }

  Widget _buildFieldByType(TextEditingController controller,
      BuildContext context, FormConfig config, String? errorText,
      [void Function(String value)? onChange]) {
    switch (config.display) {
      case 'text':
        if (config.fieldname == "category") {
          return buildTextField(
            controller: controller,
            keyboardType: TextInputType.text,
            context,
            label: config.label ?? "Unbinded",
            hint: config.hint ?? "",
            maxLength: 250,
            errorText: errorText,
          );
        }
        return buildTextField(
          controller: controller,
          context,
          keyboardType: TextInputType.text,
          label: config.label ?? "Unbinded",
          hint: config.hint ?? "",
          maxLength: 250,
          onChanged: onChange,
          errorText: errorText,
        );
      case 'number_input':
        return buildTextField(
          controller: controller,
          context,
          label: config.label ?? "Unbinded",
          hint: config.hint ?? "",
          keyboardType: TextInputType.numberWithOptions(decimal: false),
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
              label: config.label ?? "Unbinded",
              hint: config.hint ?? "",
              maxLines: 3,
              errorText: errorText,
              onChanged: onChange,
            ),
          ],
        );

      case 'image_uploader':
        return Container(
          height: 300,
          child: MultiImageUploadScreen(),
        );
      // case 'text_readonly':
      //   return _buildReadOnlyField(context, config, errorText);

      case 'switch':
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              config.label ?? "",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Switch(
                // thumb color (round icon)
                activeColor: Colors.amber,
                activeTrackColor: Theme.of(context).primaryColor,
                inactiveThumbColor: Colors.blueGrey.shade600,
                inactiveTrackColor: Colors.grey.shade400,
                splashRadius: 50.0,
                // boolean variable value
                value: config.defaultValue.toString() == "true" ? true : false,
                // changes the state of the switch
                onChanged: (value) {
                  context.read<FormBloc>().add(
                        FieldChanged(
                          fieldKey: config.fieldname!,
                          value: value
                              .toString(), // Store as 'true'/'false' string
                          datatype: config.datatype ?? 'bool',
                        ),
                      );
                }),
          ],
        );
      default:
        return buildTextField(
          controller: controller,
          context,
          label: config.label ?? "Unbinded",
          hint: config.hint ?? "",
          keyboardType: TextInputType.number,
          maxLength: 10,
          errorText: errorText,
          onChanged: onChange,
        );
    }
  }
}
