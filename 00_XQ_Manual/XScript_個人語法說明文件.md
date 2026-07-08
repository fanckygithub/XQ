# XScript 個人語法與實戰進階技巧

這份文件記錄了在實戰開發中總結出的進階邏輯與效能優化寫法。當開發新的 XQ 腳本（特別是盤中警示、自動交易腳本）時，應優先考慮套用這些準則。

## 1. 跨頻率資料快取 (Daily Structure Caching)

在盤中短線腳本（如 15m, 30m）中，若需要參考日線級別的指標（如均線、VWMA_J 等）來作為「大趨勢濾網」，**絕對不要**讓程式在每一根短線 K 棒都重新計算日線數值。
應利用 `if date <> date[1] then` 判斷每天的第一根 K 棒，將跨頻率或沉重的運算結果快取起來，供當日後續盤中運算使用，大幅降低 CPU 負載與避免訊號飄移。

**範例寫法：**
```pascal
vars: yesterday_C(0), holdlineD(0), lifelineD(0), maxline(0), billvalue(0), _day_structure(0);

if date <> date[1] then begin
    // 取得昨收
    yesterday_C = getField("close","D")[1];
    
    // 計算日線級別的核心均線
    holdlineD = Average(GetField("收盤價", "D"), 17)[1]; 
    lifelineD = VWMA_J_past(88); 
    maxline = maxList(holdlineD, lifelineD); 
    
    // 計算比爾度 (距離支撐線的乖離程度)
    if maxline <> 0 then 
        billvalue = (yesterday_C - maxline) / maxline * 100;  
        
    // 確立日線多空結構 (以供盤中作為濾網)
    if holdlineD > lifelineD then 
        _day_structure = 1
    else
        _day_structure = 0; 
end;
```

## 2. 歷史訊號過濾 (Real-Time Execution Check)

在撰寫「警示腳本」或「自動交易腳本」時，強烈建議加上 `GetInfo("IsRealTime") = 1` 條件。
這可以防止在開啟策略雷達、重新編譯腳本或開啟技術分析圖時，因為系統回補歷史資料而瞬間觸發大量過去的「歷史假警報」。

**範例寫法：**
```pascal
// 只在真正即時洗盤運算時觸發
if isTriggered and GetInfo("IsRealTime") = 1 then begin
    ret = 1;
    // ...
end;
```

## 3. 高含金量的格式化警示輸出 (Detailed Notification Messages)

警示推播的文字 (`retmsg`) 不應只是單純的「觸發進場」，而應該充分利用 `Text()` 與 `NumToStr()` 函數，把觸發當下的重要技術數據與快取變數一起印出來。
這樣可以在手機或螢幕跳出通知的瞬間，無需打開線圖就能直接評估交易價值與風險。

**範例寫法：**
```pascal
if isTriggered and GetInfo("IsRealTime") = 1 then begin
    ret = 1;
    variable: str("");
    str = Text("策略名稱_版本:"
        ," 日期=", NumToStr(Date, 0)
        ," 時間=", FormatTime("HH:mm:ss", Time)
        ," 量比>1=", NumToStr(GetField("量比"), 2)
        ," 比爾度<15=", NumToStr(billvalue, 2)
        ," 日線結構(1/0)=", NumToStr(_day_structure, 1)
        ," 進場市價=", NumToStr(Close, 2)
        ," 進場均價=", NumToStr(GetField("均價"), 2)
    );
    retmsg = str;
end;
```

## 4. 確保足夠的資料讀取筆數 (SetTotalBar) - 腳本類型差異防呆

在使用包含長天期移動平均線 (例如 88 期) 或 MACD 這種具有遞迴權重特性的指標時，務必在腳本最開頭宣告足夠的 `SetTotalBar`。

**🚨 核心實戰差異：**
- **指標腳本 (Indicator)**：使用者通常可以直接在 XQ 技術分析圖表的 UI 介面上拉長歷史 K 棒，強迫載入足夠的資料。
- **警示 (Alert) / 自動交易 (AutoTrade) / 選股 (Screener) 腳本**：系統在背景執行，**完全不會**理會您的看盤畫面，如果不強制寫入 `SetTotalBar`，系統預設只會抓極少量的 K 棒，導致指標算錯、訊號漏抓。**這是這三類腳本的必備設定！**

**範例寫法：**
```pascal
// 保留足夠的運算天數 (特別是在警示/選股/自動交易腳本中)
SetTotalBar((maxlist(12,26,6) + 9) * 4 * 22 * 90);
```

## 5. 指標參數快速切換 (QuickEdit 與 Dict)

在指標腳本中，為提升看盤時參數切換的流暢度，強烈建議將 `inputkind:=Dict(...)` 下拉選單功能與 `quickedit:=true` 結合。
這樣可以允許使用者直接在 K 線圖的指標名稱旁邊點擊並快速切換參數，而不需要點擊右鍵進入「設定指標」視窗。

**範例寫法：**
```pascal
// 加上 quickedit:=true，讓指標參數可以直接在主圖上點擊快速切換
input: IndexPomUnit(5, "累加區間天數", inputkind:=Dict(["5日",5], ["10日",10], ["20日",20], ["60日",60], ["120日",120]), quickedit:=true);
```
