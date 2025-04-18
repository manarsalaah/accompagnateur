import 'package:flutter/material.dart';

class LoginErrorPopover extends StatefulWidget {
  final String message;
  final bool showError;
  final VoidCallback onClose;

  const LoginErrorPopover({
    Key? key,
    required this.message,
    required this.showError,
    required this.onClose,
  }) : super(key: key);

  @override
  _LoginErrorPopoverState createState() => _LoginErrorPopoverState();
}

class _LoginErrorPopoverState extends State<LoginErrorPopover> {
  Color _backgroundColor = Colors.transparent;
  Color _borderColor = Colors.transparent;
  Color _textColor = Colors.transparent;
  Color _iconColor = Colors.transparent;

  @override
  void didUpdateWidget(LoginErrorPopover oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showError) {
      _triggerErrorState();
    }
  }

  void _triggerErrorState() {
    setState(() {
      _backgroundColor = Colors.red.shade50;
      _borderColor = Colors.red.shade200;
      _textColor = Colors.red.shade700;
      _iconColor = Colors.red;
    });

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _backgroundColor = Colors.transparent;
        _borderColor = Colors.transparent;
        _textColor = Colors.transparent;
        _iconColor = Colors.transparent;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _borderColor,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.error_outline,
            color: _iconColor,
          ),
          SizedBox(width: 8),
          (widget.message.length>100)?
          Expanded(
            child: Text(
              widget.message.substring(0,100),
              style: TextStyle(
                color: _textColor,
              ),
            ),
          ):
          Expanded(
      child: Text(
        widget.message,
        style: TextStyle(
          color: _textColor,
        ),
      ),
    ),
          IconButton(
            icon: Icon(
              Icons.close,
              color: _textColor,
            ),
            onPressed: widget.onClose,
          ),
        ],
      ),
    );
  }
}
