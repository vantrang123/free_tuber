import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../constants/colors.dart';
import '../../di/components/service_locator.dart';
import '../../events/audio_listening.dart';
import '../../events/my_event_bus.dart';
import '../../provider/home_tab.dart';
import '../../utils/routes/routes.dart';
import '../../widgets/collapsed_panel.dart';
import '../../widgets/search_bar_logo.dart';
import 'page/home_page_all.dart';
import 'page/home_page_another.dart';
import 'page/home_page_entertainment.dart';
import 'page/home_page_movies.dart';
import 'page/home_page_music.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // late VideoTrendingStore _videoTrendingStore;
  late TabController _tabController;

  @override
  void initState() {
    HomeTabProvider tabProvider = Provider.of<HomeTabProvider>(context, listen: false);
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      int tabIndex = _tabController.index;
      if (tabIndex == 0) {
        tabProvider.currentHomeTab = HomeScreenTab.All;
      } else if (tabIndex == 1) {
        tabProvider.currentHomeTab = HomeScreenTab.Music;
      } else if (tabIndex == 2) {
        tabProvider.currentHomeTab = HomeScreenTab.Entertainment;
      } else if (tabIndex == 3) {
        tabProvider.currentHomeTab = HomeScreenTab.Sport;
      } else if (tabIndex == 4) {
        tabProvider.currentHomeTab = HomeScreenTab.Game;
      }
    });

    // _videoTrendingStore = Provider.of<VideoTrendingStore>(context, listen: false);
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Future<void> _init() async {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
  }

  // app bar methods:-----------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    _searchBarClick() {
      Navigator.pushNamed(context, Routes.search);
    }

    return PreferredSize(
        child: Padding(
          padding: EdgeInsets.only(top: 8),
          child: AppBar(
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Container(
              margin: EdgeInsets.only(left: 18, right: 18),
              height: kToolbarHeight * 0.9,
              decoration: BoxDecoration(
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(100)),
              child: SearchBarLogo(_searchBarClick),
            ),
          ),
        ),
        preferredSize: Size(double.infinity, kToolbarHeight));
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Stack(
      children: [
        Column(children: [
          _buildTabBar(),
          Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[600]!.withOpacity(0.1),
              indent: 12,
              endIndent: 12),
          Expanded(child: TabBarView(
              controller: _tabController,
              children: [
                HomePageAll(),
                HomePageMusic(),
                HomePageEntertainment(),
                HomePageSports(),
                HomePageAnother()
              ])
          ),
          VideoPageCollapsed()
        ])
      ],
    );
  }

  Widget _buildTabBar() {
    HomeTabProvider tabProvider = Provider.of<HomeTabProvider>(context, listen: false);
    return AnimatedSize(
      duration: Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      child: Container(
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              TabBar(
                indicatorPadding: EdgeInsets.only(bottom: 5),
                physics: BouncingScrollPhysics(),
                isScrollable: true,
                controller: _tabController,
                onTap: (int tabIndex) {
                  if (tabIndex == 0) {
                    // tabProvider.currentHomeTab = HomeScreenTab.Trending;
                  } else if (tabIndex == 1) {
                    // tabProvider.currentHomeTab = HomeScreenTab.Favorites;
                  } else if (tabIndex == 2) {
                    // tabProvider.currentHomeTab = HomeScreenTab.WatchLater;
                  } else if (tabIndex == 3) {
                    // tabProvider.currentHomeTab = HomeScreenTab.WatchLater;
                  }
                },
                labelStyle: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Product Sans',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3),
                unselectedLabelStyle: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Product Sans',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2),
                labelColor: Theme.of(context).colorScheme.secondary,
                unselectedLabelColor: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .color!
                    .withOpacity(0.4),
                indicator: MaterialIndicator(
                    height: 3,
                    topLeftRadius: 0,
                    topRightRadius: 0,
                    bottomLeftRadius: 5,
                    bottomRightRadius: 5,
                    horizontalPadding: 20,
                    tabPosition: TabPosition.bottom,
                    color: AppColors.accentColor[500]!),
                tabs: [
                  Tab(text: "All"),
                  Tab(text: "Music"),
                  Tab(text: "Entertainment"),
                  Tab(text: "Sports"),
                  Tab(text: "Gaming")
                ],
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
          )),
    );
  }
}
