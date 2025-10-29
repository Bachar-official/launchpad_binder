import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountSelector extends StatefulWidget {
  const CountSelector({
    super.key,
    this.value = 0,
    this.onChanged,
    this.displayFunction,
    this.min = 0,
    this.max = 999999,
    this.step = 1,
    this.width = 108,
  });

  final double value;
  final void Function(double value)? onChanged;
  final String Function(double value)? displayFunction;
  final double min;
  final double max;

  /// The step to increment or decrement by.
  final double step;
  final double width;
  @override
  State<CountSelector> createState() => _CountSelectorState();
}

class _CountSelectorState extends State<CountSelector> {
  late double value;
  late TextEditingController controller;
  late FocusNode focusNode;

  String displayFunction(double value) =>
      widget.displayFunction?.call(value) ?? '$value';

  @override
  void initState() {
    super.initState();
    value = widget.value;
    controller = TextEditingController(text: displayFunction(value));
    focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant CountSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value &&
        widget.value != double.tryParse(controller.text)) {
      setState(() {
        value = widget.value;
        controller.text = displayFunction(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final stepSize = widget.step;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              if (widget.value - stepSize >= widget.min) {
                widget.onChanged?.call(widget.value - stepSize);
              }
            },
            icon: const Icon(Icons.remove),
          ),
          const SizedBox(width: 8),
          Container(
            width: widget.width,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            child: TextField(
              key: Key('counter_$value'),
              focusNode: focusNode,
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) {
                widget.onChanged?.call(double.tryParse(value) ?? 0);
              },
              onSubmitted: (value) {
                widget.onChanged?.call(double.tryParse(value) ?? 0);
              },

              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.top,
              // displayFunction(widget.value),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              if (widget.value + stepSize <= widget.max) {
                widget.onChanged?.call(widget.value + stepSize);
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}