class MissionHelper {
/// Returns a score for a challenge.
///
/// Scoring:
/// +2 if challenge category matches preferred category
/// +1 if challenge is not yet completed
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
 
/// Determines whether a challenge is recommended.
static bool isRecommended({
required bool categoryMatch,
required bool unfinished,
}) {
return calculateScore(
categoryMatch: categoryMatch,
unfinished: unfinished,
) >
0;
}
 
/// Returns a recommendation message.
static String getRecommendation({
required String challengeTitle,
required bool categoryMatch,
required bool unfinished,
}) {
final score = calculateScore(
categoryMatch: categoryMatch,
unfinished: unfinished,
);
 
if (score >= 3) {
return 'Highly Recommended: $challengeTitle';
}
 
if (score >= 2) {
return 'Recommended: $challengeTitle';
}
 
if (score >= 1) {
return 'Consider: $challengeTitle';
}
 
return 'Not Recommended';
}
}

And your accompanying
