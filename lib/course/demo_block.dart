import 'package:flutter/material.dart';

class DemoBlock extends StatelessWidget {
  const DemoBlock({
    super.key,
    required this.title,
    this.child,
    this.children,                 // 仍支援，但內容區固定高度建議用 child
    this.subtitle,
    this.info,
    this.margin = const EdgeInsets.symmetric(vertical: 8),
    this.padding = const EdgeInsets.all(12),
    this.borderColor,
    this.background,
    this.number,
    this.gap = 8,
    // —— 新增：內容區設定 ——
    this.contentHeight,            // 固定內容高度（給了就啟用固定內容區）
    this.contentBackground,        // 內容區背景色（預設淡灰）
    this.contentPadding = const EdgeInsets.all(12),
    this.contentBorderRadius = const BorderRadius.all(Radius.circular(8)),
    this.wrapChildAlignment,       // 若想由 DemoBlock 對齊 child，可傳 Alignment；預設 null 表示不包 Align（你可在 child 用 Center）
    // 舊版的撐高機制僅在沒有 contentHeight 時才會用
    this.placeholderHeight = 120,
    this.showDividerWhenEmpty = false,
  }) : assert(child == null || children == null, '只能使用 child 或 children 其中一個');

  final String title;
  final Widget? child;
  final List<Widget>? children;
  final String? subtitle;
  final String? info;

  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color? borderColor;
  final Color? background;
  final int? number;

  final double gap;

  // 固定內容區
  final double? contentHeight;                 // 給了就啟用固定內容區
  final Color? contentBackground;
  final EdgeInsets contentPadding;
  final BorderRadius contentBorderRadius;
  final AlignmentGeometry? wrapChildAlignment; // 若想由元件對齊 child，可傳 Alignment

  // 舊版撐高
  final double placeholderHeight;
  final bool showDividerWhenEmpty;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bc = borderColor ?? cs.outline;
    final bg = background ?? cs.surface;
    final textTheme = Theme.of(context).textTheme;

    final hasContent = child != null || (children != null && children!.isNotEmpty);

    // ——— 內容產生器（依是否有固定內容區）———
    Widget buildBody() {
      if (contentHeight != null) {
        Widget inner;
        if (children != null && children!.isNotEmpty) {
          inner = Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _withGaps(children!, gap),
          );
        } else {
          inner = child ?? const SizedBox.shrink();
        }
        if (wrapChildAlignment != null) {
          inner = Align(alignment: wrapChildAlignment!, child: inner);
        } else {
          // 你要預設置中就換成 Alignment.center
          inner = Align(alignment: Alignment.center, child: inner);
        }

        return Container(
          width: double.infinity,
          // ✅ 不再固定高度，改成「最多 contentHeight」
          constraints: BoxConstraints(
            minHeight: 0,
            maxHeight: contentHeight!, // 最多這麼高，空間不夠會縮小
          ),
          padding: contentPadding,
          decoration: BoxDecoration(
            color: contentBackground ?? Theme.of(context).colorScheme.surfaceVariant.withOpacity(.25),
            borderRadius: contentBorderRadius,
          ),
          // ✅ 內容多時在灰底區塊內滾動，避免溢出
          child: SingleChildScrollView(
            clipBehavior: Clip.hardEdge,
            child: inner,
          ),
        );
      }

      // —— 無 contentHeight 走原本「撐高但不拉伸子元件」——
      Widget inner;
      if (children != null && children!.isNotEmpty) {
        inner = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _withGaps(children!, gap),
        );
      } else {
        inner = child ?? const SizedBox.shrink();
      }
      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: placeholderHeight),
        child: Align(alignment: wrapChildAlignment ?? Alignment.center, child: inner),
      );
    }

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bc, width: 1),
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 標題列
            Row(
              children: [
                if (number != null) _NumberBadge(number: number!),
                Expanded(child: Text(title, style: textTheme.titleMedium)),
                if (info != null)
                  IconButton(
                    tooltip: '說明',
                    icon: const Icon(Icons.info_outline),
                    onPressed: () => _showInfoSheet(context, title, info!),
                  ),
              ],
            ),
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
            if (hasContent || showDividerWhenEmpty || subtitle != null) ...[
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 12),
            ],

            // 內容區（可能是固定高度灰底區）
            buildBody(),
          ],
        ),
      ),
    );
  }

  void _showInfoSheet(BuildContext context, String title, String message) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 16, right: 16, top: 12,
          bottom: 16 + MediaQuery.of(ctx).padding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(ctx).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(message, style: Theme.of(ctx).textTheme.bodyMedium),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('知道了'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _withGaps(List<Widget> items, double g) {
    if (g <= 0 || items.length < 2) return items;
    final out = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      out.add(items[i]);
      if (i != items.length - 1) out.add(SizedBox(height: g));
    }
    return out;
  }
}

class _NumberBadge extends StatelessWidget {
  const _NumberBadge({required this.number});
  final int number;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(.10),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: cs.primary, width: 1),
      ),
      child: Text(
        '$number',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: cs.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
