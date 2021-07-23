import 'package:pirosfogo/model/Profile.dart';

class Player {
  final Profile? profile;
  final int place;
  final List<int> scores;

  get scoreSum {
    int sum = 0;
    for (var i = 0; i < scores.length; i++) {
      sum += scores[i];
    }
    return sum;
  }

  Player(this.profile, this.place, this.scores);
}
