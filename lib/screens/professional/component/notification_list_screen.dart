import 'package:cached_network_image/cached_network_image.dart';
import 'package:film/bloc/professionalBloc/application_bloc.dart';
import 'package:film/bloc/professionalBloc/application_user_bloc.dart';
import 'package:film/bloc/professionalBloc/project_bloc.dart';
import 'package:film/core/load_more_listener.dart';
import 'package:film/models/application_list_response.dart';
import 'package:film/models/application_list_user.dart';
import 'package:film/models/notification_list_response.dart';
import 'package:film/models/project_list_response.dart';
import 'package:film/models/common.dart';
import 'package:film/network/apis.dart';
import 'package:film/utils/custom_loader/linear_loader.dart';
import 'package:film/widgets/common_api_loader.dart';
import 'package:film/widgets/common_api_result_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {


  const NotificationScreen({Key? key, }) : super(key: key);

  @override
  State<NotificationScreen> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with LoadMoreListener {
  late ApplicationUserBloc _bloc;
  late ScrollController _itemsScrollController;
  bool isLoadingMore = false;
  @override
  void initState() {
    _bloc = ApplicationUserBloc(listener: this);
    _bloc.getnotificationList( false);
    _itemsScrollController = ScrollController();
    _itemsScrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  refresh(bool isLoading) {
    if (mounted) {
      setState(() {
        isLoadingMore = isLoading;
      });
    }
  }

  paginate() async {
    await _bloc.getnotificationList( true);
  }

  void _scrollListener() async {
    if (_itemsScrollController.offset >=
        _itemsScrollController.position.maxScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      paginate();
    }
    if (_itemsScrollController.offset <=
        _itemsScrollController.position.minScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      // Reached the top
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text("Notifications"),
      ),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.cyan,
        onRefresh: () => _bloc.getnotificationList( false),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _itemsScrollController,
          child: Column(
            children: [
              SizedBox(height: 10),
              StreamBuilder<ApiResponse<NotificationListResponse>>(
                stream: _bloc.notificationListStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status!) {
                      case Status.LOADING:
                        return CommonApiLoader();
                      case Status.COMPLETED:
                        List<Notifications> notificationList = _bloc.notificationList;
                        return  (notificationList.isEmpty)
                            ? Center(child: CommonApiResultsEmptyWidget("No notifications found"))
                            : _buildApplicationList(_bloc.notificationList);
                      case Status.ERROR:
                        return SizedBox(
                          height: MediaQuery.of(context).size.height - 180,
                          child: CommonApiResultsEmptyWidget(
                            "${snapshot.data!.message!}",
                            textColorReceived: Colors.black,
                          ),
                        );
                    }
                  }
                  return SizedBox(
                    height: MediaQuery.of(context).size.height - 180,
                    child: CommonApiLoader(),
                  );
                },
              ),
              if (isLoadingMore) LinearLoader(),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApplicationList(List<Notifications> projectList) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: projectList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white60, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    isThreeLine: true,
                    title: Text(
                      "${projectList[index].data!.message}",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text("${projectList[index].data!.status}"),
                  ),
                  Align(
                      alignment: AlignmentDirectional.bottomEnd,
                      child: Text("${projectList[index].createdAt}")),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
