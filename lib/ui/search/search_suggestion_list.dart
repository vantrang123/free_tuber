import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants/strings.dart';
import '../../data/local/hive_service.dart';
import '../../di/components/service_locator.dart';
import '../../models/keyword_search.dart';

class SearchSuggestionList extends StatefulWidget {
  final Function(String) onItemTap;
  final String searchQuery;

  SearchSuggestionList({required this.onItemTap, this.searchQuery = ""});

  @override
  _SearchSuggestionListState createState() => _SearchSuggestionListState();
}

class _SearchSuggestionListState extends State<SearchSuggestionList> {
  late http.Client client;
  final HiveService hiveService = getIt<HiveService>();
  List<String> _historySearch = [];

  @override
  void initState() {
    client = http.Client();
    _getHistorySearch();
    super.initState();
  }

  @override
  void dispose() {
    client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _suggestionSearch();
  }

  _getHistorySearch() async {
    _historySearch.clear();
    final listKeywordSearch = await hiveService.getBoxes<KeywordSearch>(Strings.keywordBoxName);
    for (int i = listKeywordSearch.length -1; i >= 0; i--) {
      _historySearch.add(listKeywordSearch[i].keyword);
    }
    setState(() {

    });
  }

  Widget _suggestionSearch() {
    List<String> suggestionsList = [];
    List<String> finalList = [];
    return FutureBuilder(
      future: widget.searchQuery != ""
          ? client.get(
          Uri.parse(
              'http://suggestqueries.google.com/complete/search?client=firefox&q=${widget.searchQuery}'),
          headers: {
            'user-agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
                '(KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36',
            'accept-language': 'en-US,en;q=1.0',
          })
          : null,
      builder: (context, AsyncSnapshot<http.Response> suggestions) {
        suggestionsList.clear();
        if (suggestions.hasData && widget.searchQuery != "") {
          var map = jsonDecode(suggestions.data!.body);
          var mapList = map[1];
          mapList.forEach((result) {
            suggestionsList.add(result);
          });
        }
        finalList = suggestionsList + _historySearch;
        return ListView.builder(
          itemExtent: 40,
          itemCount: finalList.length,
          itemBuilder: (context, index) {
            String item = finalList[index];
            return ListTile(
              title: Text(
                "$item",
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                    fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
              leading: SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                    suggestionsList.contains(item)
                        ? Icons.search
                        : Icons.history_outlined,
                    color: Theme.of(context).iconTheme.color),
              ),
              trailing: !suggestionsList.contains(item)
                  ? IconButton(icon: Icon(Icons.clear, size: 20), onPressed: () {
                    hiveService.deleteItem<KeywordSearch>(finalList.length -_historySearch.length + _historySearch.length - index - 1, Strings.keywordBoxName);
                    _getHistorySearch();
              },)
                  : null,
              onTap: () => widget.onItemTap(item),
            );
          },
        );
      },
    );
  }
}
