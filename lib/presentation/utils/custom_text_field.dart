import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final Widget? prefix;
  final bool isPassword;
  final bool readOnly;
  final bool showBottomBorder;
  final bool showNoBorders;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final Widget? suffixIcon;
  final int maxLines;
  final int? maxLength;

  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final bool filled;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.prefix,
    this.isPassword = false,
    this.readOnly = false,
    this.showBottomBorder = false,
    this.showNoBorders = false,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onTap,
    this.onFieldSubmitted,
    this.validator,
    this.suffixIcon,
    this.filled = false,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  void _changeTextVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    InputBorder? border(Color color, [double width = 1]) {
      if (widget.showNoBorders) return InputBorder.none;
      if (widget.showBottomBorder) {
        return UnderlineInputBorder(
          borderSide: BorderSide(color: color, width: width),
        );
      }
      return null;
    }

    return TextFormField(
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      onTapOutside: (c) => hideKeyBoard(),
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      controller: widget.controller,
      textInputAction: TextInputAction.next,
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword && obscureText,
      obscuringCharacter: '*',
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      style: TextStyle(fontSize: 14.lx, color: t.textPrimary),
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: widget.prefix == null
            ? null
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.lx),
                child: widget.prefix,
              ),
        prefixIconConstraints: BoxConstraints(
          maxHeight: 40.lx,
          maxWidth: 44.lx,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? LucideIcons.eyeOff : LucideIcons.eye,
                  size: 17.lx,
                  color: t.textMuted,
                ),
                onPressed: _changeTextVisibility,
              )
            : widget.suffixIcon,
        border: border(t.borderLight),
        enabledBorder: border(t.borderLight),
        focusedBorder: border(t.brandFill, 1.4),
        errorBorder: border(t.expenseColor),
        focusedErrorBorder: border(t.expenseColor, 1.4),
        filled: widget.showNoBorders || widget.showBottomBorder
            ? widget.filled
            : null,
      ),
    );
  }
}
