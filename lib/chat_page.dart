import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_prj/ai_message.dart';
import 'package:flutter_prj/human_message.dart';
import 'package:flutter_svg/svg.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _chatController = TextEditingController();
  final gemini = Gemini.instance;
  List<Content> _chatList = [];

  void handleNewChat(String newChat) async {
    setState(() {
      _chatList = [
        ..._chatList,
        Content(
          role: 'user',
          parts: [
            Part.text(newChat),
          ],
        ),
      ];
    });
    _chatController.clear();
    final aiResponse = await gemini.chat(_chatList);
    debugPrint('airesponse.output: ${aiResponse?.output}');
    setState(() {
      _chatList = [
        ..._chatList,
        Content(
          role: 'model',
          parts: [
            Part.text(aiResponse?.output ?? 'No Response'),
          ],
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: const Border(
          bottom: BorderSide(
            color: Color(0xFF656565),
            width: 1,
          ),
        ),
        backgroundColor: Color(0xff8A2BE2),
        title: Text(
          'Gemini 챗봇',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            height: 22 / 17,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 32,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final part = _chatList[index].parts?.first;
                  return _chatList[index].role == 'model'
                      ? AIMessage(
                          message:
                              part is TextPart ? part.text : 'null message')
                      : HumanMessage(
                          message:
                              part is TextPart ? part.text : 'null message');
                },
                separatorBuilder: (context, index) => SizedBox(height: 24),
                itemCount: _chatList.length,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      height: 24 / 14,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      fillColor: Color(0xFFF7F7FC),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      hintText: '채팅을 시작해보세요.',
                    ),
                    onSubmitted: handleNewChat,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => handleNewChat(_chatController.text),
                  icon: SvgPicture.asset('assets/icons/send-chat.svg'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
