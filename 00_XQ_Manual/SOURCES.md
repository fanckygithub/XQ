# 知識庫來源與版本登記表

本檔是知識庫「基準版本」的唯一登記處。每次同步官方更新後，只更新本檔與 `02_Second_Brain/04_Review_Log/更新同步紀錄.md`。

> 狀態值：`未記錄` 代表建立登記表時無法確認，尚待使用者或下次同步時補上。不得自行推測填寫。

## 來源清單

| 編號 | 檔案／資料夾 | 優先級 | 上游來源 | 基準版本 | 最後同步日 | 同步方式 |
| --- | --- | --- | --- | --- | --- | --- |
| S1 | `XScript_個人語法說明文件.md` | P1 | 使用者實戰經驗 | 不適用 | 未記錄 | 僅在「實測行為改變」時修改 |
| S2 | `XScript_官方語法與核心說明文件.md` | P2 | https://xshelp.xq.com.tw/XSHelp/ | 未記錄 | 未記錄 | 依官方更新紀錄逐條合併 |
| S3 | `../01_XQ_example/sysjust-xq/XScript_Preset-main` | P3 | https://github.com/sysjust-xq | commit 未記錄 | 未記錄 | 重新下載並用 `git diff` 比對 |
| S4 | `../01_XQ_example/sysjust-xq/XS_Blocks-main` | P3 | https://github.com/sysjust-xq | commit 未記錄 | 未記錄 | 同 S3 |
| S5 | `../01_XQ_example/sysjust-xq/XQStrategy-main` | P3 | https://github.com/sysjust-xq | commit 未記錄 | 未記錄 | 同 S3 |
| S6 | `../01_XQ_example/sysjust-xq/vscode-xs-master` | P3 | https://github.com/sysjust-xq | commit 未記錄 | 未記錄 | 同 S3 |
| S7 | `XScript_錯誤經驗與避坑指南.md` | 輔助 | 使用者編譯錯誤紀錄 | 不適用 | 未記錄 | 每次遇到新錯誤即追加 |

## 同步原則

1. **分層更新**：官方變動只改 S2～S6；S1 與 S7 以使用者實測為準，不被官方文件覆蓋。
2. **衝突處理**：官方新版與 S1 / S7 衝突時，先請使用者用 XQ 實測，再決定採用哪一方，並記錄在同步紀錄。
3. **淘汰標記**：官方淘汰的函數不直接刪除，改標註 `[已淘汰 YYYY-MM-DD]` 並註明替代寫法。
4. **新增標記**：官方新增的函數標註 `[新增 YYYY-MM-DD]`，並附上官方頁面連結。
5. **只信可核對來源**：每筆變更都必須附上來源網址或 commit，查無來源者不得合併。
6. **同步頻率**：每月一次，或 XQ 公告新版本時立即執行。

## 單次同步流程

1. 讀取 XSHelp 更新紀錄與 sysjust-xq 各 repo 的最新 commit。
2. 與本表「基準版本」比對，列出差異（新增／修改／淘汰）。
3. 將差異寫入 `更新同步紀錄.md` 的新條目，狀態為「待確認」。
4. 使用者確認後，才合併進 S2 或 S3～S6。
5. 更新本表的「基準版本」與「最後同步日」。
6. 檢查 S1、S7 是否與新版衝突，並註記。
