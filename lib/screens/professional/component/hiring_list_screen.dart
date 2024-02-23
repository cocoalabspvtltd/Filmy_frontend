import 'package:cached_network_image/cached_network_image.dart';
import 'package:film/bloc/professionalBloc/hiring_bloc.dart';
import 'package:film/bloc/professionalBloc/project_bloc.dart';
import 'package:film/core/load_more_listener.dart';
import 'package:film/models/hiring_list_response.dart';
import 'package:film/models/project_list_response.dart';
import 'package:film/models/common.dart';
import 'package:film/screens/professional/hiring/edit_hiring_screen.dart';
import 'package:film/screens/professional/p_home_screen.dart';
import 'package:film/screens/professional/projects/edit_project_screen.dart';
import 'package:film/utils/custom_loader/linear_loader.dart';
import 'package:film/widgets/common_api_loader.dart';
import 'package:film/widgets/common_api_result_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HiringListScreen extends StatefulWidget {
  const HiringListScreen({Key? key}) : super(key: key);

  @override
  State<HiringListScreen> createState() => _HiringListScreenState();
}

class _HiringListScreenState extends State<HiringListScreen>
    with LoadMoreListener {
  late HiringBloc _bloc;
  late ScrollController _itemsScrollController;
  bool isLoadingMore = false;
  List<Hirings> filteredHiringList = [];

  @override
  void initState() {
    _bloc = HiringBloc(listener: this);
    _bloc.gethiringList(false);
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
    await _bloc.gethiringList(true);
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

  void filterHringList(String query) {
    setState(() {
      filteredHiringList = _bloc.hiringList
          .where((hiring) =>
      hiring.title!.toLowerCase().contains(query.toLowerCase()) ||
          hiring.experience!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.cyan,
        onRefresh: () => _bloc.gethiringList(false),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _itemsScrollController,
          child: Column(
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 12,right: 12,top: 12,),
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
                    filterHringList(value);
                  },
                ),
              ),
              StreamBuilder<ApiResponse<HiringListResponse>>(
                stream: _bloc.hiringListStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status!) {
                      case Status.LOADING:
                        return CommonApiLoader();
                      case Status.COMPLETED:
                        List<Hirings> hiringList = _bloc.hiringList;
                        return (hiringList.isEmpty) ||
                            (filteredHiringList.isEmpty && searchController.text.isNotEmpty)
                            ? CommonApiResultsEmptyWidget("No hiring found")
                            : _buildProjectList(filteredHiringList.isNotEmpty
                            ? filteredHiringList
                            : _bloc.hiringList);
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

  Widget _buildProjectList(List<Hirings> hiringList) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: hiringList.length,
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
                    GestureDetector(
                      onTap: () {
                        // Handle image tap here
                      },
                      child: ListTile(
                        isThreeLine: true,
                        trailing: Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                _showDeleteConfirmationDialog(
                                    context, hiringList[index].id.toString());
                              },
                              child: Icon(Icons.delete_outline, color: Colors.red[800]),
                            ),
                            SizedBox(height: 6),
                            GestureDetector(
                              onTap: () async {
                               Get.to(EditHiringScreen(details: hiringList[index],));
                              },
                              child: Icon(Icons.edit, color: Colors.cyan),
                            ),
                          ],
                        ),
                        title: Text(
                          "${hiringList[index].title}",
                          style: const TextStyle(fontWeight: FontWeight.w500,color: Colors.cyan,fontSize: 22),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.assessment, color: Colors.blue),
                                SizedBox(width: 6),
                                Text(
                                  "Skills: ${hiringList[index].skillNames!.join(', ')}",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.work_outline, color: Colors.green),
                                SizedBox(width: 6),
                                Text(
                                  "Experience: ${hiringList[index].experience != null ? hiringList[index].experience : 'Not specified'}",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.person, color: Colors.orange),
                                SizedBox(width: 6),
                                Text(
                                  "Openings: ${hiringList[index].openings}",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.check_circle_outline, color: Colors.green),
                                SizedBox(width: 6),
                                Text(
                                  "Status: ${hiringList[index].status}",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.payment, color: Colors.deepPurple),
                                SizedBox(width: 6),
                                Text(
                                  "Pay: ${hiringList[index].pay}",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
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

  void _showDeleteConfirmationDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await _bloc.deleteHiring(id);
                await Future.delayed(Duration(seconds: 2));
               // _bloc.getprojectList(false);
                Get.to(() => PHomeScreen(selectedIndex: 3,));
                Navigator.of(context).pop();
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.cyan)),
            ),
          ],
        );
      },
    );
  }
}
