import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WeTextField extends StatefulWidget {
  const WeTextField({
    Key? key,
    required this.controller,
    this.style,
    this.readOnly = false,
    this.labelText,
    this.labelStyle,
    this.hintText,
    this.hintStyle,
    this.suffixIcon,
    this.border,
    this.inputFormatters,
    this.autocorrect = true,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.autofocus = false,
    this.onSubmitted,
    this.onSubRegExp,
    this.isDark = false,
    this.visibilitySemantics,
    this.clearSemantics,
    required this.id,
    required this.value,
    required this.onChanged,
  }) : super(key: key);
  final TextEditingController controller;
  final TextStyle? style;
  final bool readOnly;
  final String? labelText;
  final TextStyle? labelStyle;
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget? suffixIcon;
  final InputBorder? border;
  final List<TextInputFormatter>? inputFormatters;
  final bool autocorrect;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final bool autofocus;
  final ValueChanged<String>? onSubmitted;
  final RegExp? onSubRegExp;
  final bool isDark;
  final String? visibilitySemantics;
  final String? clearSemantics;
  final String id;
  final String value;
  final Function(String key, dynamic value, bool isTip) onChanged;

  @override
  State<WeTextField> createState() => _WeTextFieldState();
}

class _WeTextFieldState extends State<WeTextField> {
  String oldStr = "";
  bool _obscureText = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _obscureText = widget.obscureText;
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        checkRegExp();
      }
    });
    oldStr = widget.controller.text;
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void checkRegExp({String? val}) {
    bool isRegExp = true;
    String v = widget.controller.text;
    if (val != null) {
      v = val;
    }
    if (widget.onSubRegExp != null) {
      isRegExp = widget.onSubRegExp!.hasMatch(v);
    }
    if (!isRegExp) {
      v = oldStr;
    } else {
      oldStr = v;
    }
    widget.controller.text = v;
    widget.onChanged(widget.id, v, true);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      style: widget.style,
      readOnly: widget.readOnly,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: widget.labelStyle,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.suffixIcon != null) widget.suffixIcon!,
            if (widget.obscureText)
              Semantics(
                label: widget.visibilitySemantics,
                button: true,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: widget.isDark ? Colors.white70 : null,
                  ),
                ),
              ),
            if (!widget.readOnly)
              Semantics(
                label: widget.clearSemantics,
                button: true,
                child: GestureDetector(
                  onTap: widget.controller.text.isEmpty
                      ? null
                      : () {
                          widget.controller.text = "";
                          oldStr = "";
                          widget.onChanged(widget.id, "", false);
                        },
                  child: Container(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.cancel,
                      color: widget.value == "" ? Colors.grey : Colors.blue,
                    ),
                  ),
                ),
              ),
          ],
        ),
        border: InputBorder.none,
      ),
      inputFormatters: widget.inputFormatters,
      autocorrect: widget.autocorrect,
      textCapitalization: widget.textCapitalization,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      autofocus: widget.autofocus,
      onSubmitted: (val) {
        checkRegExp(val: val);
        if (widget.onSubmitted != null) {
          widget.onSubmitted!(val);
        }
      },
      focusNode: _focusNode,
    );
  }
}
