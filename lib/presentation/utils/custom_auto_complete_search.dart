import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';

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
      setState(() {});
      initializeOptions();
    });

    _controller.addListener(_onChanged);
  }

  initializeOptions() async {
    final result =
        await widget.optionsBuilder(TextEditingValue(text: _controller.text));

    _options = result.toList();
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
            elevation: 4,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(8.r),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 250.h,
              ),
              child: _options.isNotEmpty
                  ? Builder(builder: (context) {
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: _options.length,
                        itemBuilder: (context, index) {
                          final T option = _options[index];
                          return ListTile(
                            title: Text(widget.displayStringForOption(option)),
                            onTap: () {
                              _controller.text =
                                  widget.displayStringForOption(option);
                              widget.onSelected?.call(option);
                              _hideOverlay();
                              _focusNode.unfocus();
                            },
                          );
                        },
                      );
                    })
                  : ListTile(
                      onTap: () {
                        _focusNode.unfocus();
                      },
                      title: const Text("No data"),
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
      child: Material(
        color: _focusNode.hasFocus
            ? Colors.white
            : Theme.of(context).scaffoldBackgroundColor,
        elevation: _focusNode.hasFocus ? 4 : 0,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8.r),
          bottom: Radius.circular(_focusNode.hasFocus ? 0 : 8.r),
        ),
        child: TextFormField(
          readOnly: readOnly,
          controller: _controller,
          focusNode: _focusNode,
          validator: widget.validator,
          decoration: InputDecoration(
            fillColor: _focusNode.hasFocus ? Colors.white : null,
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
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 8.h,
                ),
                child: SvgPicture.asset(
                  Assets.images.searchSpecial,
                  colorFilter:
                      ColorFilter.mode(widget.accentColor, BlendMode.srcIn),
                ),
              ),
            ),
            suffixIcon: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                if (_focusNode.hasFocus) {
                  _focusNode.unfocus();
                } else {
                  _focusNode.requestFocus();
                }
              },
              icon: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 8.h,
                ),
                child: SvgPicture.asset(
                  Assets.images.arrowDown,
                  colorFilter:
                      ColorFilter.mode(widget.accentColor, BlendMode.srcIn),
                ),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(8.r),
              ),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 2.0.w,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
