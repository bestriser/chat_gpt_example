import 'package:chat_gpt_api/chat_gpt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ChatGPT Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Flutter ChatGPT Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _prompt = '';
  String _answer = '';

  void _inputPrompt(String prompt) {
    setState(() => _prompt = prompt);
  }

  void _inputAnswer(String answer) {
    setState(() => _answer = answer);
  }

  @override
  Widget build(BuildContext context) {
    final chatGpt = ChatGPT.builder(token: dotenv.env['CHAT_GPT_TOKEN'] ?? '');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                decoration: const InputDecoration(hintText: '質問を入力してください'),
                onChanged: _inputPrompt,
                minLines: 1,
                maxLines: 10,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                _inputAnswer('回答中...');
                final completion = await chatGpt.textCompletion(
                  request: CompletionRequest(
                    prompt: _prompt,
                    maxTokens: 256,
                  ),
                );
                _inputAnswer(completion?.choices?.first.text ?? '');
              },
              child: const Text('質問する'),
            ),
            Visibility(
              visible: _answer.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(border: Border.all()),
                  child: Text('回答：$_answer'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
