import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_message_entity.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/pages/chatbot_model.dart';
import 'package:flutter_chatgpt_clone/features/global/const/app_const.dart';
import 'package:flutter_chatgpt_clone/features/global/theme/style.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';

class ChatMessageSingleItem extends StatelessWidget {
  final ChatMessageEntity chatMessage;

  ChatMessageSingleItem(
      {Key? key, required this.chatMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        SlideEffect(begin: Offset(0, 1), duration: Duration(milliseconds: 300))
      ],
      child: _chatMessageItem(context),
    );
  }

  Widget _chatMessageItem(BuildContext context) {
    if (chatMessage.messageId == ChatGptConst.AIBot) {
      return Container(
        padding: EdgeInsets.only(top: 25, bottom: 25, left: 150, right: 100),
        decoration: BoxDecoration(
          color: colorGrayLight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 35,
                    width: 35,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset("assets/openAIChatbot.png"))),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                    width: 40,
                    height: 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "gg",
                      //  model.intent,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(bottom: 10, top: 10),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  height: 120,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Colors.black),
                  child: Column(
                    children: [
                      Text(
                        "Hello my name is rakshit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  height: 120,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Colors.black),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  height: 120,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Colors.black),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              margin: EdgeInsets.only(left: 50),
              child: Row(
                children: [
                  // InkWell(
                  //     onTap: () {
                  //       Clipboard.setData(
                  //           ClipboardData(text: chatMessage.promptResponse));
                  //       //toast("Copied");
                  //     },
                  //     child: Icon(Icons.copy, size: 18)),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                      onTap: () {
                        Share.share(chatMessage.promptResponse!);
                      },
                      child: Icon(Icons.share, size: 18)),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 150),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: Text(
                  "U",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: 10, top: 10),
                child: MarkdownBody(
                  selectable: true,
                  data: chatMessage.queryPrompt!,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

class ViewAllPageContainer extends StatefulWidget {
  ViewAllPageContainer({
    Key? key,
    required this.title,
    required this.logo,
    required this.ticker,
    required this.tickerFirebasePriceChange,
    required this.projectMarketImpact,
    required this.investmentSentiment,
    required this.companySentiment,
    required this.bookmarked,
    required this.insightId,
    required this.isLastIndex,
    required this.entityid,
    required this.entityType,
    required this.duration,
  }) : super(key: key);
  final bool isLastIndex;
  final String title;
  final String logo;
  final String entityType;

  final String ticker;
  final double tickerFirebasePriceChange;
  final String projectMarketImpact;
  final double investmentSentiment;
  final double companySentiment;
  final String insightId;
  bool bookmarked;
  final String entityid;
  final String duration;

  @override
  State<ViewAllPageContainer> createState() => _ViewAllPageContainerState();
}

class _ViewAllPageContainerState extends State<ViewAllPageContainer> {
  Color getSentimentColor(double value) {
    if (value > 15) {
      return Colors.green;
    } else if (value >= -10 && value <= 15) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String getSentiment(double value) {
    if (value > 15) {
      return 'Good';
    } else if (value >= -10 && value <= 15) {
      return 'Neutral';
    } else {
      return 'Bad';
    }
  }

  Color getSentimentInsightColor(double value) {
    if (value > 15) {
      return Color(0xff4CA078);
    } else if (value >= -10 && value <= 15) {
      return Color(0xffF5977A);
    } else {
      return Color((0xffFF6A6A));
    }
  }

  String getInvestorSentimentValue(double sentiment) {
    int value = sentiment.toInt();

    if (-100 < value && value < -33) {
      return "Bearish";
    } else if (-32 < value && value <= 32) {
      return "Neutral";
    } else if (33 < value && value < 100) {
      return "Bullish";
    } else {
      return "-";
    }
  }

  Color getInvestorSentimentColor(double sentiment) {
    int value = sentiment.toInt();

    if (-100 < value && value < -33) {
      return Colors.red;
    } else if (-32 < value && value <= 32) {
      return Colors.orange;
    } else if (33 < value && value < 100) {
      return Colors.green;
    } else {
      return Colors.blue;
    }
  }

  // Route _createRouteSearch(bool isopen) {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) => BottomNavBar(
  //       togglevalue: gettogeleValue(),
  //       insightid: widget.insightId,
  //       selectedIndex: 2,
  //       // selectedIndex: 0,
  //     ),
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       const begin = Offset(1, 0.0);
  //       const end = Offset.zero;
  //       const curve = Curves.ease;

  //       var tween =
  //           Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

  //       return SlideTransition(
  //         position: animation.drive(tween),
  //         child: child,
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    //final book = Provider.of<BookProv>(context, listen: false);

    return Padding(
      padding: EdgeInsets.only(bottom: widget.isLastIndex ? 20.0 : 0.0),
      child: GestureDetector(
        onTap: () {
          //  Navigator.of(context).pushReplacement(_createRouteSearch(false));
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 6.w, horizontal: 16.5.w),
          decoration: BoxDecoration(
            color: Color(0xff141418),
            border: Border.all(color: Color(0xff2D2D2D), width: 0.4),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 14.5.w, right: 14.5.w, top: 10.h, bottom: 5.h),
                child: Text(
                  widget.title.trim(),
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  maxLines: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14.5,
                ),
                child: Divider(
                  color: Color(0xff2D2D2D),
                  thickness: 0.4,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 24.w, right: 20.w, top: 2.h, bottom: 2.h),
                child: Row(
                  children: [
                    // GestureDetector(
                    //   onTap: () {
                    //     // Navigator.push(
                    //     //     context,
                    //     //     MaterialPageRoute(
                    //     //         builder: (context) =>
                    //     //             NewStockDetailPage(id: widget.entityid)));
                    //   },fl
                    //   child: Row(
                    //     children: [
                    //       ClipRRect(
                    //           borderRadius: BorderRadius.circular(10),
                    //           child: widget.logo.isEmpty
                    //               ? CircleAvatar(
                    //                   backgroundColor: Color(0xff2D2D2D),
                    //                   radius: 17,
                    //                   // child: Text(
                    //                   //   widget.ticker.substring(0, 1),
                    //                   //   style: TextStyle(
                    //                   //     color: Color(0xffB6B6B6),
                    //                   //     fontWeight: FontWeight.w500,
                    //                   //     fontSize: 14.sp,
                    //                   //   ),
                    //                   // ),
                    //                 )
                    //               : Image.network(
                    //                   errorBuilder: (e, r, f) {
                    //                     return SvgPicture.asset(
                    //                       Assets.svg.defualtStockIcon,
                    //                       height: 17.h,
                    //                       width: 17.w,
                    //                     );
                    //                   },
                    //                   widget.logo,
                    //                   fit: BoxFit.fill,
                    //                   height: 17.h,
                    //                   width: 17.w,
                    //                   cacheHeight: 40.h.toInt(),
                    //                   cacheWidth: 40.w.toInt(),
                    //                 )),
                    //       SizedBox(
                    //         width: 5,
                    //       ),
                    //       Text(
                    //         widget.ticker.toUpperCase(),
                    //         style: TextStyle(
                    //           color: Color(0xffB6B6B6),
                    //           fontWeight: FontWeight.w500,
                    //           fontSize: 14.sp,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Spacer(),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 10.w, right: 10.w, top: 7.h, bottom: 9.h),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xff0D0D0D),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 7.w, vertical: 7.h),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/stockup.svg",
                                  // Assets.icons.homepage.svg.stockup,
                                  color: Color(0xff636363),
                                  height: 13.h,
                                  width: 12.w,
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  widget.projectMarketImpact,
                                  style: TextStyle(
                                      color: (widget.projectMarketImpact
                                                  .toString() ==
                                              'High')
                                          ? Colors.green
                                          : (widget.projectMarketImpact
                                                      .toString() ==
                                                  'Medium')
                                              ? Colors.orange
                                              : Colors.red,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xff0D0D0D),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 7.w, vertical: 7.h),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/investersenti.svg",
                                  //  Assets.icons.homepage.svg.investersenti,
                                  color: Color(0xff636363),
                                  height: 14.h,
                                  width: 9.w,
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  getInvestorSentimentValue(
                                          widget.investmentSentiment)
                                      .toString(),
                                  style: TextStyle(
                                      color: getInvestorSentimentColor(
                                          widget.investmentSentiment),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xff0D0D0D),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 7.w, vertical: 7.h),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/companysenti.svg",
                                  //  Assets.icons.homepage.svg.comapnysenti,
                                  color: Color(0xff636363),
                                  height: 13.h,
                                  width: 13.w,
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  getSentiment(widget.companySentiment),
                                  style: TextStyle(
                                      color: getSentimentColor(
                                          widget.companySentiment),

                                      // (widget.companySentiment >= 0)
                                      //     ? newlightgreen
                                      //     : newRedcolor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xff0D0D0D),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 7.h),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons8Clock.svg",
                                  //    Assets.home.icons8Clock,
                                  color: Color(0xff636363),
                                  height: 16.h,
                                  width: 16.w,
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                Text(
                                  widget.duration + " days",
                                  style: TextStyle(
                                      color: Colors.white,

                                      // (widget.companySentiment >= 0)
                                      //     ? newlightgreen
                                      //     : newRedcolor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                //bookmark
              ),
            ],
          ),
        ),
      ),
    );
  }
}
