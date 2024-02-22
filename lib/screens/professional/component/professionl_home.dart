
import 'package:cached_network_image/cached_network_image.dart';
import 'package:film/screens/professional/create_project_screen.dart';
import 'package:film/screens/professional/hiring/create_hiring_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../utils/api_helper.dart';
import '../../../widgets/app_image_viewer.dart';
import '../../../widgets/common_api_result_empty_widget.dart';

class ProfessionalHome extends StatefulWidget {
  const ProfessionalHome({Key? key}) : super(key: key);

  @override
  State<ProfessionalHome> createState() => _ProfessionalHomeState();
}

class _ProfessionalHomeState extends State<ProfessionalHome> {

  List<PostList> allPosts = [
    PostList(
      postedUserId: '001',
      postedUserName: 'John Doe',
      postedUserImage: 'image_url',
      userId: '002',
      userLiked: false,
      postId: 'post_001',
      postTitle: 'Title of Post 1',
      emojiId: 'emj_001',
      location: 'Location 1',
      timeStamp: 'timestamp',
      comments: [],
      peopleLiked: [],
      type: 'Type 1',
      textBg: 'Background 1',
      file: [],
    ),
    PostList(
      postedUserId: '003',
      postedUserName: 'Jane Smith',
      postedUserImage: 'image_url',
      userId: '004',
      userLiked: true,
      postId: 'post_002',
      postTitle: 'Title of Post 2',
      emojiId: 'emj_002',
      location: 'Location 2',
      timeStamp: 'timestamp',
      comments: [],
      peopleLiked: [],
      type: 'Type 2',
      textBg: 'Background 2',
      file: [],
    ),
    PostList(
      postedUserId: '005',
      postedUserName: 'Tom Jackson',
      postedUserImage: 'image_url',
      userId: '006',
      userLiked: false,
      postId: 'post_003',
      postTitle: 'Title of Post 3',
      emojiId: 'emj_003',
      location: 'Location 3',
      timeStamp: 'timestamp',
      comments: [],
      peopleLiked: [],
      type: 'Type 3',
      textBg: 'Background 3',
      file: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding:  const EdgeInsets.all(12.0),
            child: Column(
              children: [

                Row(
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
                        Get.to(() => const CreateHiringScreen());
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
                ),
                _buildList(allPosts),

              ],
            ),
          ),
        ),
      ),

    );

  }
  Widget _buildList(List<PostList> list) {
    if (list.isEmpty) {
      return SizedBox(
        height: screenHeight / 3,
        child: CommonApiResultsEmptyWidget(""),
      );
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      // controller: _itemsScrollController,
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, position) {
        // final TextEditingController _comment = TextEditingController();
        // (list[position].userLiked == true)
        //     ? control.liked.value = true
        //     : control.liked.value = false;

        return Padding(
          padding:
          const EdgeInsets.only(left: 10.0, right: 10, top: 10, bottom: 10),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4.0,
                  spreadRadius: 0.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _newsFeedsProfileRow(list[position]),
                SizedBox(
                  //height: 250,
                  width: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 1.0, right: 1.0, top: 8.0, bottom: 4),
                    child: InkWell(
                      onTap: () => Get.to(() => PhotoViewer(
                        image: "https://cocoalabs.in/Filmy/public/storage/images/posters/1708494601.jpg",
                        networkImage: true,
                        title: list[position].postTitle,
                      )),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2.0),
                        child: CachedNetworkImage(
                          imageUrl: "https://cocoalabs.in/Filmy/public/storage/images/posters/1708494601.jpg",
                          placeholder: (context, url) =>
                          const CupertinoActivityIndicator(),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                ),


          //     _newsFeedIconsRow(list[position], control.liked, context),
                Padding(
                  padding: const EdgeInsets.only(left: 260.0, right: 8.0),
                  child: Text(
                    "Apply Here",
                    maxLines: 1,
                    style: TextStyle(
                        height: 0,
                        fontSize: 16,
                        color: Colors.cyan,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

              ],
            ),
          ),
        );
      },
    );
  }

}
Widget _newsFeedsProfileRow( post) {

  DateTime now = DateTime.now();
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          child: CachedNetworkImage(
            imageUrl:"https://cocoalabs.in/Filmy/public/storage/images/posters/1708494601.jpg",
            placeholder: (context, url) => const CupertinoActivityIndicator(),
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black12,
                image:
                DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            errorWidget: (context, url, error) => ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: const Image(
                image: AssetImage(
                  'assets/images/profile.png',
                ),
              ),
            ),
            height: 38,
            width: 38,
            fit: BoxFit.fill,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                post.postedUserName!,
                style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                    height: 0.2,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(

                          " days ago",

                      style: TextStyle(
                          fontSize: 12,
                          height: 1.2,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        Text(
                          post.location!,
                          style: TextStyle(
                              fontSize: 13,
                              height: 1.2,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}
class PostList {
  final String postedUserId;
  final String postedUserName;
  final String postedUserImage;
  final String userId;
  final bool userLiked;
  final String postId;
  final String postTitle;
  final String emojiId;
  final String location;
  final String timeStamp;
  final List comments;
  final List peopleLiked;
  final String type;
  final String textBg;
  final List file;

  PostList({
    required this.postedUserId,
    required this.postedUserName,
    required this.postedUserImage,
    required this.userId,
    required this.userLiked,
    required this.postId,
    required this.postTitle,
    required this.emojiId,
    required this.location,
    required this.timeStamp,
    required this.comments,
    required this.peopleLiked,
    required this.type,
    required this.textBg,
    required this.file,
  });
}

void main() {
  List<PostList> posts = [
    PostList(
      postedUserId: 'user1',
      postedUserName: 'John Doe',
      postedUserImage: 'img1.jpg',
      userId: 'user2',
      userLiked: true,
      postId: 'post1',
      postTitle: 'Post Title 1',
      emojiId: 'emoji1',
      location: 'Location 1',
      timeStamp: '2022-01-01 12:00:00',
      comments: ['comment1', 'comment2'],
      peopleLiked: ['user3', 'user4'],
      type: 'Type 1',
      textBg: 'Text Background 1',
      file: ['file1.jpg'],
    ),
    PostList(
      postedUserId: 'user2',
      postedUserName: 'Jane Smith',
      postedUserImage: 'img2.jpg',
      userId: 'user1',
      userLiked: false,
      postId: 'post2',
      postTitle: 'Post Title 2',
      emojiId: 'emoji2',
      location: 'Location 2',
      timeStamp: '2022-01-02 13:00:00',
      comments: [],
      peopleLiked: ['user3', 'user5'],
      type: 'Type 2',
      textBg: 'Text Background 2',
      file: ['file2.jpg', 'file3.jpg'],
    ),
  ];

  print(posts[0].postTitle); // Output: Post Title 1
}
