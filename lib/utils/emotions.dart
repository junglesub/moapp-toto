// options.dart
class MoodOption {
  final String name;
  final String category;
  final String emoji;

  MoodOption({
    required this.name,
    required this.category,
    required this.emoji,
  });

  static List<MoodOption> get moodOptions {
    return [
      MoodOption(name: "행복해요", category: "긍정", emoji: "😊"),
      MoodOption(name: "행운은 나의 편", category: "긍정", emoji: "🍀"),
      MoodOption(name: "사랑 받고 있어요", category: "긍정", emoji: "❤️"),
      MoodOption(name: "슬퍼요", category: "부정", emoji: "😢"),
      MoodOption(name: "감사해요", category: "긍정", emoji: "🙏"),
      MoodOption(name: "신나요", category: "긍정", emoji: "🤩"),
      MoodOption(name: "사랑에 빠졌어요", category: "긍정", emoji: "💕"),
      MoodOption(name: "고마워요", category: "긍정", emoji: "🤗"),
      MoodOption(name: "바보같아요", category: "부정", emoji: "🤪"),
      MoodOption(name: "근사해요", category: "긍정", emoji: "✨"),
      MoodOption(name: "긍정적이에요", category: "긍정", emoji: "🌟"),
      MoodOption(name: "완전 기대해요", category: "긍정", emoji: "🙌"),
      MoodOption(name: "피곤해요", category: "부정", emoji: "😴"),
      MoodOption(name: "뿌듯해요", category: "긍정", emoji: "😌"),
      MoodOption(name: "화났어요", category: "부정", emoji: "😡"),
      MoodOption(name: "밥먹을 힘도 없어요", category: "부정", emoji: "🥴"),
      MoodOption(name: "상큼해요", category: "긍정", emoji: "🍋"),
      MoodOption(name: "자신 있어요", category: "긍정", emoji: "💪"),
      MoodOption(name: "행운이 넘치는 하루", category: "긍정", emoji: "🌈"),
      MoodOption(name: "배고파요", category: "부정", emoji: "🍽️"),
      MoodOption(name: "귀여워요", category: "긍정", emoji: "🥰"),
      MoodOption(name: "우울해요", category: "부정", emoji: "😞"),
      MoodOption(name: "만족스러워요", category: "긍정", emoji: "😃"),
      MoodOption(name: "특별해요", category: "긍정", emoji: "🌟"),
      MoodOption(name: "궁금해요", category: "중립", emoji: "❓"),
      MoodOption(name: "스트레스 많땅", category: "부정", emoji: "😖"),
      MoodOption(name: "마음 상했어요", category: "부정", emoji: "💔"),
      MoodOption(name: "좌절스러워요", category: "부정", emoji: "😔"),
      MoodOption(name: "게을러요", category: "부정", emoji: "😴"),
      MoodOption(name: "편안해요", category: "긍정", emoji: "😌"),
      MoodOption(name: "이상해요", category: "중립", emoji: "🤔"),
      MoodOption(name: "상처 입었어요", category: "부정", emoji: "😢"),
    ];
  }
}
