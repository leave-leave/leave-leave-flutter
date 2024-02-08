import 'package:flutter/material.dart';
import 'package:tteonatteona/post/widget/post.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tteonatteona/sign_up/widget/signup_complete_screen.dart';

class PostAdd extends StatelessWidget {
  const PostAdd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffECF3FF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          Row(
            children: [
              SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(builder: (context) => Post()),
                  );
                },
                icon: Icon(Icons.arrow_back, size: 20),
              ),
              Text(
                '게시물 등록',
                style: TextStyle(
                  color: Color(0xFF111111),
                  fontSize: 16,
                  fontFamily: 'Noto Sans KR',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Center(
            child: Container(
              width: 364,
              height: 760,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 36),
                  Container(
                    width: 296,
                    height: 230,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xff000000),
                        width: 0.5,
                      ),
                      color: Color(0xffd9d9d9),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 35, color: Color(0xff699BF7)),
                        SizedBox(height: 5),
                        Container(
                          width: 89,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: (){},
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              '사진추가',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Noto Sans Kr',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 19),
                  Row(
                    children: [
                      SizedBox(width: 34),
                      Icon(Icons.location_on, size: 32, color: Color(0xff699BF7)),
                      SizedBox(width: 10),
                      Container(
                        width: 254,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: TextField(
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            hintText: '제목을 입력하세요',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Color(0xffd9d9d9),
                              fontFamily: 'Noto Sans KR',
                              fontWeight: FontWeight.w500,
                            ),
                            contentPadding: EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 27),
                  Row(
                    children: [
                      SizedBox(width: 34),
                      Icon(Icons.edit, size: 32, color: Color(0xff699BF7)),
                      SizedBox(width: 10),
                      Container(
                        width: 254,
                        height: 312,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: TextField(
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            hintText: '내용을 입력하세요',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Color(0xffd9d9d9),
                              fontFamily: 'Noto Sans KR',
                              fontWeight: FontWeight.w500,
                            ),
                            contentPadding: EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.only(left: 240),
                    child : ElevatedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => complete()),);
                    },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(90, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('등록',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Noto Sans KR',
                              color: Colors.white
                          ),
                        )
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
