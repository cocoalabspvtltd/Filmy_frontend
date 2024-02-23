// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:film/bloc/professionalBloc/hiring_bloc.dart';
// import 'package:film/bloc/professionalBloc/project_bloc.dart';
// import 'package:film/core/load_more_listener.dart';
// import 'package:film/models/hiring.dart';
//
// import 'package:film/models/project_list_response.dart';
// import 'package:film/models/common.dart';
// import 'package:film/screens/professional/hiring/edit_hiring_screen.dart';
// import 'package:film/screens/professional/p_home_screen.dart';
// import 'package:film/screens/professional/projects/edit_project_screen.dart';
// import 'package:film/utils/custom_loader/linear_loader.dart';
// import 'package:film/widgets/common_api_loader.dart';
// import 'package:film/widgets/common_api_result_empty_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../bloc/professionalBloc/homehiring.dart';
// import '../../../models/hiring_list_response.dart';
//
// class HiringListHomeScreen extends StatefulWidget {
//   const HiringListHomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HiringListHomeScreen> createState() => _HiringListHomeScreenState();
// }
//
// class _HiringListHomeScreenState extends State<HiringListHomeScreen>
//     with LoadMoreListener {
//   late HiringHomeBloc _bloc;
//   late ScrollController _itemsScrollController;
//   bool isLoadingMore = false;
//   List<UserHirings> filteredHiringList = [];
//
//   @override
//   void initState() {
//     _bloc = HiringHomeBloc(listener: this);
//     _bloc.gethiringapplicList(false);
//     _itemsScrollController = ScrollController();
//     _itemsScrollController.addListener(_scrollListener);
//     super.initState();
//   }
//
//   @override
//   refresh(bool isLoading) {
//     if (mounted) {
//       setState(() {
//         isLoadingMore = isLoading;
//       });
//     }
//   }
//
//   paginate() async {
//     await _bloc.gethiringapplicList(true);
//   }
//
//   void _scrollListener() async {
//     if (_itemsScrollController.offset >=
//         _itemsScrollController.position.maxScrollExtent &&
//         !_itemsScrollController.position.outOfRange) {
//       paginate();
//     }
//     if (_itemsScrollController.offset <=
//         _itemsScrollController.position.minScrollExtent &&
//         !_itemsScrollController.position.outOfRange) {
//       // Reached the top
//     }
//   }
//
//   void filterHiringList(String query) {
//     setState(() {
//       filteredHiringList = _bloc.hiringList
//           .where((hiring) =>
//           hiring.title!.toLowerCase().contains(query.toLowerCase())).toList();
//     });
//   }
//   TextEditingController searchController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: RefreshIndicator(
//         color: Colors.white,
//         backgroundColor: Colors.cyan,
//         onRefresh: () => _bloc.gethiringapplicList(false),
//         child: SingleChildScrollView(
//           physics: AlwaysScrollableScrollPhysics(),
//           controller: _itemsScrollController,
//           child: Column(
//             children: [
//               SizedBox(height: 10),
//               User_Details.userRole =="professional"? Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Get.to(() => const CreateProjectScreen());
//                     },
//                     child: Container(
//                       height: MediaQuery.of(context).size.height * 0.15,
//                       width: MediaQuery.of(context).size.width * 0.36,
//                       decoration: BoxDecoration(
//                           color: Colors.grey[300],
//                           borderRadius: const BorderRadius.only(
//                               bottomLeft: Radius.circular(13.0),
//                               bottomRight: Radius.circular(13.0))),
//                       child: Column(
//                         children: [
//                           SizedBox(
//                             height: (MediaQuery.of(context).size.width * 0.36) / 2,
//                             width: MediaQuery.of(context).size.width * 0.36,
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.cyan,
//                                 borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(
//                                       (MediaQuery.of(context).size.width * 0.36).toDouble()),
//                                   bottomRight: Radius.circular(
//                                       (MediaQuery.of(context).size.width * 0.36).toDouble()),
//                                 ),
//                               ),
//                               child:
//                               const Icon(Icons.propane_tank_outlined),
//                             ),
//                           ),
//                           const Spacer(),
//                           const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text(
//                               "Projects",
//                               style: TextStyle(fontWeight: FontWeight.w500),
//                             ),
//                           ),
//                           const SizedBox(height: 10,)
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width / 10,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Get.to(() =>  CreateHiringScreen(ProjectId: '',));
//                     },
//                     child: Container(
//                       height: MediaQuery.of(context).size.height * 0.15,
//                       width: MediaQuery.of(context).size.width * 0.36,
//                       decoration: BoxDecoration(
//                           color: Colors.grey[300],
//                           borderRadius: const BorderRadius.only(
//                               bottomLeft: Radius.circular(13.0),
//                               bottomRight: Radius.circular(13.0))),
//                       child: Column(
//                         children: [
//                           Container(
//                             height: (MediaQuery.of(context).size.width * 0.36) / 2,
//                             width: MediaQuery.of(context).size.width * 0.36,
//                             child:  Container(
//                                 decoration:  BoxDecoration(
//                                   color: Colors.cyan,
//                                   borderRadius:  BorderRadius.only(
//                                     bottomLeft: Radius.circular(
//                                         (MediaQuery.of(context).size.width * 0.36).toDouble()),
//                                     bottomRight: Radius.circular(
//                                         (MediaQuery.of(context).size.width * 0.36).toDouble()),
//                                   ),
//                                 ),
//                                 child: const Icon(Icons.add_card_outlined)),
//                           ),
//                           const Spacer(),
//                           const Padding(
//                             padding:  EdgeInsets.all(8.0),
//                             child: Text(
//                               "Hiring",
//                               style: TextStyle(fontWeight: FontWeight.w500),
//                             ),
//                           ),
//                           const SizedBox(height: 10,)
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ):Container(),
//               StreamBuilder<ApiResponse<HiringHomeresponse>>(
//                 stream: _bloc.hiringListStream,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     switch (snapshot.data!.status!) {
//                       case Status.LOADING:
//                         return CommonApiLoader();
//                       case Status.COMPLETED:
//                         List<UserHirings> hiringList = _bloc.hiringList;
//
//                       case Status.ERROR:
//                         return SizedBox(
//                           height: MediaQuery.of(context).size.height - 180,
//                           child: CommonApiResultsEmptyWidget(
//                             "${snapshot.data!.message!}",
//                             textColorReceived: Colors.black,
//                           ),
//                         );
//                     }
//                   }
//                   return SizedBox(
//                     height: MediaQuery.of(context).size.height - 180,
//                     child: CommonApiLoader(),
//                   );
//                 },
//               ),
//               if (isLoadingMore) LinearLoader(),
//               SizedBox(
//                 height: 30,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//
//
// }
