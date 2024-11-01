import 'package:covid_19_tracker/Model/dropdown_model.dart';
import 'package:flutter/material.dart';

import '../Utils/state_services.dart';

class DropDownView extends StatefulWidget {
  const DropDownView({super.key});
  @override
  State<DropDownView> createState() => _DropDownViewState();
}

class _DropDownViewState extends State<DropDownView> {
  final StateServices _state = StateServices();
  dynamic _selectedValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder<List<DropDownModel>>(
              future: _state.getDropDownApi(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DropdownButton(
                      value: _selectedValue,
                      hint: const Text('Select Value'),
                      items: snapshot.data!.map((e) {
                        return DropdownMenuItem(
                            value: e.id, child: Text(e.id.toString()));
                      }).toList(),
                      onChanged: (value) {
                        _selectedValue = value;
                        setState(() {});
                      });
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              })
        ],
      ),
    );
  }
}
