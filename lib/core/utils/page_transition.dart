import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'enum/slide_direction_enum.dart';

CustomTransitionPage slideTransition({
  required GoRouterState state,
  required Widget child,
  SlideDirectionEnum direction = SlideDirectionEnum.right,
  Curve curve = Curves.easeInOut,
}) {
  Offset getBeginOffset() {
    switch (direction) {
      case SlideDirectionEnum.left:
        return const Offset(-1, 0);
      case SlideDirectionEnum.right:
        return const Offset(1, 0);
      case SlideDirectionEnum.up:
        return const Offset(0, 1);
      case SlideDirectionEnum.down:
        return const Offset(0, -1);
    }
  }

  final tween = Tween(
    begin: getBeginOffset(),
    end: Offset.zero,
  ).chain(CurveTween(curve: curve));

  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, _, child) {
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
