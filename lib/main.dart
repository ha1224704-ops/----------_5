import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/quran.dart' as quran;

void main() {
  runApp(QuranApp());
}

class QuranApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuranHome(),
    );
  }
}

class QuranHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text('نور القلوب', style: TextStyle(color: Color(0xFFD4AF37))),
      ),
      body: Column(
        children: [
          // اهداء للمرحوم ناصر عزيز
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Color(0xFF111111),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFD4AF37), width: 1.2),
            ),
            child: Column(
              children: [
                Text('بسم الله الرحمن الرحيم', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 16)),
                SizedBox(height: 4),
                Text('صدقة جارية', style: TextStyle(color: Colors.white70, fontSize: 12)),
                Text('المرحوم ناصر عزيز', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Text('الفاتحة لروحه', style: TextStyle(color: Color(0xFFD4AF37))),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 114,
              itemBuilder: (context, index) {
                int n = index + 1;
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  color: Color(0xFF1A1A1A),
                  child: ListTile(
                    leading: Text('$n', style: TextStyle(color: Color(0xFFD4AF37))),
                    title: Text(quran.getSurahNameArabic(n), style: TextStyle(color: Colors.white, fontSize: 17)),
                    subtitle: Text('${quran.getVerseCount(n)} ايات', style: TextStyle(color: Colors.white54)),
                    trailing: Icon(Icons.play_circle_fill, color: Color(0xFFD4AF37)),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => SurahPage(num: n)));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SurahPage extends StatefulWidget {
  final int num;
  SurahPage({required this.num});
  @override
  _SurahPageState createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  final player = AudioPlayer();
  int cur = 0;

  Future<void> play(int aya) async {
    try {
      String url = 'https://everyayah.com/data/Alafasy_128kbps/${widget.num.toString().padLeft(3, '0')}${aya.toString().padLeft(3, '0')}.mp3';
      await player.setUrl(url);
      await player.play();
      setState(() { cur = aya; });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(quran.getSurahNameArabic(widget.num), style: TextStyle(color: Color(0xFFD4AF37))),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: quran.getVerseCount(widget.num),
        itemBuilder: (context, i) {
          int aya = i + 1;
          bool isCur = cur == aya;
          return Container(
            margin: EdgeInsets.only(bottom: 6),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCur ? Color(0xFFD4AF37).withOpacity(0.2) : Color(0xFF111111),
              borderRadius: BorderRadius.circular(8),
            ),
            child: InkWell(
              onTap: () => play(aya),
              child: Row(
                children: [
                  Text('$aya', style: TextStyle(color: Colors.white38, fontSize: 11)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      quran.getVerse(widget.num, aya),
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.white, fontSize: 20, height: 1.6),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}