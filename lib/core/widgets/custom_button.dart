import 'package:flutter/material.dart';

// 2. Enhanced Custom Button
class CustomButton extends StatefulWidget {
  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback? onPressed;
  final EdgeInsets padding;
  final double borderRadius;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final double? width;
  final double height;

  const CustomButton({
    Key? key,
    required this.text,
    required this.color,
    this.textColor = Colors.white,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    this.borderRadius = 16,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.width,
    this.height = 56,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.isDisabled || widget.isLoading;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: isDisabled ? null : (_) {
              setState(() => _isPressed = true);
              _controller.forward();
            },
            onTapUp: isDisabled ? null : (_) {
              setState(() => _isPressed = false);
              _controller.reverse();
              if (widget.onPressed != null) {
                widget.onPressed!();
              }
            },
            onTapCancel: isDisabled ? null : () {
              setState(() => _isPressed = false);
              _controller.reverse();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.width,
              height: widget.height,
              padding: widget.padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                gradient: isDisabled
                    ? LinearGradient(
                  colors: [Colors.grey.shade300, Colors.grey.shade300],
                )
                    : LinearGradient(
                  colors: [
                    widget.color,
                    widget.color.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: isDisabled ? [] : [
                  BoxShadow(
                    color: widget.color.withOpacity(0.3),
                    blurRadius: _isPressed ? 8 : 16,
                    offset: Offset(0, _isPressed ? 2 : 8),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Center(
                child: widget.isLoading
                    ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: widget.textColor,
                    strokeWidth: 2.5,
                  ),
                )
                    : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        color: isDisabled ? Colors.grey.shade600 : widget.textColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.text,
                      style: TextStyle(
                        color: isDisabled ? Colors.grey.shade600 : widget.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}