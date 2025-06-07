import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart'; // Adjust path if necessary.

class CustomAutoCompleteSearch<T extends Object> extends StatefulWidget {
  final String label;
  final FutureOr<Iterable<T>> Function(TextEditingValue textEditingValue)
      optionsBuilder;
  final String Function(T option) displayStringForOption;
  final void Function(T selectedOption)? onSelected;
  final String? Function(String? value)? validator;
  final Color accentColor;
  final T? initialValue;

  const CustomAutoCompleteSearch({
    super.key,
    required this.label,
    required this.optionsBuilder,
    required this.displayStringForOption,
    required this.accentColor,
    this.onSelected,
    this.validator,
    this.initialValue,
  });

  @override
  State<CustomAutoCompleteSearch<T>> createState() =>
      _CustomAutoCompleteSearchState<T>();
}

class _CustomAutoCompleteSearchState<T extends Object>
    extends State<CustomAutoCompleteSearch<T>> {
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  List<T> _options = [];
  bool readOnly = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _controller.text = widget.displayStringForOption(widget.initialValue!);
    }

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showOverlay();
      } else {
        _hideOverlay();
      }
    });

    _controller.addListener(_onChanged);
  }

  void _onChanged() async {
    final result =
        await widget.optionsBuilder(TextEditingValue(text: _controller.text));
    setState(() {
      _options = result.toList();
    });
    _updateOverlay();
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height),
          child: Material(
            color: Colors.white,
            elevation: 0,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(8.r),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 250.h,
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _options.length,
                itemBuilder: (context, index) {
                  final T option = _options[index];
                  return ListTile(
                    title: Text(widget.displayStringForOption(option)),
                    onTap: () {
                      _controller.text = widget.displayStringForOption(option);
                      widget.onSelected?.call(option);
                      _hideOverlay();
                      _focusNode.unfocus();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _hideOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        readOnly: readOnly,
        controller: _controller,
        focusNode: _focusNode,
        validator: widget.validator,
        decoration: InputDecoration(
          labelText: widget.label,
          contentPadding: EdgeInsets.only(top: 16.h),
          prefixIcon: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              setState(() {
                readOnly = !readOnly;
              });
            },
            icon: Padding(
              padding: EdgeInsets.all(8.sp),
              child: SvgPicture.asset(
                Assets.images.searchSpecial,
                colorFilter:
                    ColorFilter.mode(widget.accentColor, BlendMode.srcIn),
              ),
            ),
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.all(8.sp),
            child: SvgPicture.asset(
              Assets.images.arrowDown,
              colorFilter:
                  ColorFilter.mode(widget.accentColor, BlendMode.srcIn),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(8.r),
            ),
            borderSide: BorderSide(
              color: widget.accentColor,
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(8.r),
            ),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(8.r),
            ),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 2.0.w,
            ),
          ),
        ),
      ),
    );
  }
}
