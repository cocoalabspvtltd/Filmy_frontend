import 'package:carousel_slider/carousel_slider.dart';
import 'package:film/screens/professional/hiring/apply_hiring_screen.dart';
import 'package:film/screens/professional/p_home_screen.dart';
import 'package:film/screens/professional/projects/create_project_screen.dart';
import 'package:film/screens/professional/hiring/create_hiring_screen.dart';
import 'package:film/utils/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../bloc/authBloc/auth.dart';
import '../../../utils/api_helper.dart';
import '../../../widgets/common_api_result_empty_widget.dart';
import 'package:film/core/load_more_listener.dart';
import 'package:film/models/hiring.dart';
import 'package:film/models/common.dart';
import 'package:film/utils/custom_loader/linear_loader.dart';
import 'package:film/widgets/common_api_loader.dart';
import '../../../bloc/professionalBloc/homehiring.dart';
import '../../PROFILE/PROFILESCREEN.dart';

class ProfessionalHome extends StatefulWidget {
  const ProfessionalHome({Key? key}) : super(key: key);

  @override
  State<ProfessionalHome> createState() => _ProfessionalHomeScreenState();
}

class _ProfessionalHomeScreenState extends State<ProfessionalHome>
    with LoadMoreListener {
  late HiringHomeBloc _bloc;
  late ScrollController _itemsScrollController;
  bool isLoadingMore = false;
  List<UserHirings> filteredHiringList = [];
  final List<String> images = [
    'assets/image/image1.jpg', // Change the paths to match your actual asset paths
    'assets/image/image2.jpg',
    'assets/image/iamge3.jpg',
  ];

  dynamic ? prepaidCardUserOrNot;
  String ?Message ="";
  String? statuscheck ;
  AuthBloc _userprofilecheckBloc = AuthBloc();

  getProfileUserOrNot() async {
    prepaidCardUserOrNot = await _userprofilecheckBloc.userprofilecheck();
    Message = prepaidCardUserOrNot["status"];
    print("mes-?${Message}");
    statuscheck= prepaidCardUserOrNot["success"];
    if ( Message == "active") {
      Get.back();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Profile Inactive'),
            content: Text('Your profile is inactive. Please contact support for assistance.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Get.offAll(()=>PHomeScreen(selectedIndex: 2));
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
    setState(() {});
  }
  @override
  void initState() {
    getProfileUserOrNot();
    _bloc = HiringHomeBloc(listener: this);
    _bloc.gethiringapplicList(false);
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
    await _bloc.gethiringapplicList(true);
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

  void filterHiringList(String query) {
    setState(() {
      filteredHiringList = _bloc.hiringList
          .where((hiring) =>
          hiring.title!.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.cyan,
        onRefresh: () => _bloc.gethiringapplicList(false),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _itemsScrollController,
          child: Column(
            children: [
SizedBox(height: 20,),
              User_Details.userRole =="professional"? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const CreateProjectScreen());
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width * 0.36,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(13.0),
                              bottomRight: Radius.circular(13.0))),
                      child: Column(
                        children: [
                          SizedBox(
                            height: (MediaQuery.of(context).size.width * 0.36) / 2,
                            width: MediaQuery.of(context).size.width * 0.36,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.cyan,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                      (MediaQuery.of(context).size.width * 0.36).toDouble()),
                                  bottomRight: Radius.circular(
                                      (MediaQuery.of(context).size.width * 0.36).toDouble()),
                                ),
                              ),
                              child:
                              const Icon(Icons.propane_tank_outlined),
                            ),
                          ),
                          const Spacer(),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Projects",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          const SizedBox(height: 10,)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() =>  CreateHiringScreen(ProjectId: '',));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width * 0.36,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(13.0),
                              bottomRight: Radius.circular(13.0))),
                      child: Column(
                        children: [
                          Container(
                            height: (MediaQuery.of(context).size.width * 0.36) / 2,
                            width: MediaQuery.of(context).size.width * 0.36,
                            child:  Container(
                                decoration:  BoxDecoration(
                                  color: Colors.cyan,
                                  borderRadius:  BorderRadius.only(
                                    bottomLeft: Radius.circular(
                                        (MediaQuery.of(context).size.width * 0.36).toDouble()),
                                    bottomRight: Radius.circular(
                                        (MediaQuery.of(context).size.width * 0.36).toDouble()),
                                  ),
                                ),
                                child: const Icon(Icons.add_card_outlined)),
                          ),
                          const Spacer(),
                          const Padding(
                            padding:  EdgeInsets.all(8.0),
                            child: Text(
                              "Hiring",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          const SizedBox(height: 10,)
                        ],
                      ),
                    ),
                  ),
                ],
              ): Center(
                child: CarouselSlider.builder(
                  itemCount: images.length,
                  options: CarouselOptions(
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 2), // Auto-play interval
                    enlargeCenterPage: true,
                    viewportFraction: 0.8,
                    aspectRatio: 2.0,
                  ),
                  itemBuilder: (BuildContext context, int index, int realIndex) {
                    return Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage(images[index]), // Use AssetImage for local images
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),



              StreamBuilder<ApiResponse<HiringHomeresponse>>(
                stream: _bloc.hiringListStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status!) {
                      case Status.LOADING:
                        return CommonApiLoader();
                      case Status.COMPLETED:
                        List<UserHirings> hiringList = _bloc.hiringList;
                               return _buildList(hiringList);
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




}

Widget _buildCarouselItem(String label, Color color) {
  return Container(
    margin: EdgeInsets.all(8),
    color: color,
    child: Center(
      child: Text(
        label,
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ),
    ),
  );
}

Widget _buildList(List<UserHirings> list) {
  if (list.isEmpty) {
    return Center(
      child: SizedBox(
        height: screenHeight / 3,
        child: CommonApiResultsEmptyWidget("No posts found"),
      ),
    );
  }

  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    // controller: _itemsScrollController,
    shrinkWrap: true,
    itemCount: list.length,
    itemBuilder: (context, position) {
      return Padding(
        padding:
        const EdgeInsets.only(left: 10.0, right: 10, top: 10, bottom: 10),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Casting for ${list[position].title}",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),

                  ],
                ),
                SizedBox(height: 8),

                Text(
                  "Description: ${list[position].description}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name: ${list[position].name}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Experience: ${list[position].experience}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Status: ${list[position].status}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Project Name: ${list[position].projectName ?? 'N/A'}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Pay: ${list[position].pay ?? 'N/A'}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Openings: ${list[position].openings ?? 'N/A'}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(

                    onPressed: () {
                      print("${list[position].projectId}");

                      Get.to(()=>ApplyHiringScreen( id: list[position].hiringId.toString(), ));
                      print("${list[position].projectId}");
                      // Handle Apply Here button tap
                    },
                    child: Text("Apply Here"),
                  ),
                ),
              ],
            ),
          ),
        ),

      );
    },
  );
}



