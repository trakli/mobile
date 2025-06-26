import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SyncIndicatorOverlay extends StatefulWidget {
  final Color? indicatorColor;
  final Color? backgroundColor;
  final double? minHeight;
  final BorderRadius? borderRadius;

  const SyncIndicatorOverlay({
    super.key,
    this.indicatorColor,
    this.backgroundColor,
    this.minHeight,
    this.borderRadius,
  });

  @override
  State<SyncIndicatorOverlay> createState() => _SyncIndicatorOverlayState();
}

class _SyncIndicatorOverlayState extends State<SyncIndicatorOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ellipsisAnimationController;
  late Animation<int> _ellipsisAnimation;

  @override
  void initState() {
    super.initState();
    _ellipsisAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      // Cycle through dots every second
    )..repeat(); // Keep repeating indefinitely

    // Animate an integer from 0 to 3 (representing 0, 1, 2, or 3 dots).
    // The key here is that the IntTween itself will yield integer values,
    // and because we're directly using its value, it naturally steps.
    _ellipsisAnimation =
        IntTween(begin: 0, end: 3).animate(_ellipsisAnimationController);
  }

  @override
  void dispose() {
    _ellipsisAnimationController.dispose();
    super.dispose();
  }

  String _getEllipsisText(int dotCount) {
    switch (dotCount) {
      case 0:
        return '';
      case 1:
        return '.';
      case 2:
        return '..';
      case 3:
        return '...';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double effectiveMinHeight = widget.minHeight ?? 10.0.h;
    final BorderRadius effectiveBorderRadius =
        widget.borderRadius ?? BorderRadius.circular(15.r);
    final Color effectiveIndicatorColor =
        widget.indicatorColor ?? Theme.of(context).primaryColor;
    // final Color effectiveBackgroundColor =
    // widget.backgroundColor ?? Colors.teal.withValues(alpha: 0.2);

    return SafeArea(
      bottom: false,
      left: false,
      right: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.zero,
          child: Container(
            width: double.infinity,
            height: effectiveMinHeight + 15.h,
            color: effectiveIndicatorColor.withValues(alpha: .8),
            alignment: Alignment.center,
            // padding: const EdgeInsets.symmetric(vertical: 8),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                LinearProgressIndicator(
                    value: null,
                    minHeight: double.infinity, //effectiveMinHeight,
                    borderRadius: effectiveBorderRadius,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(effectiveIndicatorColor),
                    backgroundColor: effectiveIndicatorColor.withValues(
                        alpha: .8) //effectiveBackgroundColor
                    // effectiveIndicatorColor, //effectiveBackgroundColor,
                    ),
                AnimatedBuilder(
                  animation: _ellipsisAnimation,
                  builder: (context, child) {
                    final int currentDots = _ellipsisAnimation.value;
                    final String ellipsisText = _getEllipsisText(currentDots);

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Synchronizing',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 8.sp,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: SizedBox(
                            width: 20.h,
                            child: Text(
                              ellipsisText,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 8.sp,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // Scaffold(
    //   backgroundColor: Colors.transparent,
    //   body:
    // );
  }
}
