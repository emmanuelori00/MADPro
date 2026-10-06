Digital Pet
A Flutter project for Mobile Application Development. The player feeds and plays with a pet while keeping track of its hunger and happiness.
Repository: emmanuelori00/MADPro
Progress
Feed, Play, Reset, and the hunger timer are working in the current local app. Win/loss handling and pet-name input are still pending. Session controls, visual polish, integration, full tests, and the release APK also need to be completed or verified.
Team roles
- Emmanuel Gohourou (Team 1): pet-care logic
- Marcus Fielding (Team 2): presentation and UI
These are the assigned roles. Marcus's current progress hasn't been confirmed.
No pull requests have been opened yet; development is still in progress. The plan is for each team to work on a separate branch and open a PR for the other team to review, rather than committing directly to the default branch.
Issue, PR, and review links can be added here as the work progresses.
Gameplay
These are the rules the finished app needs to meet:
- Feed: hunger decreases by 10. If the resulting hunger is below 30, happiness decreases by 20; otherwise, happiness increases by 10.
- Play: happiness and hunger both increase by 10.
- Both values stay between 0 and 100.
- Hunger increases by 5 every 30 seconds. Going from 95 to 100 has no happiness penalty. The next tick that would take hunger above 100 leaves it at 100 and reduces happiness by 20.
- Win: happiness stays above 80 continuously for three minutes. Dropping to 80 or below resets that progress.
- Lose: hunger reaches 100 while happiness is 10 or below.
- Timers stop when the game ends or the screen is disposed. Reset clears the previous game and starts exactly one hunger timer.
The proposed starting values are hunger 50, happiness 50, and the pet name Buddy. Name validation and whether Reset keeps the chosen name still need to be settled.
Undergraduate extras
We selected session controls and visual polish.
The exact session controls and their timer behavior still need to be agreed. Visual polish needs at least two effects with reduced-motion support.
Mood feedback uses happiness: red below 30, yellow from 30 to 70, and green above 70. A text label or icon should make the mood clear without relying only on color.
Running the app
Use a compatible Flutter SDK, the Android toolchain, and an emulator or connected device. From the folder containing pubspec.yaml:
flutter doctor
flutter pub get
flutter run
Checks and release build:
flutter analyze
flutter test
flutter build apk --release
These commands have not been verified against the final project. Record the Flutter version, test device, and commit with the results. See the Flutter CLI reference.
The usual output is build/app/outputs/flutter-apk/app-release.apk. After checking the release configuration and testing installation, use the required name DigitalPet_TeamName.apk, with the actual team name. See Flutter's Android build guide.
Testing
The main actions have been checked manually. The following checks still need recorded results:
Check	Expected result
Feed boundary	Hunger 40 → 30 gives happiness +10; 39 → 29 gives −20
Repeated actions	Hunger and happiness remain within 0–100
Hunger ceiling	95 → 100 has no penalty; the next overflow tick gives happiness −20
Win timing	Three continuous minutes above 80 wins; reaching 80 resets progress
Loss boundary	Hunger 100 and happiness 10 loses; 100/11 and 99/10 do not
Reset and cleanup	Repeated resets leave one hunger timer; no timer updates after an outcome or disposal
UI and release	Name input, agreed session controls, mood boundaries, reduced motion, and APK installation behave correctly


Formal test results have not been recorded here yet. Add the results, evidence links, and tested commit before submission.
Screenshots
No screenshots are available yet. Before submission, add the main screen, mood states, win/loss screens, and session controls. A short recording can show the visual effects.
Feature-to-outcome map
- Care actions and outcomes: state updates, conditions, and boundary handling
- Hunger and win timers: asynchronous behavior and lifecycle management
- Name input, session controls, and mood cues: interaction design and accessibility
- Branches and cross-team reviews: collaborative development
- Tests, documentation, and APK: verification and delivery
Asset credits
No image assets are available to list yet. For any assets added, record the creator, original source, and license or permission here. The project source-code license still needs to be confirmed.
Submission
Each student uploads:
- github_link.txt with the repository URL
- The same final DigitalPet_TeamName.apk
- Their own YourName_CriticalThinking.docx, answering all 10 questions
