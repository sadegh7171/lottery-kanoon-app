import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const KanoonApp());

class KanoonApp extends StatelessWidget {
  const KanoonApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'قرعه‌کشی و مسابقات کانون سالارشهیدان',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'sans',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff006b4f)),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tab = 0;
  final teams = <String>[];
  final participants = <String>[];
  String? footballWinner;
  String? culturalWinner;

  void open(Widget page) => Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    final pages = [
      _dashboard(),
      TeamsPage(teams: teams, onChanged: () => setState(() {})),
      ParticipantsPage(participants: participants, onChanged: () => setState(() {})),
      ReportsPage(teams: teams, participants: participants, footballWinner: footballWinner, culturalWinner: culturalWinner),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('کانون سالارشهیدان'), centerTitle: true),
      body: pages[tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'خانه'),
          NavigationDestination(icon: Icon(Icons.groups_outlined), selectedIcon: Icon(Icons.groups), label: 'تیم‌ها'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'شرکت‌کنندگان'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), selectedIcon: Icon(Icons.bar_chart), label: 'گزارش‌ها'),
        ],
      ),
    );
  }

  Widget _dashboard() => Directionality(
    textDirection: TextDirection.rtl,
    child: ListView(padding: const EdgeInsets.all(16), children: [
      Card(color: const Color(0xff006b4f), child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
        Text('🏆  قرعه‌کشی و مسابقات', style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text('کانون فرهنگی هنری سالارشهیدان', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text('مسجد امام حسین (ع) • کوی ابوذرغفاری • شهرستان شوش دانیال (ع)', style: TextStyle(color: Colors.white70, height: 1.7)),
      ]))),
      const SizedBox(height: 12),
      GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, childAspectRatio: 1.35, crossAxisSpacing: 10, mainAxisSpacing: 10, children: [
        _tile('⚽', 'مسابقات فوتبال', () => open(FootballPage(teams: teams, onChanged: () => setState(() {})))),
        _tile('🎲', 'قرعه‌کشی فوتبال', () => open(DrawPage(title: 'قرعه‌کشی فوتبال', items: teams, onWinner: (w) => setState(() => footballWinner = w)))),
        _tile('📚', 'مسابقات فرهنگی', () => open(CulturalPage(participants: participants, onChanged: () => setState(() {})))),
        _tile('🏆', 'قرعه‌کشی فرهنگی', () => open(DrawPage(title: 'قرعه‌کشی فرهنگی', items: participants, onWinner: (w) => setState(() => culturalWinner = w)))),
      ]),
      const SizedBox(height: 16),
      Card(child: ListTile(leading: const Icon(Icons.info_outline), title: const Text('درباره برنامه'), subtitle: const Text('نسخه ۱.۰ • طراحی اختصاصی کانون فرهنگی هنری سالارشهیدان'))),
    ]),
  );

  Widget _tile(String icon, String title, VoidCallback onTap) => Card(child: InkWell(borderRadius: BorderRadius.circular(12), onTap: onTap, child: Padding(padding: const EdgeInsets.all(14), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(icon, style: const TextStyle(fontSize: 34)), const SizedBox(height: 7), Text(title, style: const TextStyle(fontWeight: FontWeight.bold))]))));
}

class TeamsPage extends StatelessWidget {
  final List<String> teams; final VoidCallback onChanged;
  const TeamsPage({super.key, required this.teams, required this.onChanged});
  @override Widget build(BuildContext context) => _ListManager(title: 'ثبت تیم‌ها', hint: 'نام تیم را وارد کنید', items: teams, onChanged: onChanged, icon: Icons.sports_soccer);
}
class ParticipantsPage extends StatelessWidget {
  final List<String> participants; final VoidCallback onChanged;
  const ParticipantsPage({super.key, required this.participants, required this.onChanged});
  @override Widget build(BuildContext context) => _ListManager(title: 'شرکت‌کنندگان مسابقه فرهنگی', hint: 'نام شرکت‌کننده را وارد کنید', items: participants, onChanged: onChanged, icon: Icons.person);
}

class _ListManager extends StatefulWidget {
  final String title, hint; final List<String> items; final VoidCallback onChanged; final IconData icon;
  const _ListManager({required this.title, required this.hint, required this.items, required this.onChanged, required this.icon});
  @override State<_ListManager> createState() => _ListManagerState();
}
class _ListManagerState extends State<_ListManager> {
  final c = TextEditingController();
  @override void dispose(){c.dispose();super.dispose();}
  @override Widget build(BuildContext context) => Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: Text(widget.title)), body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [Row(children: [Expanded(child: TextField(controller:c, decoration: InputDecoration(labelText: widget.hint, border: const OutlineInputBorder()))), const SizedBox(width:8), FilledButton(onPressed:(){final x=c.text.trim();if(x.isNotEmpty){setState(()=>widget.items.add(x));c.clear();widget.onChanged();}}, child: const Text('افزودن'))]), const SizedBox(height:12), Expanded(child: widget.items.isEmpty ? const Center(child: Text('هنوز موردی ثبت نشده است')) : ListView.builder(itemCount:widget.items.length,itemBuilder:(context,i)=>Card(child:ListTile(leading:Icon(widget.icon),title:Text(widget.items[i]),trailing:IconButton(icon:const Icon(Icons.delete_outline),onPressed:(){setState(()=>widget.items.removeAt(i));widget.onChanged();})))))]))));
}

class DrawPage extends StatefulWidget {
  final String title; final List<String> items; final void Function(String) onWinner;
  const DrawPage({super.key, required this.title, required this.items, required this.onWinner});
  @override State<DrawPage> createState()=>_DrawPageState();
}
class _DrawPageState extends State<DrawPage> {
  String result=''; bool running=false;
  Future<void> draw() async {if(widget.items.isEmpty){setState(()=>result='ابتدا حداقل یک مورد ثبت کنید.');return;} setState(()=>running=true); for(int i=0;i<12;i++){await Future.delayed(const Duration(milliseconds:80)); if(!mounted)return; setState(()=>result=widget.items[Random().nextInt(widget.items.length)]);} final w=widget.items[Random().nextInt(widget.items.length)]; if(!mounted)return; setState(() { result='🎉 برنده: $w'; running=false; }); widget.onWinner(w);}
  @override Widget build(BuildContext context)=>Directionality(textDirection:TextDirection.rtl,child:Scaffold(appBar:AppBar(title:Text(widget.title)),body:Padding(padding:const EdgeInsets.all(20),child:Column(children:[const Text('برای انجام قرعه‌کشی، دکمه زیر را بزنید.',style:TextStyle(fontSize:16)),const SizedBox(height:24),Container(width:double.infinity,padding:const EdgeInsets.all(28),decoration:BoxDecoration(color:const Color(0xffe8f5ef),borderRadius:BorderRadius.circular(20)),child:Center(child:Text(result.isEmpty?'آماده قرعه‌کشی':result,style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold)))),const SizedBox(height:20),FilledButton.icon(onPressed:running?null:draw,icon:const Icon(Icons.casino),label:Text(running?'در حال قرعه‌کشی...':'انجام قرعه‌کشی'))])));
}

class FootballPage extends StatelessWidget {final List<String> teams;final VoidCallback onChanged;const FootballPage({super.key,required this.teams,required this.onChanged});@override Widget build(BuildContext c)=>Directionality(textDirection:TextDirection.rtl,child:Scaffold(appBar:AppBar(title:const Text('مسابقات فوتبال')),body:ListView(padding:const EdgeInsets.all(16),children:[Card(child:ListTile(leading:const Icon(Icons.groups),title:const Text('تعداد تیم‌ها'),trailing:Text('${teams.length}',style:const TextStyle(fontWeight:FontWeight.bold,fontSize:20)))),Card(child:ListTile(leading:const Icon(Icons.table_chart),title:const Text('جدول مسابقات'),subtitle:const Text('امتیاز، بازی، تفاضل گل و رتبه'))),Card(child:ListTile(leading:const Icon(Icons.calendar_month),title:const Text('برنامه بازی‌ها'),subtitle:const Text('تاریخ، ساعت و محل مسابقه'))),Card(child:ListTile(leading:const Icon(Icons.emoji_events),title:const Text('مرحله حذفی و فینال')))])) ;}
class CulturalPage extends StatelessWidget {final List<String> participants;final VoidCallback onChanged;const CulturalPage({super.key,required this.participants,required this.onChanged});@override Widget build(BuildContext c)=>Directionality(textDirection:TextDirection.rtl,child:Scaffold(appBar:AppBar(title:const Text('مسابقات فرهنگی')),body:ListView(padding:const EdgeInsets.all(16),children:[Card(child:ListTile(leading:const Icon(Icons.person_add),title:const Text('ثبت شرکت‌کنندگان'),trailing:Text('${participants.length} نفر'))),Card(child:ListTile(leading:const Icon(Icons.numbers),title:const Text('شماره شرکت‌کننده'),subtitle:const Text('اختصاص شماره برای قرعه‌کشی'))),Card(child:ListTile(leading:const Icon(Icons.quiz),title:const Text('نتایج مسابقه'),subtitle:const Text('ثبت امتیاز و پاسخ‌ها')))])) ;}
class ReportsPage extends StatelessWidget {final List<String> teams,participants;final String? footballWinner,culturalWinner;const ReportsPage({super.key,required this.teams,required this.participants,required this.footballWinner,required this.culturalWinner});@override Widget build(BuildContext c)=>Directionality(textDirection:TextDirection.rtl,child:ListView(padding:const EdgeInsets.all(16),children:[const Text('گزارش‌ها',style:TextStyle(fontSize:22,fontWeight:FontWeight.bold)),const SizedBox(height:12),Card(child:ListTile(title:const Text('تیم‌های ثبت‌شده'),trailing:Text('${teams.length}'))),Card(child:ListTile(title:const Text('شرکت‌کنندگان فرهنگی'),trailing:Text('${participants.length}'))),Card(child:ListTile(title:const Text('آخرین برنده فوتبال'),trailing:Text(footballWinner??'ثبت نشده'))),Card(child:ListTile(title:const Text('آخرین برنده فرهنگی'),trailing:Text(culturalWinner??'ثبت نشده')))]));}
