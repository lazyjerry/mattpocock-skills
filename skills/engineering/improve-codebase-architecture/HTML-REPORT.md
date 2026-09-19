# HTML 報告格式

架構審查會被轉譯成一個獨立的 HTML 檔案，存放在作業系統的暫存目錄中。Tailwind 和 Mermaid 都來自 CDN。Mermaid 能穩定處理圖形結構的圖表；手刻的 div 和內嵌 SVG 則負責處理較具編輯感的視覺元素（量體圖、剖面圖）。混合使用這兩者：不要什麼都靠 Mermaid，那樣看起來會很制式化。

## 骨架

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>Architecture review for {{repo name}}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script type="module">
      import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
      mermaid.initialize({ startOnLoad: true, theme: "neutral", securityLevel: "loose" });
    </script>
    <style>
      /* small custom layer for things Tailwind doesn't cover cleanly:
         dashed seam lines, hand-drawn-feeling arrow heads, etc. */
      .seam { stroke-dasharray: 4 4; }
      .leak { stroke: #dc2626; }
      .deep { background: linear-gradient(135deg, #0f172a, #1e293b); }
    </style>
  </head>
  <body class="bg-stone-50 text-slate-900 font-sans">
    <main class="max-w-5xl mx-auto px-6 py-12 space-y-12">
      <header>...</header>
      <section id="candidates" class="space-y-10">...</section>
      <section id="top-recommendation">...</section>
    </main>
  </body>
</html>
```

## 標頭區

儲存庫名稱、日期，以及一份精簡的圖例：實線方框 = 模組（module），虛線 = 接縫（seam），紅色箭頭 = 洩漏（leakage），粗黑方框 = 深模組（deep module）。不要放介紹段落，直接進入候選項目。

## 候選卡片

圖表才是重點，文字要精簡、平實，並且直接使用（來自 `/codebase-design` skill 的）詞彙表術語，不要多加修飾。

每個候選項目是一個 `<article>`：

- **標題**：簡短，直接點出這次深化的內容（例如「收斂 Order intake pipeline」）。
- **徽章列**：推薦強度（`Strong` = 翠綠色、`Worth exploring` = 琥珀色、`Speculative` = 灰色），加上依賴類別的標籤（`in-process`、`local-substitutable`、`ports & adapters`、`mock`）。
- **檔案**：等寬字型清單，`font-mono text-sm`。
- **Before / After 圖**：核心焦點。左右兩欄並排。見下方的圖表模式。
- **問題**：一句話。哪裡有痛點。
- **解法**：一句話。要改什麼。
- **收穫**：條列式，每項不超過 6 個詞。例如「測試只打一個介面」、「定價邏輯不再外洩」、「刪掉 4 個淺層包裝」。
- **ADR 提示框**（如適用）：琥珀色底色框中一行文字。

不要寫大段解釋。如果一張圖需要一段文字才能看懂，就重畫那張圖。

## 圖表模式

依候選項目挑選適合的模式。混合使用，不要讓每張圖都長得一樣。多樣性本身就是重點之一。

### Mermaid graph（依賴關係／呼叫流程的主力工具）

當重點是「X 呼叫 Y、Y 呼叫 Z，看看這團亂」時，使用 Mermaid 的 `flowchart` 或 `graph`。用一個 Tailwind 樣式的卡片包起來，讓它不會顯得突兀。用 classDef 把洩漏的邊染成紅色，深模組染成深色。序列圖很適合用來表達「Before：6 次往返；After：1 次」。

```html
<div class="rounded-lg border border-slate-200 bg-white p-4">
  <pre class="mermaid">
    flowchart LR
      A[OrderHandler] --> B[OrderValidator]
      B --> C[OrderRepo]
      C -.leak.-> D[PricingClient]
      classDef leak stroke:#dc2626,stroke-width:2px;
      class C,D leak
  </pre>
</div>
```

### 手刻方框與箭頭（當 Mermaid 的排版不聽話時）

模組用有邊框、有標籤的 `<div>` 表示。箭頭用內嵌 SVG 的 `<line>` 或 `<path>` 元素，絕對定位在一個 relative 容器上。當你想讓「after」圖呈現出「一個粗邊框的深模組、內部灰階化」的感覺時，就用這招，因為 Mermaid 沒辦法畫出那種粗細對比。

### 剖面圖（適合表現分層造成的淺薄）

用水平色帶（`h-12 border-l-4`）堆疊，表示一次呼叫會經過的各層。Before：6 層薄薄的層，每層都沒做什麼事。After：1 層粗的色帶，標示整合後的職責。

### 量體圖（適合表現「介面和實作一樣寬」）

每個模組畫兩個矩形：一個代表介面面積，一個代表實作面積。Before：介面矩形幾乎和實作矩形一樣高（淺薄）。After：介面矩形矮，實作矩形高（深）。

### 呼叫圖收斂

Before：函式呼叫樹，以巢狀方框呈現。After：同一棵樹收斂成一個方框，原本的呼叫以淡化方式顯示在內部。

## 風格指引

- 走編輯風，不要企業儀表板風。留白要充足。標題可選用襯線字型（`font-serif` 搭配 stone/slate 色系效果不錯）。
- 顏色要用得節制：一個主色（翠綠色或靛藍色），再加上紅色表洩漏、琥珀色表警示。
- 圖表高度維持在約 320px，讓 before/after 能並排顯示、不需捲動。
- 圖表內的模組標籤使用 `text-xs uppercase tracking-wider`，讓它讀起來像示意圖，而不是 UI 介面。
- 唯一使用的腳本是 Tailwind CDN 與 Mermaid 的 ESM 匯入。報告本身是靜態的：沒有應用程式邏輯，除了 Mermaid 自身的渲染外沒有其他互動。

## 最推薦區塊

一張較大的卡片。候選項目名稱、一句話說明原因，再加上連到該卡片的錨點連結。就這樣。

## 語氣

平實的白話文，簡潔，但架構相關的名詞與動詞要直接取自 `/codebase-design` skill。簡潔不是偏離詞彙的藉口。

**務必使用：** module（模組）、interface（介面）、implementation（實作）、depth（深度）、deep（深）、shallow（淺）、seam（接縫）、adapter（轉接器）、leverage（槓桿效益）、locality（局部性）。

**絕不替換為：** component、service、unit（取代 module）· API、signature（取代 interface）· boundary（取代 seam）· layer、wrapper（取代 module，當你指的其實是 module 時）。

**符合這種風格的說法：**

- 「Order intake module 很淺薄：介面幾乎和實作一樣大。」
- 「Pricing 從接縫處外洩。」
- 「深化：一個介面，一個測試的地方。」
- 「兩個轉接器足以證明這個接縫的必要性：正式環境用 HTTP，測試用記憶體內實作。」

**收穫條列**要用詞彙表中的術語來說明成效：*「局部性：問題集中在一個模組」*、*「槓桿效益：一個介面，N 個呼叫點」*、*「介面縮小；實作吸收了包裝層」*。不要寫*「更好維護」*或*「程式碼更乾淨」*，因為這些詞不在詞彙表裡，用不上。

不要模稜兩可，不要迂迴鋪陳，不要出現「值得一提的是……」這種說法。如果一句話能寫成條列，就寫成條列。如果一條可以刪，就刪掉。如果某個詞不在 `/codebase-design` 詞彙表裡，先找詞彙表裡有的詞來用，而不是自創新詞。
