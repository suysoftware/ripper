import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ripper/src/constants/color_constants.dart';
import 'package:ripper/src/services/firestore_operations.dart';
import 'package:sizer/sizer.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({super.key});

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  var top10NameTextStyle = TextStyle(fontFamily: 'Roboto', fontSize: 15);
  var top10YearTextStyle = TextStyle(fontFamily: 'Roboto', fontSize: 12);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: FutureBuilder(
      future: FirestoreOperations.getLeaderBoard(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              const Spacer(
                flex: 1,
              ),
              topRowBuild(),
              leaderBoardTopImageBuild(),
              topMemberTextBuild(snapshot.data!),
              const Spacer(
                flex: 1,
              ),
            ],
          );
        }
        return const Center(
          child: CupertinoActivityIndicator(),
        );
      },
    ));
  }

  Widget leaderBoardTextBuild() {
    return Text(
      'Leaderboards',
      style: TextStyle(fontFamily: 'Roboto-Medium', fontSize: 16.sp),
    );
  }

  Widget closeButtonBuild() {
    return CupertinoButton(
        child: Icon(
          CupertinoIcons.xmark,
          size: 26.sp,
          color: CupertinoColors.black,
        ),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  Widget topRowBuild() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          leaderBoardTextBuild(),
          closeButtonBuild(),
        ],
      ),
    );
  }

  Widget leaderBoardTopImageBuild() {
    return SizedBox(
      width: 80.w,
      child: Image.asset(
        'assets/images/leaderboardtop.png',
        filterQuality: FilterQuality.high,
      ),
    );
  }

  Widget topMemberTextBuild(List<dynamic> members) {
    return SizedBox(
      height: 60.h,
      child: ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, index) {
          return leaderListTileBuild(
              members[index]['user_name'],
              "${(members[index]['user_year'] as double).round().toString()}  Year",
              index + 1);
        },
      ),
    );

    /*Column(
      children: [
        Text(
          userName,
          style: top10NameTextStyle,
        ),
        Text(
          userYear,
          style: top10YearTextStyle,
        ),
      ],
    ); */
  }

  Widget leaderListTileBuild(String name, String year, int index) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: ColorConstants.themeGreen))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 5.w,
          ),
               index == 1
              ? Image.asset(
                  'assets/images/ripper_diamond.png',
                  scale: 15.0,
                )
              : SizedBox(),
          index == 2
              ? Image.asset(
                  'assets/images/ripper_gold.png',
                  scale: 18.0,
                )
              : SizedBox(),
          index == 3
              ? Padding(
                padding:  EdgeInsets.only(left: 1.5.w),
                child: Image.asset(
                    'assets/images/ripper_silver.png',
                    scale: 21.0,
                  ),
              ):SizedBox(),
                index>=4?Padding(
                 padding:  EdgeInsets.only(left: 3.w),
                  child: Image.asset(
                    'assets/images/ripper_bronze.png',
                    scale: 25.0,
                  ),
                )
              : SizedBox(),
       
          Spacer(),
        Text(
            "$name",
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize:  index == 1?18:index==2?17:index==3?16:14,
                fontWeight: FontWeight.w600),
          ),
          Spacer(),
          Text(
            year,
            style: TextStyle(
                fontFamily: 'Roboto',
         fontSize:  index == 1?18:index==2?17:index==3?16:14,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 5.w,
          ),
        ],
      ),
    );
  }
}
