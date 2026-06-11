import Cocoa
import WebKit

final class AppDelegate: NSObject, NSApplicationDelegate, WKNavigationDelegate {
  private var window: NSWindow!
  private var webView: WKWebView!

  func applicationDidFinishLaunching(_ notification: Notification) {
    let config = WKWebViewConfiguration()
    config.preferences.javaScriptCanOpenWindowsAutomatically = false

    webView = WKWebView(frame: .zero, configuration: config)
    webView.navigationDelegate = self

    window = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: 960, height: 720),
      styleMask: [.titled, .closable, .miniaturizable, .resizable],
      backing: .buffered,
      defer: false
    )
    window.title = "BIP39 Dotmap"
    window.center()
    window.minSize = NSSize(width: 720, height: 560)
    window.contentView = webView
    window.makeKeyAndOrderFront(nil)

    loadApp()
  }

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    true
  }

  private func loadApp() {
    guard let indexURL = Bundle.main.url(forResource: "index", withExtension: "html") else {
      showLoadError()
      return
    }

    let resourceRoot = indexURL.deletingLastPathComponent()
    webView.loadFileURL(indexURL, allowingReadAccessTo: resourceRoot)
  }

  private func showLoadError() {
    let html = """
    <!doctype html>
    <meta charset="utf-8">
    <style>
      body { font: 16px -apple-system, BlinkMacSystemFont, sans-serif; padding: 32px; }
    </style>
    <h1>Unable to load app resources</h1>
    <p>Please rebuild BIP39 Dotmap.app.</p>
    """
    webView.loadHTMLString(html, baseURL: nil)
  }
}

@main
enum Main {
  static func main() {
    let app = NSApplication.shared
    let delegate = AppDelegate()
    app.delegate = delegate
    app.setActivationPolicy(.regular)
    app.activate(ignoringOtherApps: true)
    app.run()
  }
}
