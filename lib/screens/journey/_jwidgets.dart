import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';

class JourneyScaffold extends StatelessWidget {
  const JourneyScaffold({
    super.key,
    required this.title,
    this.subtitle,
    required this.body,
    this.bottom,
    this.showBack = true,
    this.stepLabel,
  });

  final String title;
  final String? subtitle;
  final Widget body;
  final Widget? bottom;
  final bool showBack;
  final String? stepLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
              child: Row(
                children: [
                  if (showBack)
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                      color: AppTheme.muted,
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        }
                      },
                    )
                  else
                    const SizedBox(width: 8),
                  if (stepLabel != null)
                    Text(
                      stepLabel!,
                      style: textTheme.labelLarge?.copyWith(color: AppTheme.faint),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppTheme.text,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle!,
                      style: textTheme.bodyMedium?.copyWith(height: 1.45),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: body),
            if (bottom != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                child: bottom!,
              ),
          ],
        ),
      ),
    );
  }
}

class TmCard extends StatelessWidget {
  const TmCard({
    super.key,
    required this.child,
    this.accent = false,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final bool accent;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: accent
          ? AppTheme.accentCardDecoration(AppTheme.accent)
          : AppTheme.cardDecoration(),
      child: child,
    );
  }
}

class TmPrimaryButton extends StatelessWidget {
  const TmPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(label),
      ),
    );
  }
}

class TmGhostButton extends StatelessWidget {
  const TmGhostButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class TmProgressLine extends StatelessWidget {
  const TmProgressLine({super.key, required this.value, this.label});

  final double value;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: value.clamp(0, 1),
            minHeight: 8,
            backgroundColor: AppTheme.surface3,
          ),
        ),
      ],
    );
  }
}

class TmStatRow extends StatelessWidget {
  const TmStatRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.accentDim,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF1F5566)),
          ),
          child: Icon(icon, color: AppTheme.accent, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.text,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: AppTheme.muted, height: 1.4, fontSize: 13.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OtpSixCells extends StatefulWidget {
  const OtpSixCells({super.key, this.onCompleted});

  final ValueChanged<String>? onCompleted;

  @override
  State<OtpSixCells> createState() => _OtpSixCellsState();
}

class _OtpSixCellsState extends State<OtpSixCells> {
  static const _len = 6;
  final _controllers = List.generate(_len, (_) => TextEditingController());
  final _focus = List.generate(_len, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focus) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.length > 1) {
      _controllers[index].text = value.substring(value.length - 1);
    }
    if (value.isNotEmpty && index < _len - 1) {
      _focus[index + 1].requestFocus();
    }
    final code = _controllers.map((c) => c.text).join();
    if (code.length == _len) {
      widget.onCompleted?.call(code);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < _len; i++)
          SizedBox(
            width: 48,
            height: 56,
            child: TextField(
              controller: _controllers[i],
              focusNode: _focus[i],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: const TextStyle(
                color: AppTheme.text,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: AppTheme.bg2,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _controllers[i].text.isNotEmpty
                        ? AppTheme.accent
                        : AppTheme.lineSoft,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.accent, width: 1.5),
                ),
              ),
              onChanged: (v) => _onChanged(i, v),
            ),
          ),
      ],
    );
  }
}

class TelegramChatMock extends StatelessWidget {
  const TelegramChatMock({
    super.key,
    required this.channelTitle,
    required this.messages,
  });

  final String channelTitle;
  final List<TgMessage> messages;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0E1621),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: AppTheme.lineSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF17212B),
              borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLg)),
            ),
            child: Row(
              children: [
                const Icon(Icons.arrow_back, color: AppTheme.muted, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        channelTitle,
                        style: const TextStyle(
                          color: AppTheme.text,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const Text(
                        'Desk Club · Academy',
                        style: TextStyle(color: AppTheme.faint, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_vert, color: AppTheme.muted, size: 20),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, i) {
                final m = messages[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Align(
                    alignment: m.outgoing ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 280),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: m.outgoing
                            ? const Color(0xFF2B5278)
                            : const Color(0xFF182533),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(14),
                          topRight: const Radius.circular(14),
                          bottomLeft: Radius.circular(m.outgoing ? 14 : 4),
                          bottomRight: Radius.circular(m.outgoing ? 4 : 14),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (m.author != null)
                            Text(
                              m.author!,
                              style: TextStyle(
                                color: m.outgoing ? AppTheme.accent : AppTheme.bull,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          if (m.author != null) const SizedBox(height: 4),
                          Text(
                            m.text,
                            style: const TextStyle(
                              color: AppTheme.text,
                              height: 1.35,
                              fontSize: 14,
                            ),
                          ),
                          if (m.tag != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              m.tag!,
                              style: const TextStyle(
                                color: AppTheme.accent,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TgMessage {
  const TgMessage({
    required this.text,
    this.author,
    this.outgoing = false,
    this.tag,
  });

  final String text;
  final String? author;
  final bool outgoing;
  final String? tag;
}

class WebPageChrome extends StatelessWidget {
  const WebPageChrome({
    super.key,
    required this.urlBar,
    required this.child,
  });

  final String urlBar;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.surface2,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.lineSoft),
          ),
          child: Row(
            children: [
              const Icon(Icons.lock_outline, size: 16, color: AppTheme.bull),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  urlBar,
                  style: const TextStyle(color: AppTheme.muted, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }
}
