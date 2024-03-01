import 'package:flutter/material.dart';
import 'package:tteonatteona/post/widget/post_add.dart';
import 'package:tteonatteona/post/widget/post_details.dart';
import 'package:dio/dio.dart';
import 'package:tteonatteona/secret.dart';
import '../model/post_check.dart';

class Post extends StatefulWidget {

  final String title;
  final String content;
  final String imageUrl;

  const Post({
    Key? key,
    required this.title,
    required this.content,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  int likeCount = 12;
  bool isLiked = false;
  late List<PostCheck> posts;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> postDelete(String feedId) async {
    Dio dio = Dio();

    try {
      final resp = await dio.delete(
        "$baseUrl/feeds/$feedId",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
        ),
      );
      print(resp.statusCode);
    } catch (e) {
      print('에러');
      throw Exception(e);
    }
  }


  Future<void> fetchPosts() async {
    Dio dio = Dio();
    posts = [];

    try {
      final resp = await dio.get(
        "$baseUrl/feeds",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
        ),
      );
      if (resp.statusCode == 200) {
        resp.data.forEach((item) {
          posts.add(PostCheck.fromJson(item));
        });
        print('게시물 조회 성공');
      } else {
        print('게시물 조회 실패. 상태 코드: ${resp.statusCode}');
      }
    } catch (e) {
      print('에러: $e');
      throw Exception(e);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffECF3FF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 25),
              Text(
                '게시물',
                style: TextStyle(
                  color: Color(0xFF111111),
                  fontSize: 16,
                  fontFamily: 'Noto Sans KR',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 280),
              SizedBox(
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PostAdd()),
                    );
                  },
                  icon: Icon(Icons.add, size: 24),
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          Container(
            margin : EdgeInsets.only(left: 24),
            width: 363,
            height: 363,
            decoration: BoxDecoration(
              color: Colors.white
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(left: 16, top: 12, bottom: 9),
                  child : Row(
                    children: [
                      Icon(Icons.account_circle_outlined, size: 30, color: Color(0xff2B8AFB),),
                      SizedBox(width: 8),
                      Text('서예린', style: TextStyle(
                        color: Colors.black,
                        fontSize: 14
                      ),)
                    ],
                  ),
                ),
                if (widget.imageUrl.isNotEmpty)
                  Image.network(
                    widget.imageUrl,
                    width: double.infinity,
                    height: 230,
                    fit: BoxFit.cover,
                  ),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 18),
                      child: Row(
                        children: [
                          IconButton(onPressed: (){}, icon: Icon(Icons.favorite_border, size: 24,),),
                          IconButton(onPressed: (){}, icon: Icon(Icons.mode_comment_outlined, size: 24,),),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 34),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 34),
                  child: Text(
                    widget.content,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}