import 'package:flutter/material.dart';

class ErrorPopover extends StatelessWidget {
  final String message;
  final VoidCallback onClose;

  const ErrorPopover({
    Key? key,
    required this.message,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.red.shade200,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.red.shade700,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.red.shade700,
            ),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
