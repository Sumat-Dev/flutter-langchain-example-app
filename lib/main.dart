import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/chat_prompt_template.dart';
import 'app/llm_and_chat_model.dart';
import 'app/prompt_templates.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LangChain.dart')),
      body: Container(
        color: Colors.grey.shade300,
        padding: const EdgeInsets.all(20),
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLLMChatModelSection(context),
              const SizedBox(height: 20),
              _buildPromptTemplatesSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLLMChatModelSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'LLM / Chat Model',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        const Text('There are two types of language models'),
        const SizedBox(height: 10),
        const Text(
            ' - LLM: underlying model takes a string as input and returns a string.'),
        const SizedBox(height: 10),
        const Text(
            ' - ChatModel: underlying model takes a list of messages as input and returns a message.'),
        const SizedBox(height: 20),
        _buildLLMAndChatModelButton(context),
      ],
    );
  }

  Widget _buildLLMAndChatModelButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LLMAndChatModel(),
        ),
      ),
      child: const Text('LLM / Chat Model'),
    );
  }

  Widget _buildPromptTemplatesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prompt templates',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
            'Most LLM applications do not pass user input directly into an LLM. Usually they will add the user input to a larger piece of text, called a prompt template, that provides additional context on the specific task at hand.'),
        const SizedBox(height: 20),
        _buildPromptTemplatesButton(context),
        const SizedBox(height: 20),
        const Text(
            'PromptTemplates can also be used to produce a list of messages. In this case, the prompt not only contains information about the content, but also each message (its role, its position in the list, etc) Here, what happens most often is a ChatPromptTemplate'),
        const SizedBox(height: 20),
        _buildChatPromptTemplateButton(context)
      ],
    );
  }

  Widget _buildPromptTemplatesButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PromptTemplates(),
        ),
      ),
      child: const Text('Prompt Templates'),
    );
  }

  Widget _buildChatPromptTemplateButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChatPromptTemplateScreen(),
        ),
      ),
      child: const Text('Chat Prompt Template'),
    );
  }
}
