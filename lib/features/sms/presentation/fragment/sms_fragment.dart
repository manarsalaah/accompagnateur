import 'package:flutter/material.dart';

class SmsFragment extends StatefulWidget {
  const SmsFragment({super.key});

  @override
  State<SmsFragment> createState() => _SmsFragmentState();
}

class _SmsFragmentState extends State<SmsFragment> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("SMS"),
    );
  }
}
