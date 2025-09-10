import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class PerformanceUtils {
  /// Check if running on web
  static bool get isWeb => kIsWeb;

  /// Get optimized cache extent for web
  static double getCacheExtent() {
    if (kIsWeb) {
      return 1000.0;
    }
    return 250.0;
  }

  /// Get optimized scroll physics for web
  static ScrollPhysics getScrollPhysics() {
    if (kIsWeb) {
      return const AlwaysScrollableScrollPhysics();
    }
    return const BouncingScrollPhysics();
  }

  /// Wrap widget with RepaintBoundary for better performance
  static Widget wrapWithRepaintBoundary(Widget child) {
    return RepaintBoundary(child: child);
  }

  /// Create optimized list view builder
  static Widget optimizedListViewBuilder({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    ScrollController? controller,
    bool shrinkWrap = false,
    ScrollPhysics? physics,
    EdgeInsets? padding,
    double? cacheExtent,
    bool addRepaintBoundary = true,
  }) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final widget = itemBuilder(context, index);
        return addRepaintBoundary ? RepaintBoundary(child: widget) : widget;
      },
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics ?? getScrollPhysics(),
      padding: padding,
      cacheExtent: cacheExtent ?? getCacheExtent(),
    );
  }

  /// Create optimized grid view builder
  static Widget optimizedGridViewBuilder({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    required int crossAxisCount,
    double mainAxisSpacing = 0,
    double crossAxisSpacing = 0,
    EdgeInsets? padding,
    ScrollPhysics? physics,
    double? cacheExtent,
    bool addRepaintBoundary = true,
  }) {
    return GridView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final widget = itemBuilder(context, index);
        return addRepaintBoundary ? RepaintBoundary(child: widget) : widget;
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
      ),
      padding: padding,
      physics: physics ?? getScrollPhysics(),
      cacheExtent: cacheExtent ?? getCacheExtent(),
    );
  }

  /// Optimize image dimensions for web
  static int getOptimizedImageWidth() {
    if (kIsWeb) {
      return 800;
    }
    return 400;
  }

  static int getOptimizedImageHeight() {
    if (kIsWeb) {
      return 600;
    }
    return 300;
  }
}
