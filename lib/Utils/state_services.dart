import 'dart:convert';
import 'dart:io';

import 'package:covid_19_tracker/Model/all_model.dart';
import 'package:covid_19_tracker/Model/dropdown_model.dart';
import 'package:covid_19_tracker/Utils/app_urls.dart';
import 'package:http/http.dart' as http;

class StateServices {
  Future<AllModel> fetchWorld() async {
    final response = await http.get(Uri.parse(AppUrls.worldStateApi));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return AllModel.fromJson(data);
    } else {
      throw Exception('Error');
    }
  }

  Future<List<dynamic>> countryList() async {
    dynamic data;
    final response = await http.get(Uri.parse(AppUrls.countriesList));
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Error');
    }
  }

  Future<List<DropDownModel>> getDropDownApi() async {
    try {
      final response = await http.get(Uri.parse(AppUrls.dropDownApi));
      final body = json.decode(response.body) as List;
      if (response.statusCode == 200) {
        return body.map((e) {
          final map = e as Map<String, dynamic>;
          return DropDownModel(
              userId: map['userId'],
              id: map['id'],
              title: map['title'],
              body: map['body']);
        }).toList();
      }
    } on SocketException {
      throw Exception('No Internet');
    }
    throw Exception('Error Fetching the Data');
  }
}
