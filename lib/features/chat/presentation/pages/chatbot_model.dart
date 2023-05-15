// To parse this JSON data, do
//
//     final chatbotResponseModel = chatbotResponseModelFromJson(jsonString);

import 'dart:convert';

ChatbotResponseModel chatbotResponseModelFromJson(String str) =>
    ChatbotResponseModel.fromJson(json.decode(str));

String chatbotResponseModelToJson(ChatbotResponseModel data) =>
    json.encode(data.toJson());

class ChatbotResponseModel {
  ChatbotResponseModel({
    required this.knowledgebase_response,
    required this.intent,
    required this.chat_response,
    required this.isuserResponse,
  });

  final dynamic knowledgebase_response;
  final String intent;
  final String chat_response;
  final bool isuserResponse;
  // final List<String> images;

  factory ChatbotResponseModel.fromJson(Map<String, dynamic> json) =>
      ChatbotResponseModel(
        intent: json["intent"],
        chat_response: json["chat_response"],
        knowledgebase_response: json["knowledgebase_response"],
        isuserResponse: false,
      );

  Map<String, dynamic> toJson() => {
        "intent": intent,
        "chat_response": chat_response,
        "knowledgebase_response": knowledgebase_response,
        "isuserResponse": isuserResponse,
      };
}

class userResponseModel {
  userResponseModel({required this.text});
  final String text;
  final bool isuserResponse = true;
}
