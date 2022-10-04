import 'package:flutter/widgets.dart';

/// Extension on [Animation] to get a bouncy animation.
extension BouncyAnimation on Animation<double> {
  /// drive a bouncy animation.
  Animation<double> driveBouncy() => drive(
        TweenSequence([
          TweenSequenceItem(tween: Tween(begin: 0, end: 1.3), weight: 0.7),
          TweenSequenceItem(tween: Tween(begin: 1.3, end: 1), weight: 0.3)
        ]),
      );
}
