import SwiftUI
import WebKit

/// Zeigt das Spiel (index.html aus dem App-Bundle) in einer WebView an.
/// Der Spielstand liegt wie im Browser im localStorage und bleibt zwischen App-Starts erhalten.
struct GameView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()
        config.userContentController.add(context.coordinator, name: "haptic")
        config.userContentController.addUserScript(
            WKUserScript(source: Self.bridge, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        )

        let web = WKWebView(frame: .zero, configuration: config)
        let paper = UIColor(named: "Paper")
        web.isOpaque = false
        web.backgroundColor = paper
        web.scrollView.backgroundColor = paper
        web.scrollView.contentInsetAdjustmentBehavior = .never
        web.scrollView.bounces = false
        web.allowsLinkPreview = false
        #if DEBUG
        web.isInspectable = true
        #endif

        if let url = Bundle.main.url(forResource: "index", withExtension: "html") {
            web.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
        return web
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    /// Leitet Stempel, Eilvorgänge und Beförderungen an die native Haptik weiter
    /// und schaltet Browser-Verhalten ab, das in einer App stört (Zoom, Textauswahl).
    private static let bridge = """
    (function(){
      const post=k=>{try{webkit.messageHandlers.haptic.postMessage(k)}catch(e){}};
      navigator.vibrate=function(){post("tick");return true};
      document.addEventListener("click",e=>{
        if(e.target.closest("#stamp"))post("stamp");
        else if(e.target.closest(".eilt"))post("success");
        else if(e.target.closest("button"))post("tick");
      },true);
      new MutationObserver(ms=>ms.forEach(m=>m.addedNodes.forEach(n=>{
        if(n.classList&&n.classList.contains("ovl"))post("success");
      }))).observe(document.body,{childList:true});
      const vp=document.querySelector('meta[name="viewport"]');
      if(vp)vp.content+=", maximum-scale=1, user-scalable=no";
      const st=document.createElement("style");
      st.textContent="body{-webkit-user-select:none;user-select:none;-webkit-touch-callout:none}";
      document.head.appendChild(st);
    })();
    """

    final class Coordinator: NSObject, WKScriptMessageHandler {
        private let tick = UIImpactFeedbackGenerator(style: .light)
        private let stamp = UIImpactFeedbackGenerator(style: .medium)
        private let notify = UINotificationFeedbackGenerator()

        func userContentController(_ controller: WKUserContentController, didReceive message: WKScriptMessage) {
            switch message.body as? String {
            case "stamp": stamp.impactOccurred()
            case "success": notify.notificationOccurred(.success)
            default: tick.impactOccurred(intensity: 0.5)
            }
        }
    }
}
