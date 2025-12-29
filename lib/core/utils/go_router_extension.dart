import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'enum/slide_direction_enum.dart';
import 'page_transition.dart';

extension SlideTransitionExt on GoRouterState {
  CustomTransitionPage slide({
    required Widget child,
    SlideDirectionEnum direction = SlideDirectionEnum.right,
    Curve curve = Curves.easeInOut,
  }) {
    return slideTransition(
      state: this,
      child: child,
      direction: direction,
      curve: curve,
    );
  }
}
