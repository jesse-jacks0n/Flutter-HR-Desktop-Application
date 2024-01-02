import 'package:flutter/material.dart';

class RepositoryTab extends StatefulWidget {
  const RepositoryTab({super.key});

  @override
  State<RepositoryTab> createState() => _RepositoryTabState();
}

class _RepositoryTabState extends State<RepositoryTab> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("No Files"),
    );
  }
}

