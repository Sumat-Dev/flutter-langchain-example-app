import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';

class PromptTemplates extends StatefulWidget {
  const PromptTemplates({super.key});

  @override
  State<PromptTemplates> createState() => _PromptTemplatesState();
}

class _PromptTemplatesState extends State<PromptTemplates> {
  final openaiApiKey = dotenv.env['OPENAI_API_KEY'];
  final _textController = TextEditingController();
  String output = '';

  Future<void> _templateGoodNameProduct(String text) async {
    final openai = OpenAI(apiKey: openaiApiKey);

    final prompt = PromptTemplate.fromTemplate(
      'What is a good name for a company that makes {product}?',
    );

    final promptTemplate = prompt.format({'product': text});
    //// 'What is a good name for a company that makes {____}?'

    try {
      final res = await openai.invoke(PromptValue.string(promptTemplate));
      setState(() {
        output = res.output;
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
      appBar: AppBar(title: const Text('Prompt templates')),
      body: Container(
        color: Colors.grey.shade300,
        padding: const EdgeInsets.all(20),
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'In the previous example, the text we passed to the model contained instructions to generate a company name. For our application, it would be great if the user only had to provide the description of a company/product, without having to worry about giving the model instructions.'),
              const SizedBox(height: 20),
              const Text(
                'Prompt',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Text('What is a good name for a company that makes?'),
              const SizedBox(height: 10),
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  labelText: 'your product',
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () =>
                      _templateGoodNameProduct(_textController.text),
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
}
