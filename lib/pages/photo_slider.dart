import 'dart:async';
import 'package:flutter/material.dart';

class PromoSlider extends StatefulWidget {
  final List<String> images;
  final double height;
  final double borderRadius;
  final Duration interval;

  const PromoSlider({
    super.key,
    required this.images,
    this.height = 150,
    this.borderRadius = 18,
    this.interval = const Duration(seconds: 3),
  });

  @override
  State<PromoSlider> createState() => _PromoSliderState();
}

class _PromoSliderState extends State<PromoSlider> {
  late final PageController _controller;
  Timer? _timer;

  int _currentPage = 1000;

  @override
  void initState() {
    super.initState();

    _controller = PageController(initialPage: _currentPage);

    _timer = Timer.periodic(widget.interval, (_) {
      if (!_controller.hasClients) return;

      _currentPage++;
      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
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
    if (widget.images.isEmpty) return const SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: PageView.builder(
          controller: _controller,
          itemBuilder: (context, index) {
            final imageIndex = index % widget.images.length;

            return Image.asset(
              widget.images[imageIndex],
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}
