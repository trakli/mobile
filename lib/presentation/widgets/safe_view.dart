import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';

/// Error boundary for widgets that may throw while building, such as
/// third-party debug tools. Shows a contained fallback with the error and
/// a retry button instead of the framework's error screen.
///
/// While mounted this overrides [ErrorWidget.builder] so build failures in
/// descendants are contained too; keep it scoped to leaf screens.
class SafeView extends StatefulWidget {
  const SafeView({super.key, required this.builder});

  /// Builds the guarded subtree; called again on each retry.
  final WidgetBuilder builder;

  @override
  State<SafeView> createState() => _SafeViewState();
}

class _SafeViewState extends State<SafeView> {
  late final ErrorWidgetBuilder _previousErrorBuilder;
  FlutterErrorDetails? _error;
  int _attempt = 0;

  @override
  void initState() {
    super.initState();
    _previousErrorBuilder = ErrorWidget.builder;
    ErrorWidget.builder = (details) {
      // Called mid-build; defer the state change to the next frame.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _error == null) {
          setState(() => _error = details);
        }
      });
      return const SizedBox.shrink();
    };
  }

  @override
  void dispose() {
    ErrorWidget.builder = _previousErrorBuilder;
    super.dispose();
  }

  void _retry() {
    setState(() {
      _error = null;
      _attempt++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final error = _error;
    if (error != null) {
      return _SafeViewFallback(error: error.exception, onRetry: _retry);
    }
    try {
      return KeyedSubtree(
        key: ValueKey(_attempt),
        child: widget.builder(context),
      );
    } catch (e) {
      return _SafeViewFallback(error: e, onRetry: _retry);
    }
  }
}

class _SafeViewFallback extends StatelessWidget {
  const _SafeViewFallback({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              LocaleKeys.unknownErrorDesc.tr(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Flexible(
              child: SingleChildScrollView(
                child: SelectableText(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(LocaleKeys.retry.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
