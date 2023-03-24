import 'package:flutter/material.dart';

class ConfigurableRangeSlider extends StatefulWidget {
  final double min;
  final double max;
  final Function(double, double)? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;

  ConfigurableRangeSlider({
    Key? key,
    required this.min,
    required this.max,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
  }) : super(key: key);

  @override
  _ConfigurableRangeSliderState createState() =>
      _ConfigurableRangeSliderState();
}

class _ConfigurableRangeSliderState extends State<ConfigurableRangeSlider> {
  double _startValue = 0.0;
  double _endValue = 0.0;

  @override
  void initState() {
    super.initState();
    _startValue = widget.min;
    _endValue = widget.max;
  }

  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      values: RangeValues(_startValue, _endValue),
      min: widget.min,
      max: widget.max,
      activeColor: widget.activeColor,
      inactiveColor: widget.inactiveColor,
      divisions: (widget.max.toInt() - widget.min.toInt()) ~/ 10,
      labels: RangeLabels(
        _startValue.round().toString(),
        _endValue.round().toString(),
      ),
      onChanged: (RangeValues values) {
        setState(() {
          _startValue = values.start;
          _endValue = values.end;
        });

        if (widget.onChanged != null) {
          widget.onChanged!(_startValue, _endValue);
        }
      },
    );
  }
}
