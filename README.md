# LearnHub — Flutter ব্যবহারিক পরীক্ষা

স্বাগতম! এই পরীক্ষায় আপনি একটা আংশিক বানানো Flutter অ্যাপে তিনটা কাজ করবেন। মোট নম্বর **৪০**।

## কাজের তালিকা

- [ ] **কাজ ১** — কোর্স কার্ড সুন্দর করা (১০ নম্বর) → [বিস্তারিত](#৪-কাজ-১--কোর্স-কার্ড-সুন্দর-করা-১০-নম্বর)
- [ ] **কাজ ২** — ক্যাটাগরি ফিল্টার ঠিক করা (১০ নম্বর) → [বিস্তারিত](#৫-কাজ-২--ক্যাটাগরি-ফিল্টার-ঠিক-করা-১০-নম্বর)
- [ ] **কাজ ৩** — কোর্স ডিটেইল পেজ বানানো (২০ নম্বর) → [বিস্তারিত](#৬-কাজ-৩--কোর্স-ডিটেইল-পেজ-বানানো-২০-নম্বর)
- [ ] **বোনাস** — দাম `0` হলে "Free" ব্যাজ (মূল ৪০-এর বাইরে)

---

## ১. অ্যাপ পরিচিতি

LearnHub একটা ছোট e-learning অ্যাপ। এখন এতে শুধু কোর্সের তালিকা আছে:

- উপরে ক্যাটাগরির chip (All, Programming, Design ...)
- নিচে কোর্সের কার্ড

ডাটা আসে একটা REST API থেকে, যেটা [json-server](https://github.com/typicode/json-server) দিয়ে চলছে।

প্রজেক্টের কাঠামো:

```
lib/
├── main.dart
├── config/api_config.dart      # API-র ঠিকানা (baseUrl)
├── models/                     # Course, Category
├── services/api_service.dart   # সব API কল
├── screens/course_list_screen.dart
└── widgets/course_card.dart
```

এই প্রজেক্টে কোনো state management প্যাকেজ (Provider, Bloc, GetX ইত্যাদি) নেই। শুধু `StatefulWidget`, `setState` আর `FutureBuilder` ব্যবহার করা হয়েছে। আপনিও এভাবেই কাজ করবেন, নতুন কোনো প্যাকেজ যোগ করবেন না।

---

## ২. চালানোর নিয়ম

1. API চালু করুন। API আলাদা repo-তে আছে: https://github.com/medigeneit/assignment-learnhub-api-by-json-server
   ```bash
   git clone https://github.com/medigeneit/assignment-learnhub-api-by-json-server.git
   cd assignment-learnhub-api-by-json-server
   npm install
   npm start
   ```
   (Node.js 18 বা তার বেশি লাগবে।) টার্মিনালটা খোলা রাখুন, তারপর ব্রাউজারে http://localhost:3000/courses খুলে দেখুন ডাটা আসছে কিনা।
2. `lib/config/api_config.dart` খুলে দেখুন `baseUrl` আপনার ডিভাইসের জন্য ঠিক আছে কিনা:
   - Android emulator: `http://10.0.2.2:3000` (আগে থেকেই দেওয়া)
   - iOS simulator: `http://localhost:3000`
   - আসল ফোন: যে কম্পিউটারে API চলছে তার IP, যেমন `http://192.168.0.105:3000` (ফোন আর কম্পিউটার একই Wi-Fi-তে থাকতে হবে)
3. টার্মিনালে:
   ```bash
   flutter pub get
   flutter run
   ```

অ্যাপ খুললে কোর্সের তালিকা দেখা যাওয়ার কথা। না দেখালে পরীক্ষককে জানান।

---

## ৩. API

| Method | পাথ | কী দেয় |
|---|---|---|
| GET | `/categories` | সব ক্যাটাগরি |
| GET | `/courses` | সব কোর্স |
| GET | `/courses/{id}` | একটা নির্দিষ্ট কোর্স, যেমন `/courses/3` |
| GET | `/lessons` | সব লেসন |

json-server-এর দুটো সুবিধা মনে রাখুন:

- **ফিল্টার:** যেকোনো ফিল্ড দিয়ে ফিল্টার করা যায় — `?fieldName=value`। যেমন `/lessons?title=Joining Tables`
- **সাজানো:** `?_sort=field` দিয়ে সাজানো যায়। দুটো একসাথেও দেওয়া যায় `&` দিয়ে।

কাজ শুরু করার আগে ব্রাউজারে প্রতিটা endpoint খুলে দেখে নিন কোন ফিল্ডের নাম কী।

---

## ৪. কাজ ১ — কোর্স কার্ড সুন্দর করা (১০ নম্বর)

ফাইল: `lib/widgets/course_card.dart`

এখন কার্ডটা একদম সাধারণ: লেখাগুলো কিনারায় লেগে আছে, লম্বা summary পুরোটা দেখায়, সব লেখা একই রকম। নিচের মতো করে সাজান:

| অংশ | যা করতে হবে |
|---|---|
| **Title** | `fontWeight: FontWeight.bold`, `fontSize: 18`, রং `Theme.of(context).colorScheme.primary` |
| **Summary** | `fontSize: 13`, রং `Colors.grey[600]`, সর্বোচ্চ **২ লাইন** (`maxLines: 2`), বেশি হলে শেষে `...` (`overflow: TextOverflow.ellipsis`) |
| **Price** | `fontWeight: FontWeight.bold`, `fontSize: 20`, রং `Colors.green[700]`, সামনে `৳`। দাম পূর্ণসংখ্যা হলে দশমিক ছাড়া (`৳ 1200`), না হলে দুই ঘর দশমিক (`৳ 499.50`) |
| **কার্ড** | ভিতরে চারদিকে `16` padding, কোণ গোল (`RoundedRectangleBorder`, radius `12`), কার্ডগুলোর মাঝে ফাঁকা জায়গা |
| **নিচের সারি** | বাঁ দিকে দাম, ডান দিকে **Details** বাটন — `FilledButton` বা `ElevatedButton` |

কার্ডে ছবি দেখানোর দরকার নেই।

---

## ৫. কাজ ২ — ক্যাটাগরি ফিল্টার ঠিক করা (১০ নম্বর)

উপরের ক্যাটাগরি chip-গুলো দেখা যায়, কিন্তু চাপলে কিছু হয় না।

ফিল্টারটা ঠিক করুন, যাতে:

- কোনো chip চাপলে সেটা সিলেক্টেড দেখায়
- শুধু ওই ক্যাটাগরির কোর্সগুলো আসে
- **All** চাপলে আবার সব কোর্স ফেরত আসে

---

## ৬. কাজ ৩ — কোর্স ডিটেইল পেজ বানানো (২০ নম্বর)

কার্ডের **Details** বাটন চাপলে একটা নতুন পেজ খুলবে, যেখানে কোর্সের বিস্তারিত দেখাবে।

> **গুরুত্বপূর্ণ:** Details বাটন থেকে শুধু কোর্সের `id` পাঠাতে হবে, আর ডিটেইল পেজ নিজে API থেকে ডাটা আনবে।
> পুরো `Course` object পাঠানো যাবে না।

যা যা লাগবে:

1. নতুন ফাইল `lib/screens/course_detail_screen.dart`, যার widget `id` নেয়, যেমন `CourseDetailScreen(courseId: 3)`
2. `Lesson` model (`lib/models/lesson.dart`) — ফিল্ডগুলো `/lessons` থেকে দেখে নিন
3. `api_service.dart`-এ দুটো নতুন মেথড:
   - `id` দিয়ে একটা কোর্স আনা → `GET /courses/{id}`
   - একটা কোর্সের লেসনগুলো আনা, `order` অনুযায়ী সাজিয়ে → `GET /lessons` (ফিল্টার আর সাজানোর নিয়ম উপরে আছে)

পেজে যা দেখাবে:

- **AppBar-এ** কোর্সের নাম, আর back বাটন (চাপলে লিস্টে ফেরত যাবে)
- **উপরে ছবি** (`thumbnail`) — `Image.network` দিয়ে; ছবি লোড হওয়ার সময় loading, আর লোড না হলে একটা বিকল্প (যেমন icon) দেখাবে
- কোর্সের **title**, **শিক্ষকের নাম**, **দাম**
- **সময়কাল** ঘণ্টা-মিনিটে, যেমন `95` মিনিট → `1h 35m`
- পুরো **description**
- তারপর **"Lessons"** শিরোনাম, তার নিচে লেসনের তালিকা ক্রম অনুযায়ী — প্রতিটায় নম্বর, নাম আর কত মিনিট
- পুরো পেজ নিচে স্ক্রল করা যাবে
- ডাটা আসার সময় `CircularProgressIndicator`
- ডাটা আনতে সমস্যা হলে error মেসেজ আর একটা **Retry** বাটন

---

## ৭. নিয়ম

- সময়: **১ ঘণ্টা ২০ মিনিট**
- Google, StackOverflow আর অফিসিয়াল ডকুমেন্টেশন (docs.flutter.dev, api.flutter.dev) ব্যবহার করতে পারবেন।
- প্রতিটা কাজ শেষে আলাদা git commit করবেন:
  - `feat: style course card`
  - `fix: category filter`
  - `feat: course detail page`
- সব কাজ শেষ না হলেও যতটুকু হয়েছে জমা দেবেন। আংশিক কাজেও নম্বর আছে।
- জমা দেওয়ার পর ছোট একটা ভাইভা হবে, যেখানে আপনার প্রতিটা পরিবর্তন নিজে ব্যাখ্যা করতে হবে।

---

## ৮. বোনাস (মূল ৪০ নম্বরের বাইরে)

যে কোর্সের দাম `0`, তার কার্ডে একটা ছোট **"Free"** ব্যাজ দেখান।

শুভকামনা!
