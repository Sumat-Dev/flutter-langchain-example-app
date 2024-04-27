import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';

class ChatPromptTemplateScreen extends StatefulWidget {
  const ChatPromptTemplateScreen({super.key});

  @override
  State<ChatPromptTemplateScreen> createState() => _ChatPromptTemplateState();
}

class _ChatPromptTemplateState extends State<ChatPromptTemplateScreen> {
  final openaiApiKey = dotenv.env['OPENAI_API_KEY'];
  final _textController = TextEditingController();
  String output = '';

  List<String> languageItems = [
    'English',
    'French',
    'Spanish',
    'German',
    'Thai'
  ];

  String inputLanguage = 'English';
  String outputLanguage = 'French';

  void _translatesText(String text) async {
    final openai = OpenAI(apiKey: openaiApiKey);

    const template =
        'You are a helpful assistant that translates {input_language} to {output_language}.';
    const humanTemplate = '{text}';

    final chatPrompt = ChatPromptTemplate.fromTemplates(const [
      (ChatMessageType.system, template),
      (ChatMessageType.human, humanTemplate),
    ]);

    final setMessage = chatPrompt.formatMessages({
      'input_language': inputLanguage,
      'output_language': outputLanguage,
      'text': text,
    });
    // [
    //   SystemChatMessage(content='You are a helpful assistant that translates ___ to ___.'),
    //   HumanChatMessage(content='_____')
    // ]

    try {
      final res = await openai.invoke(PromptValue.chat(setMessage));
      setState(() {
        output = res.output.toString();
      });
    } catch (e) {
      print('Error: $e');
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
      appBar: AppBar(title: const Text('Chat Prompt Template')),
      body: Container(
        color: Colors.grey.shade300,
        padding: const EdgeInsets.all(20),
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Prompt : System is translates',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              buildLanguageDropdown(inputLanguage, (String? newValue) {
                setState(() {
                  inputLanguage = newValue!;
                });
              }),
              const SizedBox(height: 10),
              const Text('TO'),
              const SizedBox(height: 10),
              buildLanguageDropdown(outputLanguage, (String? newValue) {
                setState(() {
                  outputLanguage = newValue!;
                });
              }),
              const SizedBox(height: 20),
              const Text('Enter your text'),
              const SizedBox(height: 10),
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  labelText: 'your text',
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => _translatesText(_textController.text),
                  child: const Text('Submit'),
                ),
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

  Widget buildLanguageDropdown(String value, void Function(String?) onChanged) {
    return DropdownButton<String>(
      value: value,
      onChanged: onChanged,
      items: languageItems.map((String language) {
        return DropdownMenuItem<String>(
          value: language,
          child: Text(language),
        );
      }).toList(),
    );
  }
}
