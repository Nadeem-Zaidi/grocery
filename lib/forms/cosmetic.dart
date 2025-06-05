import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/beauty_cosmetics/bloc/cosmetic_bloc.dart';
import 'package:grocery_app/extensions/capitalize_first.dart';
import 'package:grocery_app/widgets/multi_image_picker.dart';
import 'package:grocery_app/widgets/textfield.dart';

import '../models/form_config/form_config.dart';

class CosmeticForm extends StatelessWidget {
  const CosmeticForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cosmetic Form")),
      body: BlocSelector<CosmeticBloc, CosmeticState, List<String>>(
        selector: (state) => state.formConfigMap.entries
            .where((entry) => !entry.value.hidden)
            .map((entry) => entry.key)
            .toList(),
        builder: (context, visibleFieldKeys) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: visibleFieldKeys.length,
            itemBuilder: (context, index) {
              final fieldKey = visibleFieldKeys[index];
              return _FieldRenderer(fieldKey: fieldKey);
            },
          );
        },
      ),
    );
  }
}

class _FieldRenderer extends StatefulWidget {
  final String fieldKey;

  const _FieldRenderer({required this.fieldKey});

  @override
  State<_FieldRenderer> createState() => _FieldRendererState();
}

class _FieldRendererState extends State<_FieldRenderer> {
  bool toggleSwitch = true;
  @override
  Widget build(BuildContext context) {
    return BlocSelector<CosmeticBloc, CosmeticState, FormConfig?>(
      selector: (state) => state.formConfigMap[widget.fieldKey],
      builder: (context, config) {
        if (config == null || config.hidden) return const SizedBox.shrink();

        final fieldName = config.fieldname;
        final label = config.label;
        if (fieldName == null || label == null) return const SizedBox.shrink();

        final errorText = context.select<CosmeticBloc, String?>(
          (bloc) => bloc.state.errors[widget.fieldKey],
        );

        return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildFieldByType(
              context,
              config,
              errorText,
            ));
      },
    );
  }

  Widget _buildFieldByType(
      BuildContext context, FormConfig config, String? errorText,
      [void Function(String value)? onChange, List<String> test = const []]) {
    switch (config.display) {
      case 'text':
        return buildTextField(
          context,
          label: config.label ?? "Unbinded",
          hint: config.label ?? "",
          maxLength: 20,
          onChanged: onChange,
        );
      case 'number_input':
        return buildTextField(
          context,
          label: config.label ?? "Unbinded",
          hint: config.label ?? "",
          keyboardType: TextInputType.number,
          maxLength: 10,
          onChanged: onChange,
        );
      case 'textarea':
        return Column(
          children: [
            buildTextField(
              context,
              label: config.label ?? "Unbinded",
              hint: config.label ?? "",
              maxLines: 3,
              onChanged: onChange,
            ),
          ],
        );

      case 'image_uploader':
        return Container(height: 300, child: MultiImageUploadScreen());
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
              value: toggleSwitch,
              // changes the state of the switch
              onChanged: (value) => setState(() {
                toggleSwitch = value;
              }),
            ),
          ],
        );
      default:
        return _buildTextField(
          context,
          config: config,
          errorText: errorText,
          keyboardType: TextInputType.text,
        );
    }
  }

  Widget _buildTextField(
    BuildContext context, {
    required FormConfig config,
    required String? errorText,
    required TextInputType keyboardType,
  }) {
    return buildTextField(context,
        label: config.label ?? "Unbinded", hint: config.label ?? "");
  }

  Widget _buildCurrencyField(
      BuildContext context, FormConfig config, String? errorText) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: config.label?.capitalizeFirst(),
        errorText: errorText,
        prefixText: '₹ ',
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onChanged: (value) {
        context.read<CosmeticBloc>().add(
              FieldChanged(fieldKey: config.fieldname!, value: value),
            );
      },
    );
  }

  Widget _buildTextArea(
      BuildContext context, FormConfig config, String? errorText) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: config.label?.capitalizeFirst(),
        errorText: errorText,
        border: const OutlineInputBorder(),
      ),
      maxLines: 2,
      keyboardType: TextInputType.multiline,
      onChanged: (value) {
        context.read<CosmeticBloc>().add(
              FieldChanged(fieldKey: config.fieldname!, value: value),
            );
      },
    );
  }

  Widget _buildTextAreaArray(
      BuildContext context, FormConfig config, String? errorText) {
    // Implement your textarea array widget
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(config.label?.capitalizeFirst() ?? '',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        // Add your array input implementation here
        Text('Textarea array input for ${config.fieldname}',
            style: TextStyle(color: Colors.grey)),
        if (errorText != null)
          Text(errorText,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.error)),
      ],
    );
  }

  // Widget _buildSwitchField(
  Widget _buildChipInput(
      BuildContext context, FormConfig config, String? errorText) {
    // Implement your chip input widget
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(config.label?.capitalizeFirst() ?? '',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        // Add your chip input implementation here
        Wrap(
          spacing: 8,
          children: [
            ActionChip(label: Text('Chip 1'), onPressed: () {}),
            ActionChip(label: Text('Chip 2'), onPressed: () {}),
          ],
        ),
        if (errorText != null)
          Text(errorText,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.error)),
      ],
    );
  }

  Widget _buildImageUploader(
      BuildContext context, FormConfig config, String? errorText) {
    // Implement your image uploader widget
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(config.label?.capitalizeFirst() ?? '',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        // Add your image uploader implementation here
        ElevatedButton(
          onPressed: () {},
          child: const Text('Upload Images'),
        ),
        if (errorText != null)
          Text(errorText,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.error)),
      ],
    );
  }
}
