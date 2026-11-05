# Local modification

Based on Flutter's video_player_android 2.12.2 (BSD-3-Clause; see LICENSE).
The Android HTTP media factory disables cross-protocol redirects to prevent
an HTTPS media URL from being followed to unencrypted HTTP. Recheck this
change when updating the vendored plugin.
