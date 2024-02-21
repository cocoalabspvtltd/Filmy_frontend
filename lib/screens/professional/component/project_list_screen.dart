import 'package:cached_network_image/cached_network_image.dart';
import 'package:film/bloc/professionalBloc/project_bloc.dart';
import 'package:film/core/load_more_listener.dart';
import 'package:film/models/project_list_response.dart';
import 'package:film/models/common.dart';
import 'package:film/utils/custom_loader/linear_loader.dart';
import 'package:film/widgets/common_api_loader.dart';
import 'package:film/widgets/common_api_result_empty_widget.dart';
import 'package:flutter/material.dart';


class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({Key? key}) : super(key: key);

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> with LoadMoreListener{

  late ProjectBloc _bloc;
  late ScrollController _itemsScrollController;
  bool isLoadingMore = false;
  List<Projects> filteredProjectist = [];
  @override
  void initState() {
    _bloc = ProjectBloc(listener: this);
    _bloc.getprojectList(false);
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
    print('paginate');
    await _bloc.getprojectList(true);
  }

  void _scrollListener() async {
    if (_itemsScrollController.offset >=
        _itemsScrollController.position.maxScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      print("reach the bottom");
      paginate();
    }
    if (_itemsScrollController.offset <=
        _itemsScrollController.position.minScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      print("reach the top");
    }
  }
  void filterProjectList(String query) {
    setState(() {
      filteredProjectist = _bloc.projectList
          .where((project) =>
      project.projectName!.toLowerCase().contains(query.toLowerCase()) ||
          project.type!.toLowerCase().contains(query.toLowerCase()) ||
          project.director!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  TextEditingController searchController = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.cyan,
        onRefresh: () {
          return _bloc.getprojectList(false);
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _itemsScrollController,
          child: Column(
            children: [
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search,color: Colors.cyan,),
                    contentPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.cyan), // Set active border color
                    ),
                  ),
                  style: TextStyle( // Set style for entered text
                    color: Colors.cyan, // Change the text color
                    fontSize: 16.0, // Adjust the font size
                  ),
                  onChanged: (value) {
                    filterProjectList(value);
                  },
                ),
              ),
              StreamBuilder<ApiResponse<ProjectListResponse>>(
                  stream: _bloc.projectListStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.status!) {
                        case Status.LOADING:
                          return CommonApiLoader();
                        case Status.COMPLETED:
                          // ProjectListResponse resp = snapshot.data!.data;
                          List<Projects> ProjectList = _bloc.projectList;
                          return (ProjectList.isEmpty) ||
                              (filteredProjectist.isEmpty && searchController.text.isNotEmpty)
                              ? CommonApiResultsEmptyWidget("No records found")
                              : _buildProjectList(filteredProjectist.isNotEmpty
                              ? filteredProjectist
                              : _bloc.projectList);
                        case Status.ERROR:
                          return SizedBox(
                            height: MediaQuery.of(context).size.height - 180,
                            child: CommonApiResultsEmptyWidget(
                                "${snapshot.data!.message!}",
                                textColorReceived: Colors.black),
                          );
                      }
                    }
                    return SizedBox(
                        height: MediaQuery.of(context).size.height - 180, child: CommonApiLoader());
                  }),
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
  Widget _buildProjectList(List<Projects> projectList) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount:projectList.length, // Replace with the actual number of colleges
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              tileColor: Colors.grey[200],
              contentPadding: EdgeInsets.all(10),
              leading: Container(
                height: 60,
                width: 60,
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl:
                    '${projectList[index].posterUrl}',
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/dp.png'),
                        // height: 60,
                        // width: 60,
                      ),
                    ),
                  ),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${projectList[index].projectName} ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.cyan,
                        ),
                        child: Text("Edit"),
                      ),
                      SizedBox(width: 10,),
                      ElevatedButton(
                        onPressed: () async {
                          _showDeleteConfirmationDialog(context,projectList[index].id.toString());
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        ),
                        child: Text("Delete"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context,String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async{
                // await _bloc.deleteCommittee(id);
                // await Future.delayed(Duration(seconds: 2));
                // _bloc.getCommitteeList(false);
                // Navigator.of(context).pop();
              },
              child: Text('Delete',style: TextStyle(color: Colors.red),),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel',style: TextStyle(color: Colors.cyan),),
            ),
          ],
        );
      },
    );
  }
}
