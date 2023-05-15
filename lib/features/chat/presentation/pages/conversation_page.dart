import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_message_entity.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/cubit/chat_conversation/chat_conversation_cubit.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/pages/chatbot_model.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/chat_message_single_item.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/example_widget.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/left_nav_button_widget.dart';
import 'package:flutter_chatgpt_clone/features/global/common/common.dart';
import 'package:flutter_chatgpt_clone/features/global/const/app_const.dart';
import 'package:flutter_chatgpt_clone/features/global/custom_text_field/custom_text_field.dart';
import 'package:http/http.dart' as http;

class ConversationPage extends StatefulWidget {
  const ConversationPage({Key? key}) : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  TextEditingController _messageController = TextEditingController();
  bool _isRequestProcessing = false;

  ScrollController _scrollController = ScrollController();
  bool iswaiting = false;
  List _chatResponseList = [];
  int i = 0;

  void _sendMessage() async {
    //learning page priovider
    // final learningPageData =
    //     Provider.of<LearningProvider>(context, listen: false);
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    // var encoded = utf8.encode(_controller.text);
    // print(encoded);
    // prefs.remove("isJoinPremium");
    // learningPageData.count_to_chat += 1;
    // if (learningPageData.count_to_chat == 3) {
    //   await learningPageData.getJoinChatbotPremiumForWaitlist();
    //   if (learningPageData.joinPremium) {
    //     setState(() {
    //       // _isJoinPremiumVisible = true;
    //       // print("object---");
    //     });
    //   }
    // }
    // if (_chatMessages.isNotEmpty) _chatMessages.first.isLastQuestion = false;
    // ChatMessage message = ChatMessage(
    //   text: _controller.text,
    //   isChatbot: false,
    // );

    // var accessToken = await StorageService().JWTStorage.read(key: 'JWT');
    try {
      // setState(() {
      //   _isChatbotTyping = true;
      // });
      // String stringtosend = _controller.text.toString();
      setState(() {
        iswaiting = true;
      });
      String stringtosend = (_messageController.text.toString()).replaceAll(
          RegExp(r"[-!$%^&*()+|~=`{}#@\[\]:;'’<>?,\/"
              '"”'
              "]"),
          '');

      // print(stringtosend);

      // final r =
      //     await http.get(Uri.parse("http://52.66.235.4:8080/api/testJson/1"));
      // print(r.body);
      String t = "";
      final r = await http.get(
        Uri.parse("https://api-v2.onfinance.in/chatbot/chat"),
        headers: {
          "Authorization":
              'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6InNyYW51ajAyQGdtYWlsLmNvbSIsImZ1bGxfbmFtZSI6Ik5hbWUgIiwidWlkIjoiT2VIWFpWRzJoZ1NucTFWVTJRUU02VjM0c2NiMiJ9.IbTejelxYsU6aQXa_MKvY2GdOLNCXxjupa9BZpUVqRQ',
          "prompt":
              "if the following question contains a publicly listed equity in the Indian stock market return 1 word EQUITY, if it contains a publicly traded cryptocurrency return 1 word CRYTPO else written OTHERS: ${stringtosend.toString().toUpperCase()}",

          // Uri.parse(_controller.text).toString(),
        },
      );

      final Map<String, dynamic> decodedJson = jsonDecode(r.body);
      t = decodedJson['text'] ?? '';
      //fetch data of key text only from api
      // print(r.body);
      print(t);
      String key = t.toLowerCase().contains("equity")
          ? "equity"
          : t.toLowerCase().contains("crypto")
              ? "crypto"
              : "equity";
      print(key);
      print(stringtosend);

      final request = await http
          .get(
        Uri.parse(
            "https://api-v2.onfinance.in/neo?question=$stringtosend&key=$key"),
      )
          .then((value) {
        if (value.statusCode == 200) {
          _messageController.clear();
          if (i == 5) {
            i = 0;
          } else {
            i++;
          }
          print(value.body);

          ChatbotResponseModel _chatbotResponseModelData =
              ChatbotResponseModel.fromJson(jsonDecode(value.body));

          // ChatMessage chatbotMessage = ChatMessage(
          //   text: _chatbotResponseModelData.text,
          //   isChatbot: true,
          //   isLastQuestion: !(_chatMessages.first.isChatbot),
          // );
          // print(_chatbotResponseModelData.intent+"FFF");
          setState(() {
            //  _isChatbotTyping = false;
            if ((_chatbotResponseModelData.knowledgebase_response == [] ||
                    _chatbotResponseModelData
                            .knowledgebase_response["insights"] ==
                        []) &&
                _chatbotResponseModelData.intent == "insights") {
              print("rakshit");
              ChatbotResponseModel _chatbotResponseEmpty = ChatbotResponseModel(
                  knowledgebase_response: [],
                  intent: "chat",
                  chat_response:
                      "Sorry, NeoGPT is only capable of answering questions related to real-time insights on Indian stocks and crypto. But do come back soon I am being trained on more data as we speak.",
                  isuserResponse: false);

              _chatResponseList.insert(0, _chatbotResponseEmpty);
            } else {
              // print("rakshit1");
              _chatResponseList.insert(0, _chatbotResponseModelData);
              // print(_chatResponseList[0]["intent"]);
              setState(() {
                iswaiting = false;
              });
            }

            // _chatMessages.insert(0, chatbotMessage);

            // _questionHintList.clear();
            // print(_chatbotResponseModelData.followUpQs);
            // _questionHintList.addAll(_chatbotResponseModelData.followUpQs);
            // _questionHintList.removeWhere((item) => item.isEmpty);
          });
        } else {
          throw Exception("${value.statusCode} & ${value.body}");
        }
      });
    } catch (e) {
      print(e);
      print("here");
      _messageController.clear();

      // ChatMessage _chatbotMessage = ChatMessage(
      //   text:
      //       "Wow, what a treat. A break from answering tedious questions. Neo is being rebooted, please stay tuned :)",
      //   isChatbot: true,
      //   isLastQuestion: true,
      // );
      // setState(() {
      //   _isChatbotTyping = false;
      //   // _chatMessages.insert(0, _chatbotMessage);
      //   _chatResponseList.insert(0, _chatbotResponseErr);
      //   print("erros");
      // });
    }
  }

  @override
  void initState() {
    _messageController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_scrollController.hasClients) {
      Timer(
        Duration(milliseconds: 100),
        () => _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 500),
            curve: Curves.decelerate),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: 300,
                  decoration: BoxDecoration(
                      boxShadow: glowBoxShadow, color: Colors.black87),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Text(
                          "+ New Chat",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 0.50,
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.white70),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      LeftNavButtonWidget(
                          iconData: Icons.delete_outline_outlined,
                          textData: "Clear Conversation"),
                      SizedBox(
                        height: 10,
                      ),
                      LeftNavButtonWidget(
                          iconData: Icons.nightlight_outlined,
                          textData: "Dark Mode"),
                      SizedBox(
                        height: 10,
                      ),
                      LeftNavButtonWidget(
                          iconData: Icons.ios_share_sharp,
                          textData: "Update & FAQ"),
                      SizedBox(
                        height: 10,
                      ),
                      LeftNavButtonWidget(
                          iconData: Icons.exit_to_app, textData: "Log out"),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(52, 53, 64, 1)),
                  child: Column(
                    children: [
                      Expanded(
                        child: BlocBuilder<ChatConversationCubit,
                                ChatConversationState>(
                            builder: (context, chatConversationState) {
                          if (chatConversationState is ChatConversationLoaded) {
                            final chatMessages =
                                chatConversationState.chatMessages;

                            if (chatMessages.isEmpty) {
                              return ExampleWidget(
                                onMessageController: (message) {
                                  setState(() {
                                    _messageController.value =
                                        TextEditingValue(text: message);
                                  });
                                },
                              );
                            } else {
                              return Container(
                                child: ListView.builder(
                                  itemCount: _calculateListItemLength(
                                      chatMessages.length),
                                  controller: _scrollController,
                                  itemBuilder: (context, index) {
                                    if (index >= chatMessages.length &&
                                        iswaiting) {
                                      return _responsePreparingWidget();
                                    } else {
                                      return ChatMessageSingleItem(
                                    //    model: _chatResponseList[0],
                                        chatMessage: chatMessages[index],
                                      );
                                    }
                                  },
                                ),
                              );
                            }
                          }
                          return ExampleWidget(
                            onMessageController: (message) {
                              setState(() {
                                _messageController.value =
                                    TextEditingValue(text: message);
                              });
                            },
                          );
                        }),
                      ),
                      CustomTextField(
                        isRequestProcessing: _isRequestProcessing,
                        textEditingController: _messageController,
                        onTap: () async {
                          _sendMessage();
                          _promptTrigger();
                        },
                      ),
                      // Container(
                      //   margin: EdgeInsets.symmetric(horizontal: 90),
                      //   child: Text(
                      //     "ChatGPT Jan 30 Version. Free Research Preview. Our goal is to make AI systems more natural and safe to interact with. Your feedback will help us improve.",
                      //     style: TextStyle(color: Colors.grey, fontSize: 13),
                      //   ),
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }

  int _calculateListItemLength(int length) {
    if (_isRequestProcessing == false) {
      return length;
    } else {
      return length + 1;
    }
  }

  Widget _responsePreparingWidget() {
    return Container(
      height: 60,
      child: Image.asset("assets/loading_response.gif"),
    );
  }

  void _promptTrigger() {
    if (_messageController.text.isEmpty) {
      return;
    }

    final humanChatMessage = ChatMessageEntity(
      messageId: ChatGptConst.Human,
      queryPrompt: _messageController.text,
    );

    BlocProvider.of<ChatConversationCubit>(context)
        .chatConversation(
            chatMessage: humanChatMessage,
            onCompleteReqProcessing: (isRequestProcessing) {
              setState(() {
                _isRequestProcessing = isRequestProcessing;
              });
            })
        .then((value) {
          
      setState(() {
        _messageController.clear();
      });
      if (_scrollController.hasClients) {
        Timer(
          Duration(milliseconds: 100),
          () => _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 500),
              curve: Curves.decelerate),
        );
      }
    });
  }
}
