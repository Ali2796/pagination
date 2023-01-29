import 'dart:convert';
import 'dart:io';

import 'package:api_pagination/repositery/api_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'data_model.dart';

class ApiClientEntries extends ChangeNotifier {
  int page = 0;
  final int limit = 20;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  List<DataModelEntity> _posts = [];

  List<DataModelEntity> get posts => _posts;

  bool get hasNextPage => _hasNextPage;

  bool get isFirstLoadRunning => _isFirstLoadRunning;

  bool get isLoadMoreRunning => _isLoadMoreRunning;

  Future<void> firstLoad() async {
    _isFirstLoadRunning = true;
    _posts = await getEntries(page: page, limit: limit);

    _isFirstLoadRunning = false;

    notifyListeners();
  }

/////////////////////////////////////////////////////////////////////////////////

  Future<void> loadMore({required ScrollController controller}) async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        controller.position.extentAfter < 300) {
      if (controller.position.extentAfter < 300) {
        _isLoadMoreRunning = true;
        print('...................Extent.............');
      }
      page += 1;
      try {
        var res = await getEntries(page: page, limit: limit);
        if (res.isNotEmpty) {
          posts.addAll(res);
          //posts = res;
        } else {
          _hasNextPage = false;
        }
        _isLoadMoreRunning = false;
      } catch (e) {
        print('................error.............${e.toString()}');
      }
    }
  }

  Future<List<DataModelEntity>> getEntries(
      {required int page, required int limit}) async {
    var url = '${ApiUrl.baseUrl}${ApiUrl.getPosts}?_page=$page&_limit=$limit';

    print('$url/////////////////url');

    List<DataModelEntity> listOfPosts = [];

    try {
      Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print('${response.statusCode}');
        var listOfMaps = jsonDecode(response.body);

        listOfPosts = listOfMaps.map<DataModelEntity>((map) {
          return DataModelEntity.fromJson(map);
        }).toList();
        print('$listOfPosts///////////////////post.........');
      }
    } on HttpException {
      print('HttpException');
    } catch (e) {
      print('catch////// ${e.toString()}');
    }
    // notifyListeners();
    return listOfPosts;
  }
}
