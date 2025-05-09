// import 'dart:typed_data';

// import 'package:firebase_chat/firebase_chat.dart';
// import 'package:flutter/material.dart';
// import 'package:huops/constants/app_colors.dart';
// import 'package:huops/requests/chat.request.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';

// class ChatBody extends BaseChat {
//   ChatBody({
//     required ChatEntity entity,
//   }) : super(entity);

//   @override
//   _ChatBodyState createState() => _ChatBodyState();
// }

// class _ChatBodyState extends BaseChatState<ChatBody> {
//   @override
//   Color get primaryColor => AppColor.primaryColor;

//   @override
//   Color get secondaryColor => AppColor.primaryColorDark;

//   @override
//   Widget get loadingWidget => Center(
//         child: Padding(
//           padding: const EdgeInsets.all(30.0),
//           child: CircularProgressIndicator(),
//         ),
//       );

//   @override
//   Widget get emptyWidget => Center(
//         child: Padding(
//           padding: const EdgeInsets.all(40.0),
//           child: Text(
//             "Welcome".tr(),
//           ),
//         ),
//       );

//   @override
//   Widget errorWidget(String url) {
//     return Center(
//       child: Text(
//         "Something wrong".tr(),
//       ),
//     );
//   }

//   @override
//   Widget inputBuilder(BuildContext context, ChatInputState state) {
//     return SafeArea(
//       bottom: true,
//       top: false,
//       child: Container(
//         color: Colors.white,
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: <Widget>[
//             Expanded(
//               child: Container(
//                 padding: EdgeInsets.all(10),
//                 child: TextField(
//                   onSubmitted: (text) {
//                     if (text.isNotEmpty) sendChatMessage(text);
//                   },
//                   autofocus: false,
//                   maxLines: null,
//                   keyboardType: TextInputType.text,
//                   style: TextStyle(fontSize: 20.0, color: Colors.black),
//                   controller: textEditingController,
//                   onChanged: inputChanged,
//                   decoration: InputDecoration.collapsed(
//                     hintText: "Type here".tr(),
//                     hintStyle: TextStyle(color: Colors.grey),
//                   ),
//                 ),
//               ),
//             ),

//             // Send message button
//             Material(
//               child: new Container(
//                 margin: new EdgeInsets.only(right: 4.0),
//                 child: new IconButton(
//                   icon: new Icon(Icons.send),
//                   onPressed: state is ReadyToSendState
//                       ? () => sendChatMessage(textEditingController.text)
//                       : null,
//                   color: primaryColor,
//                   disabledColor: Colors.grey,
//                 ),
//               ),
//               color: Colors.white,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Future editAndUpload(Uint8List data) {
//     //
//     throw UnimplementedError();
//   }

//   @override
//   Future getImage() {
//     //
//     throw UnimplementedError();
//   }

//   //
//   ChatRequest chatRequest = ChatRequest();
//   sendChatMessage(String message) async {
//     super.sendMessage();
//     //notify the involved party
//     final chatEntity = widget.entity;
//     final otherPeerKey = chatEntity.peers.keys.firstWhere(
//       (peerKey) => chatEntity.mainUser.documentId != peerKey,
//     );
//     final otherPeer = chatEntity.peers[otherPeerKey];

//     final apiResponse = await chatRequest.sendNotification(
//       title: "New Message from".tr() + " ${chatEntity.mainUser.name}",
//       body: message,
//       topic: otherPeer.documentId,
//       path: chatEntity.path,
//       user: chatEntity.mainUser,
//       otherUser: otherPeer,
//     );

//     print("Result ==> ${apiResponse.body}");
//   }
// }
