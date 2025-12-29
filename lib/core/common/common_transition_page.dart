import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage slideUpTransition({
  required GoRouterState state,
  required Widget child,
  Curve curve = Curves.easeOut,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, _, child) {
      final tween = Tween(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
