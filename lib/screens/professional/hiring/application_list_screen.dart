import 'package:cached_network_image/cached_network_image.dart';
import 'package:film/bloc/professionalBloc/application_bloc.dart';
import 'package:film/bloc/professionalBloc/project_bloc.dart';
import 'package:film/core/load_more_listener.dart';
import 'package:film/models/application_list_response.dart';
import 'package:film/models/project_list_response.dart';
import 'package:film/models/common.dart';
import 'package:film/network/apis.dart';
import 'package:film/utils/custom_loader/linear_loader.dart';
import 'package:film/widgets/common_api_loader.dart';
import 'package:film/widgets/common_api_result_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApplicationListScreen extends StatefulWidget {
  final String id;

  const ApplicationListScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<ApplicationListScreen> createState() =>
      _ApplicationListScreenState();
}

class _ApplicationListScreenState extends State<ApplicationListScreen>
    with LoadMoreListener {
  late ApplicationBloc _bloc;
  late ScrollController _itemsScrollController;
  bool isLoadingMore = false;
  List<Applications> filteredProjectList = [];

  @override
  void initState() {
    _bloc = ApplicationBloc(listener: this);
    _bloc.getapplicationList(widget.id, false);
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
    await _bloc.getapplicationList(widget.id, true);
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

  void filterProjectList(String query) {
    setState(() {
      filteredProjectList = _bloc.applicationList
          .where((application) =>
      application.name!.toLowerCase().contains(query.toLowerCase()) ||
          application.phone!.toLowerCase().contains(query.toLowerCase()) ||
          (application.email != null &&
              application.email!.toLowerCase().contains(query.toLowerCase())))
          .toList();
    });
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text("Applications"),
      ),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.cyan,
        onRefresh: () => _bloc.getapplicationList(widget.id, false),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _itemsScrollController,
          child: Column(
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search, color: Colors.cyan),
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 16.0,
                  ),
                  onChanged: (value) {
                    print("njn${value}");
                    filterProjectList(value);
                  },
                ),
              ),
              StreamBuilder<ApiResponse<ApplicationListResponse>>(
                stream: _bloc.applicaionListStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status!) {
                      case Status.LOADING:
                        return CommonApiLoader();
                      case Status.COMPLETED:
                        List<Applications> projectList = _bloc.applicationList;
                        return (projectList.isEmpty) ||
                            (filteredProjectList.isEmpty &&
                                searchController.text.isNotEmpty)
                            ? CommonApiResultsEmptyWidget(
                            "No Applications found")
                            : _buildApplicationList(filteredProjectList.isNotEmpty
                            ? filteredProjectList
                            : _bloc.applicationList);
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

  Widget _buildApplicationList(List<Applications> projectList) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: projectList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white60, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    ListTile(
                      isThreeLine: true,
                        leading: CircleAvatar(
                          backgroundColor: projectList[index].userImage == null
                              ? Colors.white // Change background color when userImage is null
                              : null,
                          backgroundImage: projectList[index].userImage != null
                              ? CachedNetworkImageProvider(
                            '${Apis.storageUrl}${projectList[index].userImage}',
                          ) as ImageProvider<Object>
                              : AssetImage('assets/image/person.png'),
                        ),
                      title: Text(
                        "${projectList[index].name!.toUpperCase()}",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Phone : ${projectList[index].phone}",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          if (projectList[index].email != null)
                            Text(
                              "Email : ${projectList[index].email}",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          if (projectList[index].comments != null)
                            Text(
                              "Comments : ${projectList[index].comments}",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          SizedBox(height: 6,),
                          if (projectList[index].status == "accepted")
                            Text(
                              "${projectList[index].status!.toUpperCase()}",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          if (projectList[index].status == "rejected")
                            Text(
                              "${projectList[index].status!.toUpperCase()}",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          if (projectList[index].status == "pending")
                            Text(
                              "${projectList[index].status!.toUpperCase()}",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          SizedBox(
                            height: 6,
                          ),
                          if(projectList[index].status == "pending")
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () async{
                                  await _bloc.acceptOrRejectApplication(
                                      'accepted', projectList[index].applicationId.toString());
                                  await Future.delayed(Duration(seconds: 2));
                                  _bloc.getapplicationList(widget.id, false);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                ),
                                child: Text("Accept"),
                              ),
                              SizedBox(width: 10), // Adding space between buttons
                              ElevatedButton(
                                onPressed: () async{
                                  await _bloc.acceptOrRejectApplication(
                                      'rejected', projectList[index].applicationId.toString());
                                  await Future.delayed(Duration(seconds: 2));
                                  _bloc.getapplicationList(widget.id, false);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                ),

                                child: Text("Reject"),
                              ),
                            ],
                          ),
                          if(projectList[index].status == "accepted")
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () async{
                                    await _bloc.acceptOrRejectApplication(
                                        'rejected', projectList[index].applicationId.toString());
                                    await Future.delayed(Duration(seconds: 2));
                                    _bloc.getapplicationList(widget.id, false);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                  ),

                                  child: Text("Reject"),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
