import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';

class LLMAndChatModel extends StatefulWidget {
  const LLMAndChatModel({super.key});

  @override
  State<LLMAndChatModel> createState() => _LLMAndChatModelState();
}

class _LLMAndChatModelState extends State<LLMAndChatModel> {
  final openaiApiKey = dotenv.env['OPENAI_API_KEY'];
  final _textController = TextEditingController();
  String output = '';

  Future<void> _invokeLLM(String text) async {
    final llm = OpenAI(apiKey: openaiApiKey);

    try {
      final res = await llm.invoke(PromptValue.string(text));
      setState(() {
        output = res.output;
      });
    } catch (e) {
      print('Error invoking LLM: $e');
    }
  }

  Future<void> _invokeChatModel(String text) async {
    final chatModel = ChatOpenAI(apiKey: openaiApiKey);
    final messages = [ChatMessage.humanText(text)];

    try {
      final res = await chatModel.invoke(PromptValue.chat(messages));
      setState(() {
        output = res.output.toString();
      });
    } catch (e) {
      print('Error invoking Chat Model: $e');
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LLM/ChatModel')),
      body: Container(
        color: Colors.grey.shade300,
        padding: const EdgeInsets.all(20),
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  "Let's see how to work with these different types of models and these different types of inputs. First, let's import an LLM and a ChatModel."),
              const SizedBox(height: 20),
              const Text(
                'Prompt',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  labelText: 'your messages',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _invokeLLM(_textController.text),
                child: const Text('invoke LLM'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _invokeChatModel(_textController.text),
                child: const Text('invoke ChatModel'),
              ),
              const SizedBox(height: 20),
              Container(
                color: Colors.grey.shade100,
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Text('output is: $output'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
