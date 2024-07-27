# Flutter Langchain Example App

เริ่มต้นสร้าง Flutter AI Application ด้วย LangChain.dart

## 🦜️🔗 สร้างด้วยแอปพลิเคชั่นด้วย LangChain.dart

LangChain เป็น service ที่ใช้โมดูลหลายรูปแบบในการสร้าง Application ได้อย่างง่าย ๆ สามารถใช้งานสำหรับ Application ง่ายๆ หรืองานที่ต้องการความซับซ้อน โดยที่ LangChain จะใช้ภาษา Expression Language (LCEL) ในการเชื่อมต่อ LLM โมดูลต่าง ๆ  ซึ่งกำหนดโดยให้มีอินเทอร์เฟซ  `Runnable` ที่เป็นรูปแบบเดียวกัน ทำให้การเชื่อมต่อได้อย่างราบรื่นมากยิ่งขึ้น

รูปแบบการใช้ต่าง ๆ

1.  **LLM/Chat Model:** โมเดลภาษาเป็นหัวใจของการคิดเชิงพื้นฐานที่นี่ ในการทำงานกับ LangChain คุณจำเป็นต้องเข้าใจเกี่ยวกับประเภทต่าง ๆ ของโมเดลภาษาและวิธีการทำงานกับพวกเขา

2.  **Prompt Template:** ให้คำแนะนำกับโมเดลภาษานั่นเอง ส่วนควบคุมว่าโมเดลภาษาจะส่งออกอย่างไร ดังนั้นการเข้าใจวิธีการสร้างคำแนะนำและกลยุทธ์ในการให้คำแนะนำที่แตกต่างกันจึงเป็นสิ่งสำคัญ

4.  **Output Parser:** แปลงคำตอบต้นฉบับจากโมเดลภาษาเป็นรูปแบบที่ใช้งานได้ง่ายขึ้น ทำให้ง่ายต่อการใช้งานคำตอบที่ได้ด้านล่าง


## LLM/Chat Model
โมเดลภาษามี 2 ประเภท
- `LLM:` โมเดลพื้นฐานรับข้อความ (String)เป็นอินพุตและส่งกลับข้อความ (String)
- `ChatModel:` โมเดลพื้นฐานรับรายการข้อความเป็นอินพุตและส่งคืนข้อความ

ข้อความพื้นฐานถูกกำหนดโดย ChatMessage ซึ่งมีคุณลักษณะ (Attribute) ที่จำเป็น 2 รายการ

- `content:` เนื้อหาของข้อความ(Message) มักจะเป็นสตริง (String)
- `role:` คือลักษณะเฉพาะ (Entity) ที่ ChatMessage ส่งมา
  
LangChain มี Object มากมายเพื่อแยกแยะความแตกต่างระหว่างบทบาทที่แตกต่างกันได้อย่างง่ายดาย

- `HumanChatMessage` : `ChatMessage` มาจากมนุษย์/ผู้ใช้
- `AIChatMessage` : `ChatMessage` มาจาก AI/ผู้ช่วย
- `SystemChatMessage` : `ChatMessage`  มาจากระบบ
- `FunctionChatMessage`/ `ToolChatMessage` : `ChatMessage` ที่มีเอาต์พุตของการเรียกใช้ฟังก์ชันหรือการเรียกใช้เครื่องมือ

หากไม่มีบทบาทใดที่ถูกต้อง ก็ยังมี `CustomChatMessage` คลาสที่สามารถระบุบทบาทด้วยตนเองได้


LangChain มีอินเทอร์เฟซทั่วไปที่ใช้ร่วมกันโดยทั้ง `LLMs` และ `ChatModels` อย่างไรก็ตาม การทำความเข้าใจความแตกต่างเพื่อสร้างคำแนะนำสำหรับโมเดลภาษาที่กำหนดได้อย่างมีประสิทธิภาพสูงสุดจะเป็นประโยชน์

วิธีที่ง่ายที่สุดในการเรียก `LLM` หรือ `ChatModel` คือการใช้ `.invoke()` วิธีการเรียกพื้นฐานสำหรับ LangChain Expression Language (LCE) 


`LLM.invoke` : รับค่าสตริง ส่งคืนสตริง
`ChatModel.invoke` : รับรายการ ChatMessage ส่งคืน ChatMessage


## Prompt templates
แอปพลิเคชัน LLM ส่วนใหญ่จะไม่ผ่านการป้อนข้อมูลของผู้ใช้โดยตรงไปยังไฟล์ `LLM` โดยปกติแล้วจะเพิ่มการป้อนข้อมูลของผู้ใช้ลงในข้อความขนาดใหญ่ที่เรียกว่า Prompt templates ที่ให้บริบทเพิ่มเติมเกี่ยวกับงานเฉพาะที่มีอยู่

_Example_
  
```
final prompt = PromptTemplate.fromTemplate(
  'What is a good name for a company that makes {product}?',
);

final res = prompt.format({'product': 'colorful socks'});
print(res);
// 'What is a good name for a company that makes colorful socks?'

```

## Output Parser
`Output Parsers` คือ เครื่องมือที่แปลงผลลัพธ์ของ LLM จากรูปแบบของข้อความเป็นรูปแบบที่สามารถนำไปใช้งานได้ต่อไป 

มีประเภทหลักๆ ของ `Output Parsers ` ดังนี้

- แปลงข้อความจาก LLM -> ข้อมูลโครงสร้าง (เช่น JSON)
- แปลงข้อความ ChatMessage เป็น string เพียงอย่างเดียว
- แปลงข้อมูลเพิ่มเติมที่ส่งคืนจากการเรียกใช้ฟังก์ชันนอกเหนือจากข้อความ (เช่น OpenAI function invocation) เป็น string สำหรับข้อมูลเพิ่มเติมเกี่ยวกับนี้ ดูในส่วนเกี่ยวกับ output parsers

_Example_

```
class CommaSeparatedListOutputParser 
    extends BaseOutputParser<ChatResult, OutputParserOptions, List<String>> {
  
  const CommaSeparatedListOutputParser()
      : super(defaultOptions: const OutputParserOptions());

  @override
  Future<List<String>> invoke(
      final ChatResult input, {
      final OutputParserOptions? options,
  }) async {
    final message = input.output;
    return message.content.trim().split(',');
  }
}

```

## Dart packages

- [langchain](https://pub.dev/packages/langchain) Build LLM-powered Dart/Flutter applications
- [langchain_openai](https://pub.dev/packages/langchain) OpenAI module for LangChain.dart
- [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) Load configuration at runtime from a .env file

## Reference
Reference content from [langchaindart.dev](https://langchaindart.dev)
