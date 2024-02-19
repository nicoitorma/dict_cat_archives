import 'package:flutter/material.dart';

class MunicipalityCard extends StatelessWidget {
  final String municipality;
  const MunicipalityCard({super.key, required this.municipality});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Center(child: Image.asset('assets/images/$municipality.jpg')),
    );
  }
}
