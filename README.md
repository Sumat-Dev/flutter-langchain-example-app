# Flutter Langchain Example App
เริ่มต้น LLM applications ด้วย LangChain.dart (Openai)

## 🦜️🔗 สร้างด้วยแอปพลิเคชั่นด้วย LangChain.dart
LangChain มีโมดูลมากมายที่สามารถใช้ในการสร้างแอปพลิเคชันโมเดลภาษาได้ โมดูลสามารถใช้เป็นแบบสแตนด์อโลนในแอปพลิเคชันที่เรียบง่าย และสามารถประกอบขึ้นสำหรับกรณีการใช้งานที่ซับซ้อนมากขึ้น องค์ประกอบขับเคลื่อนโดย LangChain Expression Language (LCEL) ซึ่งกำหนดอินRunnableเทอร์เฟซแบบรวมที่โมดูลจำนวนมากใช้งาน ทำให้สามารถเชื่อมโยงส่วนประกอบต่างๆ ได้อย่างราบรื่น

ส่วนประกอบหลัก 3 อย่าง คือ
- LLM/Chat Model: โมเดลภาษาเป็นเครื่องมือการให้เหตุผลหลักที่นี่ เพื่อที่จะทำงานร่วมกับ LangChain คุณต้องเข้าใจโมเดลภาษาประเภทต่างๆ และวิธีการทำงานกับโมเดลภาษาเหล่านั้น
- Prompt Template : นี่เป็นคำแนะนำสำหรับโมเดลภาษา วิธีนี้จะควบคุมผลลัพธ์ของโมเดลภาษา ดังนั้นการทำความเข้าใจวิธีสร้างพรอมต์และกลยุทธ์การกระตุ้นเตือนที่แตกต่างกันจึงเป็นสิ่งสำคัญ
- Output Parser: สิ่งเหล่านี้แปลการตอบสนองดิบจากโมเดลภาษาไปเป็นรูปแบบที่ใช้งานได้มากขึ้น ทำให้ง่ายต่อการใช้เอาท์พุตดาวน์สตรีม
ในคู่มือนี้ เราจะอธิบายองค์ประกอบทั้งสามดังกล่าวทีละรายการ จากนั้นอธิบายวิธีรวมองค์ประกอบเหล่านั้น การทำความเข้าใจแนวคิดเหล่านี้จะทำให้คุณพร้อมสำหรับการใช้งานและปรับแต่งแอปพลิเคชัน LangChain ได้ แอปพลิเคชัน LangChain ส่วนใหญ่อนุญาตให้คุณกำหนดค่าโมเดลและ/หรือพร้อมต์ได้ ดังนั้นการรู้วิธีใช้ประโยชน์จากสิ่งนี้จะเป็นประโยชน์อย่างมาก

### :postbox: LLM/Chat Model
โมเดลภาษามี 2 ประเภท

- LLM: โมเดลพื้นฐานรับสตริงเป็นอินพุตและส่งกลับสตริง
- ChatModel: โมเดลพื้นฐานรับรายการข้อความเป็นอินพุตและส่งคืนข้อความ

ข้อความพื้นฐานถูกกำหนดโดย ChatMessage ซึ่งมีแอตทริบิวต์ที่จำเป็น 2 รายการ

- content: เนื้อหาของข้อความ มักจะเป็นสตริง
- role: เอนทิตีที่ChatMessageมา
  
LangChain มี Object มากมายเพื่อแยกแยะความแตกต่างระหว่างบทบาทที่แตกต่างกันได้อย่างง่ายดาย

- HumanChatMessage: ChatMessage มาจากมนุษย์/ผู้ใช้
- AIChatMessage: ChatMessage  มาจาก AI/ผู้ช่วย
- SystemChatMessage: ChatMessage  มาจากระบบ
- FunctionChatMessage/ ToolChatMessage: A ChatMessage ที่มีเอาต์พุตของการเรียกใช้ฟังก์ชันหรือการเรียกใช้เครื่องมือ

หากไม่มีบทบาทใดที่ฟังดูถูกต้อง ก็ยังมี CustomChatMessage คลาสที่คุณสามารถระบุบทบาทด้วยตนเองได้


LangChain มีอินเทอร์เฟซทั่วไปที่ใช้ร่วมกันโดยทั้ง LLMs และ ChatModels อย่างไรก็ตาม การทำความเข้าใจความแตกต่างเพื่อสร้างคำแนะนำสำหรับโมเดลภาษาที่กำหนดได้อย่างมีประสิทธิภาพสูงสุดจะเป็นประโยชน์

วิธีที่ง่ายที่สุดในการเรียก  LLM หรือ ChatModel คือการใช้ .invoke() วิธีการเรียกพื้นฐานสำหรับ LangChain Expression Language (LCE) 



```
LLM.invoke: รับค่าสตริง ส่งคืนสตริง
ChatModel.invoke: รับรายการ ChatMessage ส่งคืน ChatMessage
```

### :calendar: Prompt templates
แอปพลิเคชัน LLM ส่วนใหญ่ไม่ผ่านการป้อนข้อมูลของผู้ใช้โดยตรงไปยังไฟล์ LLM โดยปกติแล้วพวกเขาจะเพิ่มการป้อนข้อมูลของผู้ใช้ลงในข้อความขนาดใหญ่ที่เรียกว่าเทมเพลตพร้อมท์ที่ให้บริบทเพิ่มเติมเกี่ยวกับงานเฉพาะที่มีอยู่

*example*
  
```
final prompt = PromptTemplate.fromTemplate(
  'What is a good name for a company that makes {product}?',
);
final res = prompt.format({'product': 'colorful socks'});
print(res);
// 'What is a good name for a company that makes colorful socks?'

```

## :mortar_board: Dart packages

 - [langchain](https://pub.dev/packages/langchain) Build LLM-powered Dart/Flutter applications

 - [langchain_openai](https://pub.dev/packages/langchain) OpenAI module for LangChain.dart

 - [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) Load configuration at runtime from a .env file

> หมายเหตุ langchain: ^0.6.0 ยังสนันสนุน LLM ประมาณแค่ 3-4 ตัวหลัก ๆ เท่านั้น ซึ่งยังน้อยมากหากเทียบกับ python

## :foggy: Main Screen

<img src="https://github.com/Sumat-Dev/Flutter-langchain-example-app/blob/main/main.png" style="height: auto; width:300px;"/>


> Reference content from [LangChain.dart](https://langchaindart.com/#/)
