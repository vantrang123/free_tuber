import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../constants/strings.dart';
import '../../data/local/hive_service.dart';
import '../../di/components/service_locator.dart';
import '../../models/keyword_search.dart';
import '../../provider/manager.dart';
import '../../stores/video/video_store.dart';
import '../components/streams_large_thumbnail.dart';
import '../home/search_bar.dart';
import 'search_suggestion_list.dart';

class SearchScreen extends StatefulWidget {
  @override
  _Search createState() => _Search();
}

class _Search extends State<SearchScreen> {
  late VideoStore _videoStore;
  final HiveService hiveService = getIt<HiveService>();
  int _searchLimit = 40;

  @override
  void initState() {
    _videoStore = Provider.of<VideoStore>(context, listen: false);
    _videoStore.videoListSearch?.videos?.clear();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(),
          body: _buildBody(),
        )
    );
  }

  // app bar methods:-----------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    ManagerProvider manager = Provider.of<ManagerProvider>(context, listen: false);
    _onFieldSubmittedCallback(String query) {
      _handleKeySearchResponse(query, manager);
    }

    return PreferredSize(
        child: Padding(
          padding: EdgeInsets.only(top: 8),
          child: SearchAppBar(_onFieldSubmittedCallback),
        ),
        preferredSize: Size(double.infinity, kToolbarHeight));
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Stack(
        children: [
          Observer(builder: (context) {
            return StreamsLargeThumbnailView(
              infoItems: _videoStore.videoListSearch?.videos ?? [],
              onReachingListEnd: () {
                // todo load more video
              },
            );
          }),
          _buildSearchSuggestion()
        ],
      ),
    );
  }

  Widget _buildSearchSuggestion() {
    return Consumer<ManagerProvider>(builder: (context, manager, _) {
      return AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: manager.searchBarFocusNode.hasFocus
            ? Column(
                children: [
                  Container(
                    height: manager.showSearchBar ? 0 : 40,
                    color: Theme.of(context).cardColor,
                  ),
                  Expanded(
                      child: Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: SearchSuggestionList(
                            searchQuery: manager.searchController.text,
                            onItemTap: (String item) {
                              _handleKeySearchResponse(item, manager);
                            },
                          )))
                ],
              )
            : Container(),
      );
    });
  }

  _handleKeySearchResponse(String value, ManagerProvider manager) {
    manager.searchController.text = value;
    manager.searchRunning = true;
    // manager.searchBarFocusNode.unfocus();
    manager.youtubeSearchQuery = value;
    FocusScope.of(context).unfocus();
    manager.setState();
    // controller.animateTo(0);
    if (value.length > 1) {
      Future.delayed(
          Duration(milliseconds: 100),
          () => {
            _saveKeyWordSearch(value)
          });
      if (!_videoStore.loading) {
        _videoStore.getVideos(value, true);
      }
    }
  }

  _saveKeyWordSearch(String value) async {
    hiveService.updateBoxes<KeywordSearch>(KeywordSearch(keyword: value), Strings.keywordBoxName);
  }
}
