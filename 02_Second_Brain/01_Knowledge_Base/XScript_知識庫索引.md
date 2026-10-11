# XScript 知識庫索引

本頁是 XScript 知識庫的總索引。撰寫 XS 程式碼前，先從這裡確認應查閱的來源。

## 來源優先級

1. `../../00_XQ_Manual/XScript_個人語法說明文件.md`
2. `../../00_XQ_Manual/XScript_官方語法與核心說明文件.md`
3. `../../01_XQ_example/sysjust-xq/XScript_Preset-main`
4. `../../00_XQ_Manual/XScript_錯誤經驗與避坑指南.md`

## 版本與同步

來源版本登記見 `../../00_XQ_Manual/SOURCES.md`，同步歷史見 `../04_Review_Log/更新同步紀錄.md`。

## 寫程式前檢查

- 是否使用了知識庫中存在的函數。
- 是否逐字核對 `GetField` 欄位名稱。
- 是否避免 `SetPlotColor`。
- 是否使用 `Plot1`、`Plot2`、`Plot3`，而不是不存在的 `PlotN`。
- 是否避免重新宣告 `Buy`、`Sell`、`AvgPrice`、`Value1` 到 `Value99`。
- 比較運算是否使用單一等號 `=`。
- 單行 `If` 是否避免多餘的 `End`。

## 常用主題

| 主題 | 狀態 | 筆記 |
| --- | --- | --- |
| Plot 輸出規則 | 待整理 | 使用多軌輸出法，顏色交給介面設定。 |
| GetField 欄位 | 待整理 | 欄位名稱必須逐字核對。 |
| VWAP | 待整理 | 使用成交金額與 Volume 自行計算。 |
| 跨頻率資料 | 待整理 | 實作前需查閱官方範例。 |
| 選股腳本效能 | 待整理 | 需設定合理 `SetTotalBar`。 |

