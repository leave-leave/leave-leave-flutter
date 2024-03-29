import 'package:flutter/material.dart';
import 'package:tteonatteona/mypage/model/travel_check.dart';
import 'package:tteonatteona/post/widget/post.dart';
import 'package:tteonatteona/travelplane/widget/travelplane.dart';
import 'package:tteonatteona/mypage/model/user_model.dart';
import 'package:tteonatteona/secret.dart';
import 'package:tteonatteona/post/model/post_check.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class MyPage extends StatefulWidget {

  final String title;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> traveldetail;


  const MyPage({Key? key,
    required this.title,
    this.startDate,
    this.endDate, required this.traveldetail,
    }) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  bool hasPlans = false;
  bool hasReactedPosts = true;
  String? userName;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    checkForPlans();
  }

  void checkForPlans() {
    bool planExist = widget.traveldetail.isNotEmpty;;
    setState(() {
      hasPlans = planExist;
    });
  }


  List<String> get travelIdetail => widget.traveldetail;

  Future userInfo() async{

    Dio dio = Dio();

    try{
      final response = await dio.get(
        '$baseUrl/users/user',
        options: Options(
          headers: {
            "Content-Type" : "application/json",
            "Authorization" : "Bearer $accessToken"
          },
        )
      );

      model _user = model.fromJson(response.data);
      setState(() {
        userName = _user.name;
      });

    }
    catch(e){
      print('e');
    }
  }

  Future<void> postLike(
      String feedId,
      String title,
      String content,
      ) async {
    Dio dio = Dio();

    Map<String, dynamic> data = {
      "feedId": feedId,
      "title": title,
      "content": content,
    };

    try {
      final resp = await dio.get(
        "$baseUrl/feeds/like",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
        ),
        data: jsonEncode(data),
      );
      print(resp.statusCode);
      print(jsonEncode(data));
    } catch (e) {
      print('에러');
      throw Exception(e);
    }
  }


  Future<travel_check> getTravelCheck(String planId) async {
    Dio dio = Dio();
    travel_check travelCheck;

    try {
      final resp = await dio.get(
        "$baseUrl/plans/$planId",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
        ),
      );
      if (resp.statusCode == 200) {
        travelCheck = travel_check.fromJson(resp.data);
        print('여행 계획 조회 성공');
      } else {
        print('여행 계획 조회 실패. 상태 코드: ${resp.statusCode}');
      }
    } catch (e) {
      print('에러: $e');
      throw Exception(e);
    }

    return travel_check();
  }

  Future<List<PostCheck>> fetchPostslike() async {
    Dio dio = Dio();
    List<PostCheck> posts = [];

    try {
      final resp = await dio.get(
        "$baseUrl/feeds/like",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
        ),
      );

      List<dynamic> parsedJson = jsonDecode(resp.data);
      posts = parsedJson
          .where((json) => json['user_like'])
          .map((json) => PostCheck.fromJson(json))
          .toList();
    } catch (e) {
      print('에러: $e');
      throw Exception(e);
    }
    return posts;
  }


  @override
  Widget build(BuildContext context) {
    userInfo();
    return Scaffold(
      backgroundColor: Color(0xffECF3FF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          Row(
            children: [
              SizedBox(width: 30),
              Text(
                '마이 페이지',
                style: TextStyle(
                  color: Color(0xFF111111),
                  fontSize: 16,
                  fontFamily: 'Noto Sans KR',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.only(left: 38),
            width: 411,
            height: 115,
            decoration: BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                Image.asset('assets/images/profile.png'),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$userName',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Noto Sans KR',
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(
                    text: '여행 계획',
                  ),
                  Tab(
                    text: '반응한 게시물',
                  ),
                ],
                labelColor: Color(0xff1B6BD2),
                unselectedLabelColor: Color(0xff9F9F9F),
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Noto Sans Kr',
                ),
                indicatorWeight: 3,
                indicatorColor: Color(0xff1B6BD2),
                indicatorSize: TabBarIndicatorSize.label,
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                hasPlans ? buildTravelPlanWidget() : buildNoPlansWidget(),
                hasReactedPosts
                    ? buildReactedPostsWidget()
                    : buildNoReactedPostsWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget buildTravelPlanWidget() {
    return Column(
      children: [
        SizedBox(height: 17),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.only(left: 24),
            width: 200,
            height: 35,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TravelPlane()));
              },
              child: Text(
                '계획 작성하기',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xffffffff),
                  fontFamily: 'NotoSansKR',
                ),
              ),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                backgroundColor: Color(0xff3792FD),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.only(top: 12, bottom: 21),
          width: 363,
          height: 456,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 17),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        hasPlans = false;
                      });
                    },
                    child: Icon(Icons.delete, size: 24),
                  ),
                  SizedBox(width: 17),
                ],
              ),
              SizedBox(height: 9),
              Row(
                children: [
                  SizedBox(width: 17),
                  GestureDetector(
                    onTap: (){},
                    child: Container(
                      width: 147,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(0xffB8D1FE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          widget.startDate != null ? DateFormat('yyyy-MM-dd').format(widget.startDate!) : '',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 7),
                  Icon(Icons.horizontal_rule),
                  SizedBox(width: 7),
                  GestureDetector(
                    onTap: (){},
                    child: Container(
                      width: 147,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(0xffB8D1FE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          widget.endDate != null ? DateFormat('yyyy-MM-dd').format(widget.endDate!) : '',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14),
              Padding(
                padding: EdgeInsets.only(left: 17),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '할 일',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontFamily: 'Noto Sans KR'
                    ),
                  ),
                ),
              ),
              SizedBox(height: 17,),
              Expanded(child: ListView.builder(
                padding: EdgeInsets.only(top: 0),
                itemCount: travelIdetail.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      SizedBox(width: 28),
                      Icon(Icons.brightness_1, size: 12, color: Color(0xff699BF7),),
                      SizedBox(width: 10),
                      Container(
                        width: 277,
                        height: 59,
                        margin: EdgeInsets.only(bottom: 18),
                        padding: EdgeInsets.symmetric(horizontal: 19),
                        decoration: BoxDecoration(
                          color: Color(0xffEBEBEB),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.centerLeft,
                          child: Text(
                            widget.traveldetail[index],
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    );
                    },
              )
              )
            ],
          ),
        )
      ],
    );
  }



  Widget buildReactedPostsWidget() {
    return Container(
      padding: EdgeInsets.only(top: 16, left: 20, right: 20),
      child: Center(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: 15,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xff3792FD),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    width: 371,
                    height: 90,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          '2024년 3월 19일에 LCK 보고 싶어서 서울 여행을 계획해보자 '
                              '나는 잠실에 있는 시그니엘 호텔에서 잠을 자자 '
                              '비용은 n빵 하는 걸로 그리고...',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontFamily: "Noto Sans KR",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0.1,
                    right: 20,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context, 
                        MaterialPageRoute(builder: (context) => const Post(imageUrl: '', title: '', content: '',))
                        );
                      },
                      child: Text(
                        '자세히 보기',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff3792FD),
                          fontFamily: "Noto Sans KR",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildNoPlansWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(top: 17),
              padding: EdgeInsets.only(left: 24),
              width: 200,
              height: 35,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TravelPlane()));
                },
                child: Text(
                  '계획 작성하기',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xffffffff),
                    fontFamily: 'NotoSansKR',
                  ),
                ),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  backgroundColor: Color(0xff3792FD),
                ),
              ),
            ),
          ),
          SizedBox(height: 183),
          Text(
            '여행 계획을 작성해 보실래요?',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xff83ACF9),
              fontWeight: FontWeight.w600,
              fontFamily: 'Noto Sans KR',
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNoReactedPostsWidget() {
    return Center(
      child: Text(
        '반응한 게시물이 없습니다.',
        style: TextStyle(
          fontSize: 20,
          color: Color(0xff83ACF9),
          fontWeight: FontWeight.w600,
          fontFamily: 'Noto Sans KR',
        ),
      ),
    );
  }
}
