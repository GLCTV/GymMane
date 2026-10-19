import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../l10n/l10n.dart';
import '../models/exercise.dart';
import '../state/fit_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/exercise_media.dart';
import '../widgets/liquid_notch.dart';
import '../widgets/ui_kit.dart';

/// Texts for the Gym / Home section (brought over from GymHub).
String hs(String key) {
  final ro = fit.language.startsWith('ro');
  return (ro ? _ro[key] : _en[key]) ?? _en[key] ?? key;
}

const _en = {
  'gym': 'Gym',
  'home': 'Home',
  'lib': 'Exercises',
  'plan': 'Program',
  'homeh': 'What can you train with at home?',
  'homed': 'Tick everything you have. We show the exercises that fit. Exercises without equipment are always included.',
  'dumbbell': 'Dumbbells',
  'barbell': 'Barbell',
  'kettlebell': 'Kettlebell',
  'bench': 'Bench',
  'pullbar': 'Pull-up bar',
  'dipbars': 'Dip bars',
  'rings': 'Gymnastic rings',
  'band': 'Resistance band',
  'cable': 'Cable pulley',
  'machine': 'Gym machine',
  'avail': '{n} exercises you can do',
  'nohome': 'Nothing fits this equipment yet. Tick what you have above.',
  'pdays': 'Days per week',
  'lv_h': 'Difficulty',
  'lv0': 'Easy',
  'lv1': 'Normal',
  'lv2': 'Hard',
  'lvd0': 'Gentle start: fewer exercises and sets, lighter effort and more recovery. Good for beginners or a comeback.',
  'lvd1': 'Balanced program for steady muscle growth. The best choice for most people.',
  'lvd2': 'More exercises, more sets and effort close to failure. For people with at least a year of training.',
  'pfocm': 'Priority body parts (pick one or more)',
  'pnone': 'None',
  'armsel': 'Which part of the arms?',
  'a_bi': 'Biceps',
  'a_tri': 'Triceps',
  'a_fa': 'Forearms',
  'armhint': 'Pick one or more parts. Nothing selected shows a mix.',
  'pg_t': 'Your program',
  'pg_dur': 'Time per workout',
  'pg_rest': 'Rest between sets',
  'pg_int': 'Effort',
  'pg_vol': 'Sets per week',
  'pg_min': 'min',
  'pg_r0': '60-90 seconds',
  'pg_r1': '90-120 seconds',
  'pg_r2': 'About 2 minutes on heavy exercises, 60-90 seconds on light ones',
  'pg_e0': 'Stop 3-4 reps before failure',
  'pg_e1': 'Stop 1-3 reps before failure',
  'pg_e2': 'Stop 0-1 reps before failure',
  'pg_eq': 'Your equipment',
  'fhomeeq': 'Your equipment at home (same as in the Exercises list):',
  'day': 'Day',
  's_full': 'Full body',
  's_push': 'Push (chest, shoulders, triceps)',
  's_pull': 'Pull (back, biceps)',
  's_legs': 'Legs',
  's_upper': 'Upper body',
  's_lower': 'Lower body',
  'pg_rst': 'rest',
  'wstart': 'Start workout',
  'tsave': 'Save as routine',
  'tsaved': 'Saved to Routines',
  'saveall': 'Save the whole program to Routines',
  'saveall_d': 'Each day becomes a routine and goes on your weekly plan (free days only).',
  'savedall': '{n} routines saved',
  'pg_why': 'How to use it',
  'pg_warm': 'Warm-up: 5 minutes of light cardio, then 1-2 light sets of your first exercise.',
  'pg_p0': 'Progress: add 1 rep per set each week. When you reach the top of the range, add a little weight.',
  'pg_p1': 'Progress: add weight (about 2.5 kg) or 1-2 reps when you reach the top of the range on every set.',
  'pg_p2': 'Progress: write down every set and add weight as soon as you reach the top of the range. Every 4-6 weeks, take a lighter week (deload).',
  'pg_home': 'At home, make exercises harder instead of heavier: slower reps, pauses, one-leg or elevated versions, bands or a backpack with weight.',
  'pg_food': 'Eat about 1.6-2.2 g of protein per kg of body weight and sleep 7-9 hours.',
  'pg_cool': 'Finish with 5 minutes of stretching and slow breathing.',
  'pnote': 'Rest 2 minutes between heavy sets and 60-90 seconds between light ones. Leave at least one rest day between workouts for the same muscles.',
  'c_cch': 'Coach tips',
  'c_sug': 'I suggest {s} sets × {r} reps for {g}.',
  'c_gen_g': 'To build muscle fast: 3-4 sets of 6-12 reps, stop 1-2 reps before failure, rest 1.5-2 minutes between heavy sets, and train each muscle twice a week.',
  'c_gen_h': 'At home: 3-4 sets of 12-20 reps close to failure, lower slowly (3 seconds), rest 60-90 seconds, and make it harder (slower, feet elevated, band, backpack with weight) once you pass 20 reps.',
  'c_rule': 'Progress rule: when you reach the top of the rep range on every set, add weight or difficulty next time. Sleep 7-9 hours and eat enough protein.',
  'c_chest': 'Start with the heavy presses, then fly or push-up variations. Pause 1 second at the bottom and squeeze at the top.',
  'c_back': 'Pull with your elbows, not your hands, and squeeze your shoulder blades together at the end of each rep.',
  'c_legs': 'Go down at least to parallel and keep your heels on the floor. They are big muscles, so use 3-4 exercises and rest well.',
  'c_shoulders': 'Lighter weights and strict form. Lateral raises work best with 12-20 reps and no swinging.',
  'c_arms': 'Biceps and triceps already work in your chest and back exercises, so 2-3 direct exercises are enough. Control the lowering.',
  'c_core': 'Slow reps with a full squeeze beat fast reps. Visible abs also need low body fat, so food matters.',
  'pg_nogrp': 'Nothing found for this setup. Add equipment above.',
  'chest': 'Chest',
  'back': 'Back',
  'legs': 'Legs',
  'shoulders': 'Shoulders',
  'arms': 'Arms',
  'core': 'Core',
  'program': 'Program',
};

const _ro = {
  'gym': 'Sală',
  'home': 'Acasă',
  'lib': 'Exerciții',
  'plan': 'Program',
  'homeh': 'Cu ce te poți antrena acasă?',
  'homed': 'Bifează tot ce ai în casă. Îți arătăm exercițiile potrivite. Exercițiile fără echipament sunt incluse mereu.',
  'dumbbell': 'Gantere',
  'barbell': 'Bară',
  'kettlebell': 'Kettlebell',
  'bench': 'Bancă',
  'pullbar': 'Bară de tracțiuni',
  'dipbars': 'Paralele',
  'rings': 'Inele de gimnastică',
  'band': 'Bandă elastică',
  'cable': 'Scripete (cablu)',
  'machine': 'Aparat de sală',
  'avail': '{n} exerciții pe care le poți face',
  'nohome': 'Încă nimic pentru acest echipament. Bifează mai sus ce ai acasă.',
  'pdays': 'Zile pe săptămână',
  'lv_h': 'Dificultate',
  'lv0': 'Ușor',
  'lv1': 'Normal',
  'lv2': 'Greu',
  'lvd0': 'Început blând: mai puține exerciții și seturi, efort mai mic și mai multă recuperare. Bun pentru începători sau la revenire.',
  'lvd1': 'Program echilibrat pentru creștere musculară constantă. Cea mai bună alegere pentru majoritatea oamenilor.',
  'lvd2': 'Mai multe exerciții, mai multe seturi și efort aproape de epuizare. Pentru cei care se antrenează de cel puțin un an.',
  'pfocm': 'Zone prioritare (alege una sau mai multe)',
  'pnone': 'Niciuna',
  'armsel': 'Ce parte a brațelor vrei să lucrezi?',
  'a_bi': 'Biceps',
  'a_tri': 'Triceps',
  'a_fa': 'Antebrațe',
  'armhint': 'Alege una sau mai multe. Dacă nu alegi nimic, vezi un mix.',
  'pg_t': 'Programul tău',
  'pg_dur': 'Durată antrenament',
  'pg_rest': 'Pauză între seturi',
  'pg_int': 'Efort',
  'pg_vol': 'Seturi pe săptămână',
  'pg_min': 'min',
  'pg_r0': '60-90 de secunde',
  'pg_r1': '90-120 de secunde',
  'pg_r2': 'Aproximativ 2 minute la exercițiile grele, 60-90 de secunde la cele ușoare',
  'pg_e0': 'Oprește-te cu 3-4 repetări înainte de epuizare',
  'pg_e1': 'Oprește-te cu 1-3 repetări înainte de epuizare',
  'pg_e2': 'Oprește-te cu 0-1 repetări înainte de epuizare',
  'pg_eq': 'Echipamentul tău',
  'fhomeeq': 'Echipamentul tău de acasă (același ca în lista de exerciții):',
  'day': 'Ziua',
  's_full': 'Tot corpul',
  's_push': 'Împingere (piept, umeri, triceps)',
  's_pull': 'Tragere (spate, biceps)',
  's_legs': 'Picioare',
  's_upper': 'Partea de sus',
  's_lower': 'Partea de jos',
  'pg_rst': 'pauză',
  'wstart': 'Începe antrenamentul',
  'tsave': 'Salvează ca rutină',
  'tsaved': 'Salvat în Rutine',
  'saveall': 'Salvează tot programul în Rutine',
  'saveall_d': 'Fiecare zi devine o rutină și intră în planul săptămânii (doar în zilele libere).',
  'savedall': '{n} rutine salvate',
  'pg_why': 'Cum îl folosești',
  'pg_warm': 'Încălzire: 5 minute de cardio ușor, apoi 1-2 seturi ușoare la primul exercițiu.',
  'pg_p0': 'Progres: adaugă 1 repetare pe set în fiecare săptămână. Când ajungi la limita de sus, adaugă puțină greutate.',
  'pg_p1': 'Progres: adaugă greutate (aprox. 2,5 kg) sau 1-2 repetări când ajungi la limita de sus la toate seturile.',
  'pg_p2': 'Progres: notează fiecare set și adaugă greutate imediat ce ajungi la limita de sus. La 4-6 săptămâni fă o săptămână mai ușoară (deload).',
  'pg_home': 'Acasă, fă exercițiile mai grele în loc de mai multă greutate: repetări mai lente, pauze, variante pe un picior sau ridicate, elastic sau rucsac cu greutate.',
  'pg_food': 'Mănâncă 1,6-2,2 g de proteine pe kg de greutate corporală și dormi 7-9 ore.',
  'pg_cool': 'Termină cu 5 minute de întinderi și respirație lentă.',
  'pnote': 'Odihnește-te 2 minute între seturile grele și 60-90 de secunde între cele ușoare. Lasă cel puțin o zi liberă între antrenamentele pentru aceiași mușchi.',
  'c_cch': 'Sfatul antrenorului',
  'c_sug': 'Sugerez {s} seturi × {r} repetări pentru {g}.',
  'c_gen_g': 'Ca să crești rapid în masă musculară: 3-4 seturi de 6-12 repetări, oprește-te cu 1-2 repetări înainte de epuizare, 1,5-2 minute pauză între seturile grele și antrenează fiecare mușchi de două ori pe săptămână.',
  'c_gen_h': 'Acasă: 3-4 seturi de 12-20 repetări aproape de epuizare, coboară lent (3 secunde), pauză 60-90 de secunde și fă exercițiul mai greu (mai lent, picioare ridicate, elastic, rucsac cu greutate) când treci de 20 de repetări.',
  'c_rule': 'Regula progresului: când ajungi la limita de sus a repetărilor la toate seturile, adaugă greutate sau dificultate data viitoare. Dormi 7-9 ore și mănâncă suficiente proteine.',
  'c_chest': 'Începe cu împinsurile grele, apoi fluturări sau flotări. Fă o pauză de 1 secundă jos și strânge mușchiul sus.',
  'c_back': 'Trage cu coatele, nu cu mâinile, și strânge omoplații la finalul fiecărei repetări.',
  'c_legs': 'Coboară cel puțin până la paralel și ține tălpile pe podea. Sunt mușchi mari, deci fă 3-4 exerciții și odihnește-te bine.',
  'c_shoulders': 'Greutăți mai mici și execuție strictă. Ridicările laterale merg cel mai bine la 12-20 de repetări, fără balans.',
  'c_arms': 'Bicepsul și tricepsul lucrează deja la piept și spate, deci 2-3 exerciții directe sunt de ajuns. Controlează coborârea.',
  'c_core': 'Repetările lente, cu strângere completă, bat repetările rapide. Pentru abdomene vizibile contează și mâncarea.',
  'pg_nogrp': 'Nu am găsit nimic pentru această configurație. Adaugă echipament mai sus.',
  'chest': 'Piept',
  'back': 'Spate',
  'legs': 'Picioare',
  'shoulders': 'Umeri',
  'arms': 'Brațe',
  'core': 'Abdomen',
  'program': 'Program',
};

const _weekdaysEn = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _weekdaysRo = ['Lun', 'Mar', 'Mie', 'Joi', 'Vin', 'Sâm', 'Dum'];
String _weekday(int i) => (fit.language.startsWith('ro') ? _weekdaysRo : _weekdaysEn)[i];

const _sugs = {
  false: {'chest': '6-12', 'back': '8-12', 'legs': '8-12', 'shoulders': '8-15', 'arms': '8-12', 'core': '12-20'},
  true: {'chest': '12-20', 'back': '12-20', 'legs': '15-25', 'shoulders': '12-20', 'arms': '12-20', 'core': '15-25'},
};

/// Gym / Home switch plus Exercises / Program / Routines tabs.
class GymHomeBar extends StatelessWidget {
  const GymHomeBar({super.key});

  @override
  Widget build(BuildContext context) {
    final gc = context.gc;
    return Row(children: [
      SegToggle([
        SegOption(hs('gym'), !fit.exHome, () => fit.setExHome(false)),
        SegOption(hs('home'), fit.exHome, () => fit.setExHome(true)),
      ]),
      const Spacer(),
      Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(color: gc.bgRaised2, borderRadius: BorderRadius.circular(100)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          _tab(gc, hs('lib'), fit.exTab == 'lib', () => fit.setExTab('lib')),
          _tab(gc, hs('plan'), fit.exTab == 'plan', () => fit.setExTab('plan')),
          _tab(gc, titleCase(t.routines), false, fit.goRoutines),
        ]),
      ),
    ]);
  }

  Widget _tab(GymColors gc, String label, bool on, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: on ? gc.ember : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(label,
              style: AppTheme.f(12, weight: FontWeight.w600, color: on ? gc.onEmber : gc.textSecondary)),
        ),
      );
}

Widget _chip(GymColors gc, String label, bool on, VoidCallback onTap) => Pill(
      label: label,
      bg: on ? gc.ember : gc.bgRaised2,
      fg: on ? gc.onEmber : gc.textSecondary,
      onTap: onTap,
      hPad: 13,
      vPad: 7,
      fontSize: 12.5,
    );

Widget _wrap(List<Widget> kids) => Wrap(spacing: 8, runSpacing: 8, children: kids);

Widget _label(GymColors gc, String s) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(s, style: AppTheme.f(15, weight: FontWeight.w700, color: gc.text)),
    );

Widget _hint(GymColors gc, String s) => Text(s,
    style: AppTheme.f(12.5, weight: FontWeight.w500, color: gc.textSecondary, height: 1.4));

/// The "Gym at home" equipment picker shown at the top of the list.
class HomeGearCard extends StatelessWidget {
  const HomeGearCard({super.key, this.compact = false});
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final gc = context.gc;
    return SoftCard(
      radius: 20,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (compact) ...[
          _label(gc, hs('pg_eq')),
          _hint(gc, hs('fhomeeq')),
        ] else ...[
          Row(children: [
            Icon(PhosphorIconsRegular.house, size: 18, color: gc.ember),
            const SizedBox(width: 8),
            Expanded(child: Text(hs('homeh'), style: AppTheme.f(15.5, weight: FontWeight.w700, color: gc.text))),
          ]),
          const SizedBox(height: 6),
          _hint(gc, hs('homed')),
        ],
        const SizedBox(height: 12),
        _wrap([
          for (final g in kHomeGear) _chip(gc, hs(g), fit.homeGear.contains(g), () => fit.toggleHomeGear(g)),
        ]),
        if (!compact) ...[
          const SizedBox(height: 12),
          Text(hs('avail').replaceAll('{n}', '${fit.homeCount}'),
              style: AppTheme.f(12.5, weight: FontWeight.w700, color: gc.accent)),
        ],
      ]),
    );
  }
}

/// GymHub's program builder, adapted to GymHub.
class PlanView extends StatelessWidget {
  const PlanView({super.key});

  @override
  Widget build(BuildContext context) {
    final gc = context.gc;
    final plan = fit.buildPlan();
    final vol = fit.planVolume(plan);
    final lv = fit.planLevel;
    final sched = HomeGymState.planSchedule[fit.progDays]!;
    final withEx = plan.where((d) => d.exercises.isNotEmpty).toList();
    final avg = withEx.isEmpty ? 0 : (withEx.map((d) => d.minutes).reduce((a, b) => a + b) / withEx.length).round();

    String dayType(PlanDay d) => hs('s_${d.type}');
    String dayTitle(PlanDay d, int i) => '${_weekday(sched[i])} · ${hs('day')} ${i + 1}: ${dayType(d)}';

    return ListView(
      key: const PageStorageKey('ex-plan'),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
      children: [
        _label(gc, hs('pdays')),
        SegToggle([
          for (final d in const [2, 3, 4, 5, 6]) SegOption('$d', fit.progDays == d, () => fit.setProgDays(d)),
        ], hPad: 16),
        const SizedBox(height: 20),
        _label(gc, hs('lv_h')),
        SegToggle([
          for (final l in const [0, 1, 2]) SegOption(hs('lv$l'), lv == l, () => fit.setPlanLevel(l)),
        ]),
        const SizedBox(height: 8),
        _hint(gc, hs('lvd$lv')),
        const SizedBox(height: 20),
        _label(gc, hs('pfocm')),
        _wrap([
          _chip(gc, hs('pnone'), fit.planFocus.isEmpty, fit.clearPlanFocus),
          for (final g in kPlanGroups) _chip(gc, hs(g), fit.planFocus.contains(g), () => fit.togglePlanFocus(g)),
        ]),
        if (fit.planFocus.contains('arms')) ...[
          const SizedBox(height: 16),
          _label(gc, hs('armsel')),
          _wrap([
            for (final p in const ['bi', 'tri', 'fa'])
              _chip(gc, hs('a_$p'), fit.armParts.contains(p), () => fit.toggleArmPart(p)),
          ]),
          const SizedBox(height: 6),
          _hint(gc, hs('armhint')),
        ],
        if (fit.exHome) ...[
          const SizedBox(height: 20),
          const HomeGearCard(compact: true),
        ],
        const SizedBox(height: 22),
        SoftCard(
          radius: 20,
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${hs('pg_t')} · ${hs('lv$lv')}', style: AppTheme.f(16, weight: FontWeight.w700, color: gc.text)),
            const SizedBox(height: 10),
            _wrap([
              for (var i = 0; i < plan.length; i++)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                  decoration: BoxDecoration(color: gc.emberSoft, borderRadius: BorderRadius.circular(100)),
                  child: Text('${_weekday(sched[i])} · ${dayType(plan[i]).split(' (').first}',
                      style: AppTheme.f(12, weight: FontWeight.w700, color: gc.ember)),
                ),
            ]),
            const SizedBox(height: 12),
            _kv(gc, hs('pg_dur'), '~$avg ${hs('pg_min')}'),
            _kv(gc, hs('pg_rest'), hs('pg_r$lv')),
            _kv(gc, hs('pg_int'), hs('pg_e$lv')),
            _kv(gc, hs('pg_vol'),
                kPlanGroups.where((g) => (vol[g] ?? 0) > 0).map((g) => '${hs(g)} ${vol[g]}').join(' · ').ifEmpty('-')),
          ]),
        ),
        if (fit.planFocus.isNotEmpty) ...[
          const SizedBox(height: 14),
          _coach(gc),
        ],
        for (var i = 0; i < plan.length; i++) ...[
          const SizedBox(height: 14),
          _dayCard(context, gc, plan[i], dayTitle(plan[i], i)),
        ],
        if (withEx.isNotEmpty) ...[
          const SizedBox(height: 18),
          PrimaryButton(
            label: hs('saveall'),
            height: 50,
            bg: gc.bgRaised2,
            fg: gc.text,
            onTap: () {
              final n = fit.savePlan(plan, (d, i) => dayType(d).split(' (').first,
                  '${hs('program')} · ${hs('lv$lv')} · ${fit.progDays}×');
              showNotchToast(context, hs('savedall').replaceAll('{n}', '$n'),
                  icon: PhosphorIconsFill.stack, accent: context.gc.sage);
            },
          ),
          const SizedBox(height: 6),
          Center(child: _hint(gc, hs('saveall_d'))),
        ],
        const SizedBox(height: 18),
        _callout(gc, hs('pg_why'), [
          hs('pg_warm'),
          hs('pg_p$lv'),
          if (fit.exHome) hs('pg_home'),
          hs('pg_food'),
          hs('pg_cool'),
          hs('pnote'),
        ]),
      ],
    );
  }

  Widget _kv(GymColors gc, String k, String v) => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: 120,
            child: Text(k, style: AppTheme.f(12.5, weight: FontWeight.w500, color: gc.textSecondary)),
          ),
          Expanded(child: Text(v, style: AppTheme.f(13, weight: FontWeight.w700, color: gc.text, height: 1.35))),
        ]),
      );

  Widget _callout(GymColors gc, String title, List<String> lines) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: gc.emberSoft,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: AppTheme.f(14.5, weight: FontWeight.w800, color: gc.text)),
          for (final l in lines) ...[
            const SizedBox(height: 8),
            Text(l, style: AppTheme.f(13, weight: FontWeight.w500, color: gc.text, height: 1.4)),
          ],
        ]),
      );

  Widget _coach(GymColors gc) {
    final home = fit.exHome;
    final lines = [
      for (final g in fit.planFocus)
        '${hs(g)}: ${hs('c_sug').replaceAll('{s}', g == 'core' ? '3' : '3-4').replaceAll('{r}', _sugs[home]![g]!).replaceAll('{g}', hs(g).toLowerCase())} ${hs('c_$g')}',
      hs(home ? 'c_gen_h' : 'c_gen_g'),
      hs('c_rule'),
    ];
    return _callout(gc, hs('c_cch'), lines);
  }

  Widget _dayCard(BuildContext context, GymColors gc, PlanDay d, String title) {
    return SoftCard(
      radius: 20,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Text(title, style: AppTheme.f(14.5, weight: FontWeight.w700, color: gc.text))),
          if (d.exercises.isNotEmpty)
            Text('~${d.minutes} ${hs('pg_min')}',
                style: AppTheme.f(12, weight: FontWeight.w600, color: gc.textTertiary)),
        ]),
        const SizedBox(height: 6),
        if (d.exercises.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _hint(gc, hs('pg_nogrp')),
          )
        else ...[
          for (final e in d.exercises) _exRow(gc, e),
          const SizedBox(height: 10),
          PrimaryButton(label: hs('wstart'), height: 46, onTap: () => fit.startPlanDay(d)),
          const SizedBox(height: 8),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              fit.savePlanDay(d, title.split(': ').last.split(' (').first);
              showNotchToast(context, hs('tsaved'),
                  subtitle: title, icon: PhosphorIconsFill.stack, accent: context.gc.sage);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: Text(hs('tsave'), style: AppTheme.f(13, weight: FontWeight.w700, color: gc.accent)),
              ),
            ),
          ),
        ],
      ]),
    );
  }

  Widget _exRow(GymColors gc, PlanExercise e) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => fit.openExercise(e.ex.id),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(children: [
            SizedBox(width: 44, child: ExerciseMedia(ex: e.ex, height: 44, radius: 12, bordered: false)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(exerciseName(e.ex),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.f(14, weight: FontWeight.w600, color: gc.text)),
                const SizedBox(height: 3),
                Text('${e.sets} × ${e.reps} · ${hs('pg_rst')} ${e.rest} s',
                    style: AppTheme.f(12, weight: FontWeight.w500, color: gc.textSecondary)),
              ]),
            ),
            Icon(PhosphorIconsBold.caretRight, size: 13, color: gc.textTertiary),
          ]),
        ),
      );
}

extension on String {
  String ifEmpty(String other) => isEmpty ? other : this;
}

/// Shown above the list in Home mode.
Widget homeEmptyHint(GymColors gc) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      child: Text(hs('nohome'),
          textAlign: TextAlign.center,
          style: AppTheme.f(13.5, weight: FontWeight.w600, color: gc.textSecondary)),
    );
