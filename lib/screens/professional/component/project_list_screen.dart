import 'package:cached_network_image/cached_network_image.dart';
import 'package:film/bloc/professionalBloc/project_bloc.dart';
import 'package:film/core/load_more_listener.dart';
import 'package:film/models/project_list_response.dart';
import 'package:film/models/common.dart';
import 'package:film/screens/professional/hiring/create_hiring_screen.dart';
import 'package:film/screens/professional/p_home_screen.dart';
import 'package:film/screens/professional/projects/edit_project_screen.dart';
import 'package:film/utils/custom_loader/linear_loader.dart';
import 'package:film/widgets/common_api_loader.dart';
import 'package:film/widgets/common_api_result_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({Key? key}) : super(key: key);

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen>
    with LoadMoreListener {
  late ProjectBloc _bloc;
  late ScrollController _itemsScrollController;
  bool isLoadingMore = false;
  List<Projects> filteredProjectList = [];

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
    await _bloc.getprojectList(true);
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
      filteredProjectList = _bloc.projectList
          .where((project) =>
      project.projectName!.toLowerCase().contains(query.toLowerCase()) ||
          project.type!.toLowerCase().contains(query.toLowerCase()) ||
          ( project.director != null &&
              project.director!.toLowerCase().contains(query.toLowerCase())))
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
        onRefresh: () => _bloc.getprojectList(false),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _itemsScrollController,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 12,right: 12,top: 12,),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search, color: Colors.cyan),
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.cyan),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.cyan,
                    fontSize: 16.0,
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
                        List<Projects> projectList = _bloc.projectList;
                        return (projectList.isEmpty) ||
                            (filteredProjectList.isEmpty && searchController.text.isNotEmpty)
                            ? CommonApiResultsEmptyWidget("No Projects found")
                            : _buildProjectList(filteredProjectList.isNotEmpty
                            ? filteredProjectList
                            : _bloc.projectList);
                      case Status.ERROR:
                        return SizedBox(
                          height: MediaQuery.of(context).size.height - 180,
                          child: CommonApiResultsEmptyWidget(
                            snapshot.data!.message!,
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
              const SizedBox(
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
        physics: const NeverScrollableScrollPhysics(),
        itemCount: projectList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Card(
              elevation: 0,
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.white60, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: Text(
                        "${projectList[index].createdAt}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Handle image tap here
                      },
                      child: ListTile(
                        isThreeLine: true,
                        leading: Container(
                          width: MediaQuery.of(context).size.width * .25,
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: projectList[index].posterUrl!,
                              placeholder: (context, url) =>
                                  const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Container(
                                margin: EdgeInsets.all(5),
                                child: Image.asset(
                                  "assets/image/no-post.png",
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                        trailing: Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                _showDeleteConfirmationDialog(
                                    context, projectList[index].id.toString());
                              },
                              child: Icon(Icons.delete_outline, color: Colors.red[800]),
                            ),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: () async {
                                Get.to(EditProjectScreen(details: projectList[index]));
                              },
                              child: Icon(Icons.edit, color: Colors.cyan),
                            ),
                          ],
                        ),
                        title: Text(
                          "${projectList[index].projectName}",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${projectList[index].type}",
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            if (projectList[index].director != null)
                              Text(
                                "Director : ${projectList[index].director}",
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            if (projectList[index].duration != null)
                              Text(
                                "Duration : ${projectList[index].duration}",
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            Container(
                              height: 60, // Adjust the height as needed
                              child: SingleChildScrollView(
                                child: Text(
                                  "Description: ${projectList[index].description}",
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6,),
                            Align(alignment: AlignmentDirectional.bottomEnd,
                                child: SizedBox(
                                  height: 22,
                                  width: 100,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Get.to(CreateHiringScreen(ProjectId:projectList[index].id.toString()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.black,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Add Hiring",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            )
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
                await _bloc.deleteProject(id);
                await Future.delayed(Duration(seconds: 2));
                _bloc.getprojectList(false);
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
