import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme.dart';

enum TmBannerTone { bull, warn, bear }

/// Shared Trade Master journey chrome (ink / cyan).
class TmKit {
  static EdgeInsets get screenPadding =>
      const EdgeInsets.symmetric(horizontal: 20, vertical: 16);

  static TextStyle get stageLabel => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.06,
        color: AppTheme.faint,
      );

  static TextStyle get screenTitle => const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: AppTheme.text,
        height: 1.2,
      );

  static TextStyle get bodyMuted => const TextStyle(
        color: AppTheme.muted,
        fontSize: 14,
        height: 1.45,
      );

  static TextStyle get monoValue => TextStyle(
        fontFamily: 'monospace',
        fontWeight: FontWeight.w700,
        color: AppTheme.accent,
        fontSize: 15,
      );
}

class TmScreen extends StatelessWidget {
  final String? stageLabel;
  final String title;
  final String? subtitle;
  final Widget body;
  final Widget? bottomBar;
  final bool showBack;

  const TmScreen({
    super.key,
    this.stageLabel,
    required this.title,
    this.subtitle,
    required this.body,
    this.bottomBar,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        leading: showBack
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.canPop() ? context.pop() : context.go('/'),
              )
            : null,
        title: stageLabel != null
            ? Text(stageLabel!, style: TmKit.stageLabel.copyWith(fontSize: 11))
            : null,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: TmKit.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TmKit.screenTitle),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppTheme.spaceSm),
                    Text(subtitle!, style: TmKit.bodyMuted),
                  ],
                  const SizedBox(height: AppTheme.spaceXl),
                  body,
                ],
              ),
            ),
          ),
          if (bottomBar != null)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, AppTheme.spaceLg),
                child: bottomBar!,
              ),
            ),
        ],
      ),
    );
  }
}

/// Uppercase mono section label.
class TmCap extends StatelessWidget {
  const TmCap(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.jetBrainsMono(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: color ?? AppTheme.faint,
      ),
    );
  }
}

class TmTitle extends StatelessWidget {
  const TmTitle(this.text, {super.key, this.maxLines});

  final String text;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.text,
          ),
    );
  }
}

class TmSub extends StatelessWidget {
  const TmSub(this.text, {super.key, this.maxLines});

  final String text;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.muted,
            height: 1.45,
          ),
    );
  }
}

class TmCard extends StatelessWidget {
  final Widget child;

  /// Legacy: accent border card (prefer [TmAccentCard] in new code).
  final Color? accent;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final Color? color;

  const TmCard({
    super.key,
    required this.child,
    this.accent,
    this.padding = const EdgeInsets.all(AppTheme.spaceLg),
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (accent != null) {
      return TmAccentCard(
        accentColor: accent!,
        padding: padding,
        onTap: onTap,
        child: child,
      );
    }
    final box = Container(
      width: double.infinity,
      padding: padding,
      decoration: AppTheme.cardDecoration(color: color),
      child: child,
    );
    if (onTap == null) return box;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: box,
      ),
    );
  }
}

class TmAccentCard extends StatelessWidget {
  const TmAccentCard({
    super.key,
    required this.child,
    this.accentColor = AppTheme.accent,
    this.padding = const EdgeInsets.all(AppTheme.spaceLg),
    this.onTap,
  });

  final Widget child;
  final Color accentColor;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final box = Container(
      width: double.infinity,
      padding: padding,
      decoration: AppTheme.accentCardDecoration(accentColor),
      child: child,
    );
    if (onTap == null) return box;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: box,
      ),
    );
  }
}

class TmPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool enabled;
  final double height;

  const TmPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.enabled = true,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: AppTheme.spaceSm),
            ],
            Text(label),
          ],
        ),
      ),
    );
  }
}

class TmGhostButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double height;

  const TmGhostButton({
    super.key,
    required this.label,
    this.onPressed,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: OutlinedButton(onPressed: onPressed, child: Text(label)),
    );
  }
}

class TmCoach extends StatelessWidget {
  const TmCoach({
    super.key,
    required this.message,
    this.title,
  });

  final String message;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spaceLg,
        AppTheme.spaceMd,
        AppTheme.spaceLg,
        AppTheme.spaceMd,
      ),
      decoration: BoxDecoration(
        color: AppTheme.accentDim,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.45)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: AppTheme.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppTheme.accent,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: AppTheme.spaceXs),
                ],
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.text,
                        height: 1.45,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TmBanner extends StatelessWidget {
  const TmBanner({
    super.key,
    required this.text,
    this.tone = TmBannerTone.bull,
    this.icon,
  });

  final String text;
  final TmBannerTone tone;
  final IconData? icon;

  Color get _fg {
    switch (tone) {
      case TmBannerTone.bull:
        return AppTheme.bull;
      case TmBannerTone.warn:
        return AppTheme.warn;
      case TmBannerTone.bear:
        return AppTheme.bear;
    }
  }

  Color get _bg {
    switch (tone) {
      case TmBannerTone.bull:
        return AppTheme.bullSoft;
      case TmBannerTone.warn:
        return AppTheme.surface3;
      case TmBannerTone.bear:
        return AppTheme.bearSoft;
    }
  }

  IconData get _defaultIcon {
    switch (tone) {
      case TmBannerTone.bull:
        return Icons.trending_up_rounded;
      case TmBannerTone.warn:
        return Icons.info_outline_rounded;
      case TmBannerTone.bear:
        return Icons.trending_down_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _fg;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceLg,
        vertical: AppTheme.spaceMd,
      ),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          Icon(icon ?? _defaultIcon, color: color, size: 22),
          const SizedBox(width: AppTheme.spaceMd),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.text,
                    height: 1.4,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class TmRowCheck extends StatelessWidget {
  const TmRowCheck({
    super.key,
    required this.label,
    this.done = false,
    this.trailing,
  });

  final String label;
  final bool done;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final iconColor = done ? AppTheme.bull : AppTheme.faint;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceSm),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            color: iconColor,
            size: 22,
          ),
          const SizedBox(width: AppTheme.spaceMd),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: done ? AppTheme.text : AppTheme.muted,
                    fontWeight: done ? FontWeight.w600 : FontWeight.w400,
                  ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class TmChip extends StatelessWidget {
  const TmChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.accentColor = AppTheme.accent,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? accentColor.withValues(alpha: 0.18) : AppTheme.surface2;
    final border = selected ? accentColor.withValues(alpha: 0.55) : AppTheme.lineSoft;
    final fg = selected ? accentColor : AppTheme.text;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spaceMd,
            vertical: AppTheme.spaceSm,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: border),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 13,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class TmProgressBar extends StatelessWidget {
  const TmProgressBar({
    super.key,
    required this.value,
    this.height = 6,
    this.color = AppTheme.accent,
  });

  final double value;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: height,
        backgroundColor: AppTheme.lineSoft,
        color: color,
      ),
    );
  }
}

/// Lesson step dots: filled = completed, accent = current.
class TmSegmentDots extends StatelessWidget {
  const TmSegmentDots({
    super.key,
    required this.total,
    required this.currentIndex,
    this.completedThrough,
  });

  final int total;
  final int currentIndex;
  final int? completedThrough;

  @override
  Widget build(BuildContext context) {
    if (total <= 0) return const SizedBox.shrink();
    final done = completedThrough ?? currentIndex;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        final isDone = i < done;
        final isCurrent = i == currentIndex;
        final Color fill;
        if (isDone) {
          fill = AppTheme.bull;
        } else if (isCurrent) {
          fill = AppTheme.accent;
        } else {
          fill = AppTheme.lineSoft;
        }
        return Padding(
          padding: EdgeInsets.only(right: i < total - 1 ? AppTheme.spaceSm : 0),
          child: Container(
            width: isCurrent ? 20 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        );
      }),
    );
  }
}

/// Screen body with SafeArea; optional bottom padding for shell nav.
class TmScreenScaffold extends StatelessWidget {
  const TmScreenScaffold({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: AppTheme.spaceXl),
    this.bottomInset = true,
    this.backgroundColor = AppTheme.bg,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool bottomInset;
  final Color backgroundColor;

  static const double _navClearance = 88;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: padding.add(
            EdgeInsets.only(
              bottom: bottomInset ? _navClearance : 0,
              top: AppTheme.spaceLg,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class TmGateChip extends StatelessWidget {
  final String label;
  final bool done;
  final bool current;

  const TmGateChip({
    super.key,
    required this.label,
    this.done = false,
    this.current = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = done
        ? AppTheme.bull
        : current
            ? AppTheme.accent
            : AppTheme.faint;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: done
            ? AppTheme.bullSoft
            : current
                ? AppTheme.accentDim
                : AppTheme.surface2,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            done ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TmTeacherLine extends StatelessWidget {
  final String name;
  final String message;

  const TmTeacherLine({
    super.key,
    this.name = 'Desk Trader',
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return TmCard(
      accent: AppTheme.accent,
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: AppTheme.accentDim,
            child: Icon(Icons.school, color: AppTheme.accent, size: 18),
          ),
          const SizedBox(width: AppTheme.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
                const SizedBox(height: AppTheme.spaceXs),
                Text(
                  message,
                  style: TmKit.bodyMuted.copyWith(color: AppTheme.text, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TmMiniChart extends StatelessWidget {
  const TmMiniChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppTheme.bg2,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.lineSoft),
      ),
      child: CustomPaint(
        painter: _ChartPainter(),
        size: const Size(double.infinity, 120),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = AppTheme.accent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final zone = Paint()..color = AppTheme.accent.withValues(alpha: 0.12);
    canvas.drawRect(
      Rect.fromLTWH(12, size.height * 0.55, size.width - 24, size.height * 0.2),
      zone,
    );
    final path = Path();
    final points = [0.72, 0.68, 0.62, 0.58, 0.52, 0.48, 0.44, 0.42];
    for (var i = 0; i < points.length; i++) {
      final x = 12 + (size.width - 24) * i / (points.length - 1);
      final y = size.height * points[i];
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, line);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TmSegmentCounter extends StatelessWidget {
  final int total;
  final int passed;
  final int failed;

  const TmSegmentCounter({
    super.key,
    this.total = 10,
    required this.passed,
    required this.failed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        Color c = AppTheme.surface3;
        if (i < passed) {
          c = AppTheme.bull;
        } else if (i < passed + failed) {
          c = AppTheme.bear;
        } else if (i == passed + failed) {
          c = AppTheme.accent;
        }
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < total - 1 ? AppTheme.spaceXs : 0),
            height: 8,
            decoration: BoxDecoration(
              color: c,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}
