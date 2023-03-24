import 'package:flutter/material.dart';

class ConfigurableSlider extends StatefulWidget {
  final String name;
  final String parameter;
  final double initialValue;
  final double minValue;
  final double maxValue;
  final int divisions;
  final Color color;
  final Function(double) onChanged;

  ConfigurableSlider({
    required this.name,
    required this.parameter,
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
    required this.divisions,
    required this.color,
    required this.onChanged,
  });

  @override
  _ConfigurableSliderState createState() => _ConfigurableSliderState();
}

class _ConfigurableSliderState extends State<ConfigurableSlider> {
  dynamic _value = 0;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.name}: $_value',
          // style: TextStyle(color: _statusColor),
          textAlign: TextAlign.left,
        ),
        Slider(
          min: widget.minValue,
          max: widget.maxValue,
          activeColor: Colors.purple,
          inactiveColor: Colors.purple.shade100,
          thumbColor: Colors.deepOrange,
          value: _value,
          divisions: 20,
          label: '${_value.round()}',
          onChanged: (value) {
            setState(() {
              if (widget.parameter == "time")
                _value = value;
              else
                _value = value.toInt();
              widget.onChanged;
            });
          },
        ),
      ],
    );
  }
}
