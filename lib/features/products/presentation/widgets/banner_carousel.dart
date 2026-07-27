import 'dart:async';
import 'package:flutter/material.dart';

class _BannerContent {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color background;
  final Color foreground;

  const _BannerContent({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.background,
    required this.foreground,
  });
}

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final _controller = PageController();

  static final List<_BannerContent> _banners = [
    _BannerContent(
      icon: Icons.checkroom,
      title: 'New Season Arrivals',
      subtitle: 'Fresh clothing styles, just dropped',
      background: const Color(0xFFF2F0F5),
      foreground: const Color(0xFF6B5B95),
    ),
    _BannerContent(
      icon: Icons.watch,
      title: 'Accessorize Your Look',
      subtitle: 'Watches, jewelry & more',
      background: const Color(0xFFF5F0F7),
      foreground: const Color.fromARGB(255, 124, 149, 224),
    ),
    _BannerContent(
      icon: Icons.shopping_bag_outlined,
      title: 'Bags On Sale',
      subtitle: 'Up to 30% off select styles',
      background: const Color(0xFFF3F3F5),
      foreground: const Color(0xFF6E6E80),
    ),
  ];

  int get _bannerCount => _banners.length;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      _currentPage = (_currentPage + 1) % _bannerCount;
      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _controller,
            itemCount: _bannerCount,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: banner.background,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: banner.foreground.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        banner.icon,
                        size: 32,
                        color: banner.foreground,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            banner.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: banner.foreground,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            banner.subtitle,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: banner.foreground.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _bannerCount,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == index ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: _currentPage == index
                    ? const Color(0xFF6B5B95)
                    : const Color(0xFFE0DEE6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
