import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      centerTitle: true,
      title: Stack(
        alignment: Alignment.center,
        children: [
          Transform.translate(
            offset: const Offset(-100, 0),
            child: SvgPicture.asset(
              'assets/icons/home/zombie_icon.svg',
              width: 48,
              height: 48,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(
                colorScheme.onSurface,
                BlendMode.srcIn
              ),
            ),
          ),
           const SizedBox(width: 8),
          Text(title),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}