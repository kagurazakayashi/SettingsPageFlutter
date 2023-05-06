import 'package:flutter/cupertino.dart';

class WeCupertinoTextField extends StatefulWidget {
  const WeCupertinoTextField({
    Key? key,
    required this.controller,
    this.style,
    this.readOnly = false,
    this.labelText,
    this.labelStyle,
    this.hintText,
    this.hintStyle,
    this.suffixIcon,
    this.decoration,
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
    this.isDark = false,
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
  final BoxDecoration? decoration;
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
  final bool isDark;
  final String id;
  final String value;
  final Function(String key, dynamic value, bool isTip) onChanged;

  @override
  State<WeCupertinoTextField> createState() => _WeCupertinoTextFieldState();
}

class _WeCupertinoTextFieldState extends State<WeCupertinoTextField> {
  bool _obscureText = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _obscureText = widget.obscureText;
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        widget.onChanged(widget.id, widget.controller.text, true);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text("${widget.labelText}: ", style: widget.labelStyle),
        CupertinoTextField(
          controller: widget.controller,
          style: widget.style,
          readOnly: widget.readOnly,
          suffix: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.suffixIcon != null) widget.suffixIcon!,
              if (widget.obscureText)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText
                        ? CupertinoIcons.eye_fill
                        : CupertinoIcons.eye_slash_fill,
                    semanticLabel:
                        _obscureText ? 'show password' : 'hide password',
                    color: widget.isDark ? const Color(0xB3FFFFFF) : null,
                  ),
                ),
              if (!widget.readOnly)
                GestureDetector(
                  onTap: widget.controller.text.isEmpty
                      ? null
                      : () {
                          widget.controller.text = "";
                          widget.onChanged(widget.id, "", false);
                        },
                  child: Container(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(
                      CupertinoIcons.clear_thick_circled,
                      color: widget.value == ""
                          ? const Color(0xFF9E9E9E)
                          : const Color(0xFF2196F3),
                    ),
                  ),
                ),
            ],
          ),
          placeholder: widget.hintText,
          placeholderStyle: widget.hintStyle,
          decoration: widget.decoration,
          autocorrect: widget.autocorrect,
          textCapitalization: widget.textCapitalization,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          autofocus: widget.autofocus,
          onSubmitted: widget.onSubmitted,
          focusNode: _focusNode,
        ),
      ],
    );
  }
}
