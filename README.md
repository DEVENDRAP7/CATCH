# Catch

A mobile app for collaborative trip photo & video sharing, built with Flutter.

Create a trip, add photos/videos to it, and browse trips from Home as a grid
of photo stacks — pick whichever photo should be a stack's cover at any time.
No likes, comments, friends list, or sharing — it's a shared album, not a
social feed.

## Getting the app without installing anything

Every push to `main` builds a release APK in GitHub Actions and publishes it
to the **[latest-build release](../../releases/tag/latest-build)** — open
that page on your Android device and download `app-release.apk`. You can
also trigger a fresh build any time from the **Actions** tab → *Build APK* →
*Run workflow*, then grab the APK either from that run's artifacts or from
the same release page once it finishes.

## Running locally

This repo ships the app's Dart source (`lib/`) and `pubspec.yaml`, but not
the generated native platform folders (`android/`, `ios/`) — those are
scaffolding Flutter generates for you, and are regenerated automatically in
CI. To run locally:

```sh
flutter create --platforms=android,ios .   # fills in android/, ios/ — safe, won't touch lib/
flutter pub get
flutter run
```

## Project structure

```
lib/
  main.dart              # app entrypoint, theme + Provider wiring
  theme/                 # light/dark design-system tokens (§5 of the spec)
  models/                # Trip, MediaItem
  state/                 # AppState (ChangeNotifier) with seed demo data
  screens/                # Home, Trip Detail, Media Viewer, Create Trip, Profile
  widgets/                # photo stack, bottom nav, loading badge, etc.
  utils/                  # relative-time formatting, icon/color option lists
```

## Design notes

- **Bottom nav** — a floating pill bar; the selected tab grows into an
  accent-colored horizontal capsule, unselected tabs sit as icon-over-label.
- **Loading indicator** — a branded morphing-blob badge (`CatchLoadingBadge`)
  used everywhere something is loading: network images, video thumbnails,
  and the full-screen video viewer.
- **Photo stacks** — up to three layered, slightly rotated photo cards per
  trip on Home, with the user-chosen (or most-recent) cover on top.
- Upload is simulated locally (no backend): picking a photo/video shows a
  live progress banner, then inserts the item at the top of the grid tagged
  "You · Just now".
