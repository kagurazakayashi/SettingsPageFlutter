import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WeTextField extends StatefulWidget {
  const WeTextField({
    Key? key,
    required this.controller,
    this.suggestions = const [],
    this.noResulteLabel,
    this.style,
    this.readOnly = false,
    this.labelText,
    this.labelStyle,
    this.hintText,
    this.hintStyle,
    this.helpText,
    this.helpStyle,
    this.fillColor,
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
  final List<String> suggestions;
  final String? noResulteLabel;
  final TextStyle? style;
  final bool readOnly;
  final String? labelText;
  final TextStyle? labelStyle;
  final String? hintText;
  final TextStyle? hintStyle;
  final String? helpText;
  final TextStyle? helpStyle;
  final Color? fillColor;
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

class _WeTextFieldState extends State<WeTextField> with WidgetsBindingObserver {
  String changedStr = "";
  bool _obscureText = false;
  bool isChange = false;
  final FocusNode _focusNode = FocusNode();
  int nowSelection = 0;
  SuggestionsBoxController suggestionBoxController = SuggestionsBoxController();

  List<String> suggestions = [];

  @override
  void initState() {
    _obscureText = widget.obscureText;
    _focusNode.addListener(onFocus);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeMetrics() {
    checkRegExp();
    super.didChangeMetrics();
  }

  @override
  void dispose() {
    _focusNode.removeListener(onFocus);
    _focusNode.dispose();
    widget.controller.dispose();
    suggestionBoxController.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void onFocus() {
    if (!_focusNode.hasFocus) {
      checkRegExp();
      if (isChange) {
        setSelection();
      }
      suggestionBoxController.close();
    }

    nowSelection = widget.controller.selection.baseOffset;
  }

  void checkRegExp({bool isSubmitted = true, String? val}) {
    if (val == null) {
      return;
    }
    bool isRegExp = true;
    String v = val;
    if (!isChange && widget.onSubRegExp != null) {
      isRegExp = widget.onSubRegExp!.hasMatch(v);
    }
    if (!isRegExp) {
      v = "";
    }
    if ((v != widget.controller.text) ||
        (changedStr != widget.controller.text)) {
      widget.controller.text = v;
      changedStr = widget.controller.text;
      widget.onChanged(widget.id, v, true);

      setSelection();
    }
  }

  List<String> getSuggestions(String query) {
    List<String> matches = <String>[];
    matches.addAll(widget.suggestions);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  /// Widget that will be displayed when no results were found
  Widget getNoResultText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(widget.noResulteLabel ?? "No results found!"),
    );
  }

  void setSelection() {
    if (nowSelection > widget.controller.selection.baseOffset) {
      return;
    }
    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(
        offset: nowSelection,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> suffixIcons = [];
    if (widget.suffixIcon != null) {
      suffixIcons.add(widget.suffixIcon!);
    }
    if (widget.obscureText) {
      suffixIcons.add(Semantics(
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
      ));
    }

    if (!widget.readOnly) {
      suffixIcons.add(Semantics(
        label: widget.clearSemantics,
        button: true,
        child: GestureDetector(
          onTap: widget.controller.text.isEmpty
              ? null
              : () {
                  widget.controller.text = "";
                  widget.onChanged(widget.id, "", false);
                  // nowSelection = 0;
                },
          child: Container(
            padding: const EdgeInsets.only(left: 8),
            child: Icon(
              Icons.cancel,
              color: widget.value == "" ? Colors.grey : Colors.blue,
            ),
          ),
        ),
      ));
    }
    setSelection();
    if (widget.suggestions.isNotEmpty) {
      return DropDownSearchField(
        textFieldConfiguration: TextFieldConfiguration(
          controller: widget.controller,
          style: widget.style,
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: widget.labelStyle,
            hintText: widget.hintText,
            hintStyle: widget.hintStyle,
            helperText: widget.helpText,
            helperStyle: widget.helpStyle,
            filled: widget.fillColor == null ? false : !widget.readOnly,
            fillColor: widget.fillColor,
            suffixIcon: suffixIcons.isEmpty
                ? null
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: suffixIcons,
                  ),
            border: InputBorder.none,
          ),
          inputFormatters: widget.inputFormatters,
          autocorrect: widget.autocorrect,
          textCapitalization: widget.textCapitalization,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          textInputAction: widget.textInputAction,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          autofocus: widget.autofocus,
          onChanged: widget.readOnly
              ? null
              : (val) {
                  isChange = true;
                  nowSelection = widget.controller.selection.baseOffset;
                  checkRegExp(isSubmitted: false, val: val);
                },
          onSubmitted: widget.readOnly
              ? null
              : (val) {
                  isChange = false;
                  checkRegExp(val: val);
                  if (widget.onSubmitted != null) {
                    widget.onSubmitted!(val);
                  }
                },
          focusNode: _focusNode,
        ),
        itemBuilder: (context, String suggestion) {
          return ListTile(
            title: Text(
              suggestion,
              style: TextStyle(
                color: widget.isDark ? Colors.white : Colors.black,
              ),
            ),
          );
        },
        suggestionsCallback: getSuggestions,
        noItemsFoundBuilder: getNoResultText,
        onSuggestionSelected: (String suggestion) {
          isChange = true;
          nowSelection = widget.controller.selection.baseOffset;
          checkRegExp(isSubmitted: false, val: suggestion);
        },
        suggestionsBoxController: suggestionBoxController,
        displayAllSuggestionWhenTap: true,
        isMultiSelectDropdown: false,
      );
    }
    return TextField(
      controller: widget.controller,
      style: widget.style,
      readOnly: widget.readOnly,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: widget.labelStyle,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        helperText: widget.helpText,
        helperStyle: widget.helpStyle,
        filled: widget.fillColor == null ? false : !widget.readOnly,
        fillColor: widget.fillColor,
        suffixIcon: suffixIcons.isEmpty
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: suffixIcons,
              ),
        border: InputBorder.none,
        // border: !widget.readOnly
        //     ? OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(8),
        //         borderSide: BorderSide(
        //           color: widget.isDark ? Colors.white10 : Colors.grey[300]!,
        //         ),
        //       )
        //     : InputBorder.none,
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
      onChanged: (val) {
        isChange = true;
        nowSelection = widget.controller.selection.baseOffset;
        checkRegExp(isSubmitted: false, val: val);
      },
      onSubmitted: (val) {
        isChange = false;
        checkRegExp(val: val);
        if (widget.onSubmitted != null) {
          widget.onSubmitted!(val);
        }
      },
      focusNode: _focusNode,
    );
  }
}
