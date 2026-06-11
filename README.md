# BIP39 Dotmap

A small offline, bidirectional tool for working with BIP39 dotmaps:

- tap dots to reveal the matching BIP39 English word
- enter a BIP39 word to generate its 12-dot map

## Features

- Fully offline: no network requests, external APIs, or CDN assets.
- Uses the built-in BIP39 English wordlist from `wordlist.js`.
- Supports both dot-to-word lookup and word-to-dotmap generation.
- Can run as a plain web page or as a lightweight macOS app.

## Web Usage

Open `index.html` directly in a browser.

For more reliable clipboard access, run a local server:

```sh
python3 -m http.server 4173
```

Then open `http://localhost:4173`.

## macOS App

Build the native macOS wrapper:

```sh
./build-macos.sh
```

The app will be created at:

```text
dist/BIP39 Dotmap.app
```

The macOS app is a thin `WKWebView` wrapper around the same local HTML, CSS, JavaScript, and wordlist files.

## Dotmap Rules

The 12 dot weights are ordered left to right, top to bottom:

```text
2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1
```

Add the selected weights to get an index from `1` to `2048`, then map that index to the BIP39 English wordlist. The lookup also works in reverse: enter a valid BIP39 word and the app will select the dots whose weights add up to that word's index.

For example, `1 + 2 = 3`, and word #3 is `able`.
