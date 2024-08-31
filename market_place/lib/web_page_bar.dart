import 'package:flutter/material.dart';

class WebPageBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<String> pages;

  const WebPageBar({
    super.key,
    required this.title,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black38,
      title: Text(
        "DEGames: $title",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      actions: pages.map((page) => _buildAnimatedButton(context, page)).toList(),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Colors.lightBlue,
          height: 1.0,
        ),
      ),
    );
  }

  Widget _buildAnimatedButton(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _navigateToPage(context, label),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, String label) {
    String route = '/${label.toLowerCase()}';
    Navigator.of(context).pushNamed(route);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to $label'),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0);
}
