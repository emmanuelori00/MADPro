class MissionHelper {

  static int calculateScore({
    required bool categoryMatch,
    required bool unfinished,
  }) {

    int score = 0;

    if (categoryMatch) {
      score += 2;
    }

    if (unfinished) {
      score += 1;
    }

    return score;
  }
}