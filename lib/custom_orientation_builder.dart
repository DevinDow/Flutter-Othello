import 'package:flutter/material.dart';

/// Signature for a function that builds a widget given an [Orientation].
///
/// Used by [OrientationBuilder.builder].
typedef CustomOrientationWidgetBuilder = Widget Function(
    BuildContext context, Orientation orientation);

/// Builds a widget tree that can depend on the parent widget's orientation
/// (distinct from the device orientation).
///
/// See also:
///
///  * [LayoutBuilder], which exposes the complete constraints, not just the
///    orientation.
///  * [CustomSingleChildLayout], which positions its child during layout.
///  * [CustomMultiChildLayout], with which you can define the precise layout
///    of a list of children during the layout phase.
///  * [MediaQueryData.orientation], which exposes whether the device is in
///    landscape or portrait mode.
class CustomOrientationBuilder extends StatelessWidget {
  final double uiWidth; // width taken by other UI in Landscape mode
  final double uiHeight; // height taken by other UI in Portrait mode

  /// Creates an orientation builder.
  ///
  /// The [builder] argument must not be null.
  const CustomOrientationBuilder({
    super.key,
    this.uiWidth = 0,
    this.uiHeight = 0,
    required this.builder,
  });

  /// Builds the widgets below this widget given this widget's orientation.
  ///
  /// A widget's orientation is a factor of its width relative to its
  /// height. For example, a [Column] widget will have a landscape orientation
  /// if its width exceeds its height, even though it displays its children in
  /// a vertical array.
  final CustomOrientationWidgetBuilder builder;

  Widget _buildWithConstraints(
      BuildContext context, BoxConstraints constraints) {
    // Which Orientation will provide the biggest Board after considering the other UI sizes?
    // If the constraints are fully unbounded (i.e., maxWidth and maxHeight are
    // both infinite), we prefer Orientation.portrait because its more common to
    // scroll vertically then horizontally.
    final Orientation orientation =
        constraints.maxWidth - uiWidth > constraints.maxHeight - uiHeight
            ? Orientation.landscape
            : Orientation.portrait;
    return builder(context, orientation);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _buildWithConstraints);
  }
}
