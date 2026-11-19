[Home](../../README.md) · [Polski](../pl/user-guide.md) · [Installation](installation.md)

# User guide

## Browsing and managing files

After login, a single source is selected automatically; if several are available, choose one. Browse using breadcrumbs, switch between list and grid views, adjust item size, and sort by name, size or date. Search works within the current source and requires at least three characters.

Use item actions or select several items for copy, move, delete and download. A destination picker is available for copy and move. Create folders, rename items, and inspect file details; checksums are calculated on request. The status screen shows account, storage usage and available server capabilities.

## Viewing and sharing

Open images in the gallery, play video, or preview text. Viewer menus also offer file actions. Create a server share link with optional password and expiry, manage existing links, or send local copies through Android's share sheet. Sending copies first downloads them to app cache; transfers over 100 MiB require confirmation. Folders cannot be sent as copies.

Share files from another Android app into this app and choose a destination to upload them. Use **Open with** to hand a downloaded file to another installed app. These actions depend on Android intent handling and the installed apps.

## Transfers

The transfers screen shows progress. Downloads and small uploads use Android's background transfer service and notifications. Uploads larger than 10 MiB are sent in sequential chunks by the app process, with pause/resume and retries; Android can stop these uploads if the app is killed in the background. A graceful in-app pause preserves the server-side partial upload, but a network error mid-chunk causes a retry from the beginning.

When an upload conflicts with an existing path, choose overwrite, skip or keep both. Download destinations use Android's storage picker; available locations and behavior vary by Android version.

## Troubleshooting

- **Cannot connect or log in:** check the final server URL, network access, account and server permissions. HTTPS is assumed without a scheme. HTTP requires confirmation. Redirects and interactive identity-provider login are not supported; see [Installation](installation.md).
- **Transfer stops:** check the transfers screen and Android notifications. Keep the app alive for chunked uploads and check that the selected storage location is accessible.
- **Cannot install an update:** follow Android's permission prompt and check that the APK has the same application ID and signing key and a higher version code. See [Updating](installation.md#updating).
- **Cannot open or share a file:** check that an appropriate Android app is installed and that the chosen file or destination is accessible.

When reporting a problem, include app, Android/device and server versions, steps to reproduce and the copyable error text. Remove passwords, tokens and private paths from any logs before sharing them. Use the repository's [bug report form](https://github.com/Adiker/filebrowser-quantum-mobile/issues/new/choose).
