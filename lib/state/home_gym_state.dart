part of 'fit_state.dart';

/// Gear you can own at home. Same idea as GymHub's "Gym at home" picker,
/// adapted to GymHub's exercise catalog.
const List<String> kHomeGear = [
  'dumbbell',
  'barbell',
  'kettlebell',
  'bench',
  'pullbar',
  'dipbars',
  'rings',
  'band',
  'cable',
  'machine',
];

/// Muscle groups used by the program builder.
const List<String> kPlanGroups = ['chest', 'back', 'legs', 'shoulders', 'arms', 'core'];

class PlanExercise {
  PlanExercise(this.ex, this.group);
  final Exercise ex;
  final String group;
  int sets = 3;
  String reps = '10-12';
  int rest = 90;
}

class PlanDay {
  PlanDay(this.type, this.exercises);
  final String type;
  final List<PlanExercise> exercises;
  int minutes = 0;
}

mixin HomeGymState on FitCore, LibraryState, RoutinesState, WorkoutState {
  /// false = gym, true = home.
  bool exHome = false;

  /// 'lib' = exercise list, 'plan' = program builder.
  String exTab = 'lib';
  Set<String> homeGear = {};
  int progDays = 3;
  int planLevel = 1;
  List<String> planFocus = [];
  List<String> armParts = [];

  void _loadHomeGym(Map<String, dynamic> data) {
    final j = (data['homeGym'] as Map?)?.cast<String, dynamic>() ?? const {};
    exHome = j['home'] as bool? ?? false;
    homeGear = ((j['gear'] as List?) ?? const []).whereType<String>().where(kHomeGear.contains).toSet();
    final d = (j['days'] as num?)?.toInt() ?? 3;
    progDays = d.clamp(2, 6);
    planLevel = ((j['lvl'] as num?)?.toInt() ?? 1).clamp(0, 2);
    planFocus = ((j['focus'] as List?) ?? const []).whereType<String>().where(kPlanGroups.contains).toList();
    armParts = ((j['arms'] as List?) ?? const []).whereType<String>().where(const ['bi', 'tri', 'fa'].contains).toList();
  }

  Map<String, dynamic> get _homeGymJson => {
        'home': exHome,
        'gear': homeGear.toList(),
        'days': progDays,
        'lvl': planLevel,
        if (planFocus.isNotEmpty) 'focus': planFocus,
        if (armParts.isNotEmpty) 'arms': armParts,
      };

  void setExHome(bool home) {
    if (exHome == home) return;
    exHome = home;
    _persist();
    notifyListeners();
  }

  void setExTab(String tab) {
    if (exTab == tab) return;
    exTab = tab;
    notifyListeners();
  }

  void toggleHomeGear(String g) {
    if (!homeGear.remove(g)) homeGear.add(g);
    _persist();
    notifyListeners();
  }

  void setProgDays(int d) {
    progDays = d.clamp(2, 6);
    _persist();
    notifyListeners();
  }

  void setPlanLevel(int l) {
    planLevel = l.clamp(0, 2);
    _persist();
    notifyListeners();
  }

  void togglePlanFocus(String g) {
    if (!planFocus.remove(g)) planFocus.add(g);
    _persist();
    notifyListeners();
  }

  void clearPlanFocus() {
    planFocus.clear();
    _persist();
    notifyListeners();
  }

  void toggleArmPart(String p) {
    if (!armParts.remove(p)) armParts.add(p);
    _persist();
    notifyListeners();
  }

  // ---------------------------------------------------------------- gear

  static bool _has(String name, List<String> words) => words.any(name.contains);

  /// What an exercise needs. 'other' is never available at home.
  Set<String> homeNeeds(Exercise ex) {
    final n = ex.name.toLowerCase();
    final need = <String>{};
    bool bench() => _has(n, const ['bench', 'incline', 'decline', 'lying', 'prone', 'pullover', 'preacher']);
    bool bar() => _has(n, const ['pull-up', 'pull up', 'pullup', 'chin-up', 'chin up', 'hang', 'muscle-up', 'inverted row', 'wide row', 'incline row', 'vertical row']);
    bool dip() =>
        (n.contains('dip') && !n.contains('hip dip') && !n.contains('bench dip') && !n.contains('chair dip')) ||
        n.contains('parallel bar');
    switch (ex.equipment) {
      case 'Barbell':
        need.add('barbell');
        if (bench()) need.add('bench');
      case 'Dumbbell':
        need.add('dumbbell');
        if (bench()) need.add('bench');
      case 'Kettlebell':
        need.add('kettlebell');
      case 'Cable':
        need.add('cable');
      case 'Machine':
        need.add('machine');
      case 'Band':
        need.add('band');
      case 'Rings':
        need.add('rings');
      case 'Bodyweight':
      case 'Weighted':
        if (n.contains('bench pull')) {
          need.add('bench');
        } else if (bar()) {
          need.add('pullbar');
        } else if (dip()) {
          need.add('dipbars');
        } else if (n.contains('bench dip') || n.contains('bench leg') || n.contains('bench hip') || n.contains('box squat')) {
          need.add('bench');
        }
        if (ex.equipment == 'Weighted') {
          need.add('dumbbell');
          if (n.contains('decline')) need.add('bench');
        }
        if (n.contains('stability ball')) need.add('other');
      default:
        need.add('other');
    }
    return need;
  }

  bool homeOk(Exercise ex) => homeGear.containsAll(homeNeeds(ex));

  int get homeCount => allExercises.where((e) => !isArchived(e.id) && homeOk(e)).length;

  // ------------------------------------------------------------- program

  static const _tg = {'chest': 12, 'back': 14, 'legs': 14, 'shoulders': 12, 'bi': 8, 'tri': 8, 'fa': 6, 'core': 8};
  static const _split = {
    2: ['full', 'full'],
    3: ['full', 'full', 'full'],
    4: ['upper', 'lower', 'upper', 'lower'],
    5: ['push', 'pull', 'legs', 'upper', 'lower'],
    6: ['push', 'pull', 'legs', 'push', 'pull', 'legs'],
  };
  static const _slots = {
    'full': [('chest', 1), ('back', 1), ('legs', 2), ('shoulders', 1), ('arm', 1), ('core', 1)],
    'push': [('chest', 2), ('shoulders', 2), ('tri', 2)],
    'pull': [('back', 3), ('bi', 2), ('core', 1)],
    'legs': [('legs', 4), ('core', 1)],
    'upper': [('chest', 2), ('back', 2), ('shoulders', 1), ('bi', 1), ('tri', 1)],
    'lower': [('legs', 3), ('core', 1)],
  };
  static const _lvm = [0.75, 1.0, 1.3];

  /// Weekday indexes (0 = Monday) for each number of training days.
  static const planSchedule = {
    2: [0, 3],
    3: [0, 2, 4],
    4: [0, 1, 3, 4],
    5: [0, 1, 2, 4, 5],
    6: [0, 1, 2, 3, 4, 5],
  };

  static const _compoundWords = [
    'press', 'squat', 'deadlift', 'row', 'pull-up', 'pull up', 'chin-up', 'chin up', 'dip', 'lunge',
    'push-up', 'push up', 'thrust', 'pulldown', 'clean', 'snatch', 'step-up', 'step up', 'good morning',
  ];

  bool isCompound(Exercise ex) {
    final n = ex.name.toLowerCase();
    if (_has(n, const ['stretch', 'raise', 'curl', 'extension', 'fly', 'kickback', 'shrug'])) {
      return _has(n, const ['press', 'squat', 'deadlift']);
    }
    return _has(n, _compoundWords);
  }

  String? planGroupOf(Exercise ex) => switch (ex.primary) {
        'chest' => 'chest',
        'back' || 'trapezius' || 'lowerback' => 'back',
        'quads' || 'hamstrings' || 'glutes' || 'calves' => 'legs',
        'shoulders' => 'shoulders',
        'biceps' => 'bi',
        'triceps' => 'tri',
        'forearm' => 'fa',
        'abdomen' || 'obliques' => 'core',
        _ => null,
      };

  int _score(Exercise ex, bool home, int level) {
    var s = isCompound(ex) ? 0 : 10;
    s += switch (ex.difficulty) {
      'Beginner' => 0,
      'Intermediate' => level == 0 ? 2 : 1,
      'Advanced' => level == 2 ? 3 : 6,
      _ => 8,
    };
    s += (home
            ? const {'Dumbbell': 0, 'Barbell': 0, 'Kettlebell': 1, 'Bodyweight': 1, 'Band': 2, 'Rings': 2, 'Weighted': 3}
            : const {'Barbell': 0, 'Dumbbell': 1, 'Machine': 2, 'Cable': 2, 'Bodyweight': 3, 'Kettlebell': 4, 'Weighted': 4, 'Rings': 5, 'Band': 6})[ex.equipment] ??
        8;
    if (ex.art.isEmpty) s += 3;
    if (ex.name.contains('(')) s += 2;
    return s;
  }

  bool _planUsable(Exercise ex, bool home, int level) {
    if (isArchived(ex.id) || isCustom(ex.id)) return false;
    final k = kindOf(ex);
    if (k == 'stretch' || k == 'cardio') return false;
    if (ex.difficulty == 'Expert') return false;
    if (level == 0 && ex.difficulty == 'Advanced') return false;
    if (home) return homeOk(ex);
    return ex.equipment != 'Band' && ex.equipment != 'Other';
  }

  /// Ranked exercise pool for a group ('chest', 'back', 'legs', 'shoulders',
  /// 'bi', 'tri', 'fa', 'core', or 'arms' for a biceps/triceps mix).
  List<Exercise> planPool(String group, {bool? home, int? level}) {
    final h = home ?? exHome, l = level ?? planLevel;
    final usable = allExercises.where((e) => _planUsable(e, h, l)).toList();
    List<Exercise> ranked(bool Function(Exercise) test) {
      final list = usable.where(test).toList();
      final order = {for (var i = 0; i < list.length; i++) list[i].id: i};
      list.sort((a, b) {
        final c = _score(a, h, l).compareTo(_score(b, h, l));
        return c != 0 ? c : order[a.id]!.compareTo(order[b.id]!);
      });
      return list;
    }

    List<Exercise> mix(List<List<Exercise>> lists, List<int> pattern) {
      final out = <Exercise>[];
      final idx = List.filled(lists.length, 0);
      var guard = 0;
      while (guard++ < 400) {
        var added = false;
        for (final p in pattern) {
          if (idx[p] < lists[p].length) {
            out.add(lists[p][idx[p]++]);
            added = true;
          }
        }
        if (!added) break;
      }
      return out;
    }

    switch (group) {
      case 'legs':
        return mix([
          ranked((e) => e.primary == 'quads'),
          ranked((e) => e.primary == 'hamstrings'),
          ranked((e) => e.primary == 'glutes'),
          ranked((e) => e.primary == 'calves'),
        ], const [0, 1, 0, 2, 3]);
      case 'back':
        return mix([
          ranked((e) => e.primary == 'back'),
          ranked((e) => e.primary == 'trapezius' || e.primary == 'lowerback'),
        ], const [0, 0, 0, 1]);
      case 'core':
        return mix([
          ranked((e) => e.primary == 'abdomen'),
          ranked((e) => e.primary == 'obliques'),
        ], const [0, 0, 1]);
      case 'arms':
        return mix([
          ranked((e) => e.primary == 'biceps'),
          ranked((e) => e.primary == 'triceps'),
        ], const [0, 1]);
      default:
        return ranked((e) => planGroupOf(e) == group);
    }
  }

  String planRepRange(Exercise ex, int days, {bool? home, int? level}) {
    final h = home ?? exHome, l = level ?? planLevel;
    if (isTimed(ex.id)) return '45 s';
    final g = planGroupOf(ex), c = isCompound(ex);
    String base(int d) => g == 'core'
        ? '12-15'
        : c
            ? (d == 0 ? '6-10' : d <= 3 ? '6-8' : d == 4 ? '6-10' : '8-12')
            : (d == 0 ? '10-15' : d <= 3 ? '10-12' : '12-15');
    if (h) {
      if (g == 'core') return const ['12-15', '15-20', '20-30'][l];
      final mid = (ex.equipment == 'Bodyweight' || ex.equipment == 'Band') ? '12-20' : base(0);
      return ['10-15', mid, '15-25'][l];
    }
    if (l == 0) return '12-15';
    if (l == 2) return c ? '5-8' : (g == 'core' ? '15-25' : '8-12');
    return base(days);
  }

  int planRest(Exercise ex, {int? level}) {
    final l = level ?? planLevel;
    if (isTimed(ex.id)) return 45;
    return [75, 105, isCompound(ex) ? 120 : 75][l];
  }

  static int repTarget(String range) {
    if (range.endsWith(' s')) return int.tryParse(range.split(' ').first) ?? 45;
    final p = range.split('-').map(int.parse).toList();
    return (p.reduce((a, b) => a + b) / p.length).round();
  }

  List<PlanDay> buildPlan() {
    final days = progDays, lvl = planLevel, focus = planFocus;
    bool fm(String g) => focus.any((f) => f == g || (f == 'arms' && (g == 'bi' || g == 'tri' || g == 'fa')));
    final seen = <String, int>{};
    final pools = <String, List<Exercise>>{};
    final out = <PlanDay>[];
    final split = _split[days]!;
    for (var si = 0; si < split.length; si++) {
      final type = split[si];
      final list = <PlanExercise>[];
      for (final (g0, n) in _slots[type]!) {
        final g = g0 == 'arm' ? (armParts.isNotEmpty ? armParts[si % armParts.length] : (si.isOdd ? 'tri' : 'bi')) : g0;
        final pool = pools[g] ??= planPool(g);
        if (pool.isEmpty) continue;
        final c = seen[g] ?? 0;
        seen[g] = c + 1;
        final cnt = math.max(1, n + (fm(g) ? 1 : 0) + (lvl == 2 && n > 1 ? 1 : 0) - (lvl == 0 && n > 1 ? 1 : 0));
        for (var j = 0; j < math.min(pool.length, cnt); j++) {
          final ex = pool[(j + (type == 'full' ? c : 2 * c)) % pool.length];
          if (!list.any((e) => e.ex.id == ex.id)) list.add(PlanExercise(ex, g));
        }
      }
      out.add(PlanDay(type, list));
    }
    final perWeek = <String, int>{};
    for (final d in out) {
      for (final e in d.exercises) {
        perWeek[e.group] = (perWeek[e.group] ?? 0) + 1;
      }
    }
    for (final d in out) {
      var sec = 0;
      for (final e in d.exercises) {
        e.sets = ((((_tg[e.group] ?? 8) + (fm(e.group) ? 4 : 0)) * _lvm[lvl]) / perWeek[e.group]!)
            .round()
            .clamp(lvl == 2 ? 3 : 2, 5);
        e.reps = planRepRange(e.ex, days);
        e.rest = planRest(e.ex);
        sec += e.sets * (45 + e.rest);
      }
      d.minutes = (sec / 60 + 10).round();
    }
    return out;
  }

  /// Sets per week for each top-level group shown in the summary.
  Map<String, int> planVolume(List<PlanDay> plan) {
    final v = <String, int>{};
    for (final d in plan) {
      for (final e in d.exercises) {
        final g = const {'bi', 'tri', 'fa'}.contains(e.group) ? 'arms' : e.group;
        v[g] = (v[g] ?? 0) + e.sets;
      }
    }
    return v;
  }

  List<PlannedSet> _plannedFor(PlanExercise e) {
    final target = repTarget(e.reps);
    final timed = e.reps.endsWith(' s');
    return [for (var i = 0; i < e.sets; i++) timed ? PlannedSet(sec: target) : PlannedSet(reps: target)];
  }

  void startPlanDay(PlanDay day) {
    if (day.exercises.isEmpty) return;
    if (_backToParked()) return;
    final exs = [for (final e in day.exercises) e.ex];
    _beginSession(exs,
        plan: {for (final e in day.exercises) e.ex.id: e.sets},
        planned: {for (final e in day.exercises) e.ex.id: _plannedFor(e)});
  }

  String savePlanDay(PlanDay day, String name, {String group = ''}) {
    final id = createRoutine(name);
    if (group.isNotEmpty) setRoutineGroup(id, group);
    for (final e in day.exercises) {
      toggleRoutineExercise(id, e.ex.id);
      setPlannedSets(id, e.ex.id, _plannedFor(e));
      setRoutineRest(id, e.ex.id, e.rest);
    }
    persistNow();
    return id;
  }

  /// Saves every day of the plan as a routine and puts them on the weekly
  /// schedule. Returns how many routines were made.
  int savePlan(List<PlanDay> plan, String Function(PlanDay day, int i) name, String group) {
    var made = 0;
    final sched = planSchedule[plan.length] ?? const [];
    for (var i = 0; i < plan.length; i++) {
      if (plan[i].exercises.isEmpty) continue;
      final id = savePlanDay(plan[i], name(plan[i], i), group: group);
      if (i < sched.length && weeklyPlan[sched[i] + 1] == null) assignRoutineToDay(sched[i] + 1, id);
      made++;
    }
    return made;
  }
}
