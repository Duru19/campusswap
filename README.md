# CampusSwap — CS310 Group 37 — Step 2.2

Campus marketplace Flutter UI based on the approved Step 2.1 wireframes.

## Team
- Duru Bilgin (34325)
- Cansu Yıldırım (33981)
- Orkun Güzel (34524)

## Run
1. Install Flutter SDK (Flutter 3.24+ recommended; **record the exact version you actually test with** using `flutter --version`).
2. From this directory run `flutter create --platforms=android,ios .` to generate platform scaffolding if it is missing.
3. Run `flutter pub get`.
4. Start an Android emulator or iOS simulator.
5. Run `flutter run`.

Note: This source package was prepared without a Flutter SDK in the build environment; compilation and simulator testing must be performed locally before submission.

## Features
- Login and sign-up UI (no backend authentication, as required for Step 2)
- Home feed and category chips; keyword search and price/category filters
- Listing details, seller profile and reviews
- Create/edit listing with inline validation and success dialog
- Mark as sold dialog with buyer university email validation
- Favorites add/remove, profile active/sold lists, delete action
- Local placeholder PNG, remote network image with fallback, Google Fonts (Nunito Sans)
- In-memory model objects and state (resets on restart)

## Important
Firebase, image uploading and persistent storage are not part of Step 2.2. The login screen is UI-only. Buyer-only reviews are shown only when the signed-in demo email matches the recorded buyer email. For a demo, use the same buyer email in the login UI after recording a sale in the running session.

## Submission checklist
- [ ] Test `flutter run` on an Android emulator or iOS simulator
- [ ] Check portrait layout at small and large sizes
- [ ] Push all source files to the public repository https://github.com/Duru19/campusswap
- [ ] Record the **actual** deadline commit SHA
- [ ] Capture and label screenshots of core screens from the running app
- [ ] Add verified member contributions and actual Flutter version to submission PDF
- [ ] Ensure each member commits through their own GitHub account and attends the TA meeting

## GitHub Actions (cloud checks)
The `.github/workflows/flutter-check.yml` workflow installs Flutter on a hosted runner, generates Android scaffolding, runs `flutter analyze` and `flutter test`, and builds a debug APK. This workflow is supplied but **has not been run or verified**. After pushing, check the Actions tab for actual results and fix any failures. A passing cloud APK build does not replace the assignment's `flutter run` simulator requirement.

## Demo account
For the seeded owner listings, log in as `orkun.guzel@sabanciuniv.edu` with any password of at least six characters. Authentication is UI-only for Step 2.2; no account is created on a server.

## Submission integrity
Do not describe wireframes as emulator screenshots. Replace report placeholders with genuine captures from a running app. Use the actual GitHub commit SHA and verified member contributions; do not invent these details.
