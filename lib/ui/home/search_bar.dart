import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../constants/strings.dart';
import '../../provider/manager.dart';
import '../../widgets/search_bar_logo.dart';

class SearchAppBar extends StatefulWidget {
  final Function(String) onFieldSubmittedCallback;

  SearchAppBar(this.onFieldSubmittedCallback);

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  var firstOpen = true;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ManagerProvider manager = Provider.of<ManagerProvider>(context);
    _searchBarClick() {
      manager.searchBarFocusNode.requestFocus();
      manager.setState();
    }

    if (manager.showSearchBar)
      _animationController?.forward();
    else
      _animationController?.reverse();
    return AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          children: [
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              curve: Curves.fastLinearToSlowEaseIn,
              child: manager.showSearchBar
                  ? Container(
                      color: Colors.transparent,
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          manager.searchController.clear();
                          manager.searchRunning = false;
                          manager.setState();
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 18, top: 12, bottom: 12),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ),
            Expanded(
              child: Container(
                  margin: EdgeInsets.only(left: 18, right: 18),
                  height: kToolbarHeight * 0.9,
                  decoration: BoxDecoration(
                      color:
                          Theme.of(context).iconTheme.color?.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(100)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            FadeTransition(
                              opacity: Tween<double>(
                                begin: 0.0,
                                end: 1.0,
                              ).animate(CurvedAnimation(
                                  parent: _animationController!,
                                  curve: Curves.fastOutSlowIn,
                                  reverseCurve: Curves.fastOutSlowIn)),
                              child: _searchBarTextField(),
                            ),
                            FadeTransition(
                              opacity: Tween<double>(
                                begin: 1.0,
                                end: 0.0,
                              ).animate(CurvedAnimation(
                                  parent: _animationController!,
                                  curve: Curves.fastOutSlowIn,
                                  reverseCurve: Curves.easeInQuart)),
                              child: SlideTransition(
                                  position: Tween<Offset>(
                                          begin: Offset.zero,
                                          end: Offset(0.2, 0.0))
                                      .animate(CurvedAnimation(
                                          parent: _animationController!,
                                          curve: Curves.fastOutSlowIn,
                                          reverseCurve: Curves.easeInQuart)),
                                  child: SearchBarLogo(_searchBarClick)),
                            ),
                          ],
                        ),
                      ),
                      AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          child: manager.searchController.text.isNotEmpty &&
                                  manager.showSearchBar
                              ? IconButton(
                                  icon: Icon(EvaIcons.trashOutline,
                                      color: Theme.of(context)
                                          .iconTheme
                                          .color
                                          ?.withOpacity(0.6),
                                      size: 20),
                                  onPressed: () {
                                    manager.searchController.clear();
                                    setState(() {});
                                    manager.searchBarFocusNode.requestFocus();
                                  },
                                )
                              : Container()),
                      FutureBuilder<dynamic>(
                          future: _getClipboardData(),
                          builder: (context, dynamic id) {
                            return AnimatedSwitcher(
                                duration: Duration(milliseconds: 300),
                                child: id.data != null && true
                                    ? IconButton(
                                        icon: Icon(EvaIcons.link,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            size: 20),
                                        onPressed: () {},
                                      )
                                    : Container());
                          }),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: false
                            ? IconButton(
                                icon: Icon(EvaIcons.dropletOutline,
                                    color: Theme.of(context)
                                        .iconTheme
                                        .color
                                        ?.withOpacity(0.6)),
                                onPressed: () {
                                  showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15))),
                                      context: context,
                                      builder: (context) => Container());
                                },
                              )
                            : SizedBox(),
                      ),
                    ],
                  )),
            ),
          ],
        ));
  }

  Future<dynamic> _getClipboardData() async {
    String data = (await Clipboard.getData("text/plain"))?.text ?? "";
    if (data.isEmpty) {
      return null;
    }

    return null;
  }

  Widget _searchBarTextField() {
    ManagerProvider manager = Provider.of<ManagerProvider>(context);

    if (firstOpen)
      Future.delayed(Duration(milliseconds: 300), () {
        firstOpen = false;
        manager.searchBarFocusNode.requestFocus();
        manager.setState();
      });

    return Padding(
      padding: EdgeInsets.only(left: 12, right: 12),
      child: TextFormField(
        autocorrect: false,
        enableSuggestions: true,
        controller: manager.searchController,
        focusNode: manager.searchBarFocusNode,
        onTap: () {
          manager.searchBarFocusNode.requestFocus();
          manager.setState();
        },
        style: TextStyle(
            color:
                Theme.of(context).textTheme.bodyText1?.color?.withOpacity(0.6),
            fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Tìm kiếm',
          hintStyle: TextStyle(
            color:
                Theme.of(context).textTheme.bodyText1?.color?.withOpacity(0.6),
          ),
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
        ),
        onFieldSubmitted: (String query) {
          FocusScope.of(context).unfocus();
          manager.searchRunning = true;
          manager.setState();
          widget.onFieldSubmittedCallback(query);
        },
        onChanged: (_) {
          manager.setState();
        },
      ),
    );
  }

  Widget _searchBarLogo() {
    ManagerProvider manager = Provider.of<ManagerProvider>(context);
    return GestureDetector(
      onTap: () {
        manager.searchBarFocusNode.requestFocus();
        manager.setState();
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                DateTime.now().month == 12
                    ? 'assets/images/logo_christmas.png'
                    : 'assets/images/ic_launcher.png',
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
            Expanded(
              child: IgnorePointer(
                ignoring: true,
                child: Text(Strings.appName,
                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.color
                          ?.withOpacity(0.6),
                      fontFamily: 'Product Sans',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
