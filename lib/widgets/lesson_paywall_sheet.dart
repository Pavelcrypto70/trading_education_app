import 'package:flutter/material.dart';

import '../config/build_flags.dart';
import '../services/entitlement_service.dart';

/// Course is free — never shows a payment / lock sheet.
Future<bool> showLessonPaywallIfNeeded(
  BuildContext context,
  int lessonId, {
  VoidCallback? leave,
}) async {
  if (BuildFlags.courseFree) return true;
  if (await EntitlementService.isLessonUnlocked(lessonId)) return true;
  // Legacy gated mode without billing: still do not offer payment.
  leave?.call();
  return true;
}
