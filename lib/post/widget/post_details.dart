import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:tteonatteona/secret.dart';

class PostDetails extends StatefulWidget {
  const PostDetails({Key? key}) : super(key: key);

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  int likeCount = 12;
  bool isLiked = false;
  TextEditingController commentController = TextEditingController();
  List<String> comments = [];


  Future<void> comment(String feedId, String comment) async {
    Dio dio = Dio();

    Map<String, dynamic> data = {
      "comment" : comment,
    };

    try {
      final resp = await dio.post(
        "$baseUrl/comment/$feedId",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
        ),
      );
      print(resp.statusCode);
      print(jsonEncode(data));
    } catch (e) {
      print('에러');
      throw Exception(e);
    }
  }


  Future<void> commentdelete(String commentId, String comment) async {
    Dio dio = Dio();

    try {
      final resp = await dio.delete(
        "$baseUrl/comment/$commentId",
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


  Future<void> imageupload(imageFile) async {
    Dio dio = Dio();

    try {
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(imageFile.path, filename: "image.jpg"),
      });

      final resp = await dio.post(
        "$baseUrl/upload",
        data: formData,
        options: Options(
          headers: {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffECF3FF),
      body: Column(
        children: [
          SizedBox(height: 24),
          Row(
            children: [
              SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, size: 20),
              ),
              Text(
                '자세히 보기',
                style: TextStyle(
                  color: Color(0xFF111111),
                  fontSize: 16,
                  fontFamily: 'Noto Sans KR',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          Container(
            height: 758,
            margin: EdgeInsets.only(left: 24, right: 24),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(width: 16),
                    Icon(
                      Icons.account_circle,
                      color: Color(0xff2B8AFB),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '서예린',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 220),
                    Icon(Icons.more_vert, size: 20, color: Color(0xff3F3D56))
                  ],
                ),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.only(left: 34),
                  child: Image.asset('assets/images/post.png'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 30),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isLiked = !isLiked;
                          if (isLiked) {
                            likeCount++;
                          } else {
                            likeCount--;
                          }
                        });
                      },
                      icon: isLiked
                          ? Icon(Icons.favorite, size: 24, color: Colors.blue)
                          : Icon(Icons.favorite_border, size: 24, color: Colors.blue),
                    ),
                    Text(likeCount.toString()),
                    IconButton(
                      onPressed: () {
                        // Add functionality for comments button
                      },
                      icon: Icon(Icons.mode_comment_outlined, size: 24, color: Colors.blue),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 36),
                  child: Text(
                    '제목 : ㅁㄴㅇㄹ',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 36),
                  child: Text(
                    'ㅇㄴㄹㄴㅁㅇㄹㄴㅇㄹㅇㄴ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 11),
                Padding(
                  padding: EdgeInsets.only(left: 36),
                  child: Text(
                    '댓글',
                  ),
                ),
                SizedBox(height: 6),
                Container(
                  margin: EdgeInsets.only(left: 34),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 230,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Color(0xffEBEBEB),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: '댓글을 입력해 주세요',
                            hintStyle: TextStyle(
                              color: Color(0xffA9A9A9),
                              fontSize: 9,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        width: 57,
                        height: 30,
                        margin: EdgeInsets.only(right: 34),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              comments.add(commentController.text);
                              commentController.clear();
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xff3792FD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            '등록',
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'Noto Sans KR',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 295,
                  height: 3,
                  color: Color(0xffD9D9D9),
                  margin: EdgeInsets.only(left: 34, top: 8),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 0, left: 36, bottom: 15),
                        child: Container(
                          width: 289,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.account_circle, color: Color(0xff2B8AFB)),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '서예린',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      comments[index],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    comments.removeAt(index);
                                  });
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
