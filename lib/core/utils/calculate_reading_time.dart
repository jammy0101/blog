
//he purpose = to calculate and show an estimated reading time to the reader,
// making your app feel more professional and user-focused.
//Average adult reading speed ≈ 225 words per minute.
// readingTime = wordCount / 225;

int calculateReadingTime(String content) {
  final wordCount = content.trim().split(RegExp(r'\s+')).length;
  final readingTime = wordCount / 225; // wordCount ÷ 225
  return readingTime.ceil(); // round up (better UX)
}

