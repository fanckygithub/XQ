# Alpha 因子軍火庫 (Factor Playbook)

從 35 支高勝率 XScript 腳本中，以「反向工程」萃取出的投資邏輯與因子模組。 每個因子模組可像積木般自由組合，快速打造新策略。

---

## 目錄

### A. 動能突破因子 (Momentum / Breakout)

- [A1. 低波動壓縮後帶量突破](#a1-低波動壓縮後帶量突破)  
- [A2. 價量同步創新高](#a2-價量同步創新高)  
- [A3. 整理後創區間新高（多因子複合）](#a3-整理後創區間新高多因子複合)  
- [A4. 暴量剛起漲](#a4-暴量剛起漲)  
- [A5. 區間未破底且創新高](#a5-區間未破底且創新高)  
- [A6. 布林帶寬壓縮突破](#a6-布林帶寬壓縮突破)  
- [A7. 無量變有量](#a7-無量變有量)  
- [A8. 盤整區間突破（簡化版）](#a8-盤整區間突破簡化版)

### B. 趨勢動能因子 (Trend / Momentum Indicators)

- [B1. 蓄勢待發（均線糾結+MACD轉強）](#b1-蓄勢待發均線糾結macd轉強)  
- [B2. CMI 趨勢指數轉強](#b2-cmi-趨勢指數轉強)  
- [B3. 多頭架構剛轉強](#b3-多頭架構剛轉強)  
- [B4. 盤整後 MACD 黃金交叉](#b4-盤整後-macd-黃金交叉)  
- [B5. 回檔到高勝率區間](#b5-回檔到高勝率區間)

### C. 籌碼因子 (Institutional / Smart Money)

- [C1. 籌碼 Elder Force 指標](#c1-籌碼-elder-force-指標)  
- [C2. 主力籌碼 Chaikin 指標](#c2-主力籌碼-chaikin-指標)  
- [C3. 投信沉寂後首次大買](#c3-投信沉寂後首次大買)  
- [C4. 投信初次進場建倉](#c4-投信初次進場建倉)  
- [C5. 大股東站在買方](#c5-大股東站在買方)  
- [C6. 低價股外資投信同步買超](#c6-低價股外資投信同步買超)  
- [C7. 散戶持股比例急遽降低](#c7-散戶持股比例急遽降低)  
- [C8. 主力默默吸納籌碼](#c8-主力默默吸納籌碼)

### D. 價值因子 (Value / Fundamental)

- [D1. 股價距離目標價折價過大](#d1-股價距離目標價折價過大)  
- [D2. EV/EBITDA 低估值篩選](#d2-evebitda-低估值篩選)  
- [D3. GVI 低檔回升](#d3-gvi-低檔回升)  
- [D4. 市值營收比偏低](#d4-市值營收比偏低)  
- [D5. 股價距離 DCF 合理價偏低](#d5-股價距離-dcf-合理價偏低)  
- [D6. 研發費用市值比高](#d6-研發費用市值比高)

### E. 複合因子 (Composite / Multi-Factor)

- [E1. 創百日高（價量+壓縮+大盤）](#e1-創百日高價量壓縮大盤)  
- [E2. 基本面好轉 \+ 出量創新高](#e2-基本面好轉--出量創新高)  
- [E3. 高現金殖利率 \+ 營收成長](#e3-高現金殖利率--營收成長)  
- [E4. 連續兩季毛利率成長 \+ 月營收創新高](#e4-連續兩季毛利率成長--月營收創新高)

---

## A. 動能突破因子 (Momentum / Breakout)

---

### A1. 低波動壓縮後帶量突破

**投資智慧**：股票在低位區間窄幅盤整（籌碼沉澱），當某天突然放量收最高，代表供需結構改變、主力準備發動。重點是「量價齊揚且漲幅不大」——抓的是啟動的第一根，而非追高。

**核心勝率來源**：

- 區間壓縮（漲幅 \< 7%）確保不是追高  
- 收盤價+成交量同時創區間新高 \= 真突破訊號  
- 雙重確認降低假突破機率

**選股條件**：

1. 今日收盤價創 N 日最高價  
2. 今日成交量創 N 日最大量  
3. 區間最高價距離最低價漲幅 \< 7%（壓縮確認）

**可調參數**： | 參數 | 預設值 | 說明 | |------|--------|------| | day | 20 | 回看區間天數 | | ratioLimit | 7 | 區間最大漲幅上限(%) |

**XScript 實作模組**：

Input: day(20,"日期區間");

Input: ratioLimit(7, "區間最大漲幅%");

Condition1 \= C \= highest(C, day);

// 今日收盤創區間最高價

Condition2 \= V \= highest(V, day);

// 今日成交量創區間最大量

Condition3 \= highest(H, day) \< lowest(L, day) \* (1 \+ ratioLimit \* 0.01);

// 區間最高價距離最低價漲幅尚不大

Ret \= Condition1 And Condition2 And Condition3;

**適用場景**：選股、警示 **組合建議**：可搭配 \[C5. 大股東站在買方\] 或 \[C1. 籌碼 Elder Force\] 過濾假突破

---

### A2. 價量同步創新高

**投資智慧**：尋找**長期以來第一次**創波段新高的股票，而非一直在創新高的強勢股。配合近期漲幅不大（壓縮盤整）與帶量突破，抓住主力啟動的第一波。

**核心勝率來源**：

- 「第一次」創新高（`Not Condition20[1]`）排除連續創高的追高風險  
- 近 13 日漲幅 \< 5% 確認先前處於盤整  
- 同時量價齊揚，流動性有保障（連續 5 日量 \> 500 張）

**選股條件**：

1. 連續 5 日成交量 \> 500 張（流動性門檻）  
2. 最高價創 135 日新高，且是第一次（非連續創高）  
3. 近 13 日收盤價振幅 \< 5%（區間壓縮）  
4. 成交量創 13 日新高（帶量）

**可調參數**： | 參數 | 預設值 | 說明 | |------|--------|------| | SPeriod | 13 | 短期回看期（壓縮/爆量判斷） | | LPeriod | 135 | 長期回看期（波段新高判斷） |

**XScript 實作模組**：

Input: SPeriod(13), LPeriod(135);

Condition1 \= trueall(V \> 500, 5);

// 連續5日成交量 \> 500

Condition20 \= H \= Highest(H, LPeriod);

// 創長期新高

Condition2 \= Condition20 and Not Condition20\[1\];

// 長期以來第一次創波段新高

Condition3 \= (Highest(C, SPeriod) \- Lowest(C, SPeriod)) / Lowest(C, SPeriod) \< 0.05;

// 近期漲幅不大（區間壓縮）

Condition4 \= V \= Highest(V, SPeriod);

// 創區間大量

Condition100 \= Condition1 and Condition2 and Condition3 and Condition4;

If Condition100 Then Ret \= 1;

**適用場景**：選股 **組合建議**：搭配 \[D2. EV/EBITDA\] 或 \[D4. 市值營收比\] 可過濾高估值標的

---

### A3. 整理後創區間新高（多因子複合）

**投資智慧**：結合技術面（MACD 轉強 \+ 創新高）、均線距離（股價貼近月線與季線 \= 盤整後剛啟動）、籌碼面（法人當日買超占比高）與基本面（連續兩年 EPS \> 0.5 \+ 低價股），是一個**五維複合篩選**。

**核心勝率來源**：

- MACD 值 \> 0 且遞增 \= 中期趨勢轉多  
- 股價貼近月線季線（距離 \< 2%）= 剛脫離盤整  
- 法人買超占當日成交量 20% 以上 \= 真金白銀的認可  
- 低價股（\< 50 元）有較大補漲空間

**選股條件**：

1. MACD 值 \> 0 且遞增，DIF \> 0（趨勢轉強）  
2. 收盤創 N 日新高  
3. 股價距月線 \< 2%、距季線 \< 2%  
4. 法人當日買超 \> 當日成交量 × 20%  
5. 收盤價 \< 50 元  
6. 連續兩年 EPS \> 0.5

**可調參數**： | 參數 | 預設值 | 說明 | |------|--------|------| | CDays | 10 | 收盤創N日新高 | | FastLength | 12 | DIF 短期期數 | | SlowLength | 26 | DIF 長期期數 | | MACDLength | 9 | MACD 期數 | | MA20\_Ratio | 2 | 股價與月線距離(%) | | MA60\_Ratio | 2 | 股價與季線距離(%) | | Ratio2 | 20 | 法人當日買超占量比(%) |

**XScript 實作模組**：

Input: CDays(10, "收盤創N日收盤高");

Input: FastLength(12, "DIF短期期數"), SlowLength(26, "DIF長期期數"), MACDLength(9, "MACD期數");

Input: MA20\_Ratio(2, "股價與月線距離(%)");

Input: MA60\_Ratio(2, "股價與季線距離(%)");

Input: Ratio2(20, "法人當日買超占量比(%)");

Var: DIFValue(0), MACDValue(0), OSCValue(0);

MACD(weightedclose(), FastLength, SlowLength, MACDLength, DIFValue, MACDValue, OSCValue);

// MACD指標轉強

Condition11 \= MACDValue \> MACDValue\[1\] and MACDValue \> 0 and DIFValue \> 0;

// 收盤創N日收盤高

Condition12 \= C \= Highest(C, CDays);

// 股價與月線距離限制

Condition13 \= Absvalue(Average(C, 20\) / C \- 1\) \< MA20\_Ratio / 100;

// 股價與季線距離限制

Condition14 \= Absvalue(Average(C, 60\) / C \- 1\) \< MA60\_Ratio / 100;

// 三大法人當日買超占量比高

Condition15 \= GetField("法人買賣超張數", "D") \> Volume \* (Ratio2 / 100);

// 收盤價 \< 50

Condition16 \= C \< 50;

// 連續兩年EPS \> 0.5

Condition17 \= GetField("每股稅後淨利(元)", "Y") \> 0.5 and GetField("每股稅後淨利(元)", "Y")\[1\] \> 0.5;

Condition20 \= Condition11 and Condition12 and Condition13 and Condition14 and Condition15 and Condition16 and Condition17;

If Condition20 Then Begin

   Ret \= 1;

End;

**適用場景**：選股 **組合建議**：已高度複合，可放寬單一條件來擴大選股池

---

### A4. 暴量剛起漲

**投資智慧**：找到從底部剛剛啟動的股票——股價仍在 20 日低點附近（距低點幅度 \< 5%），但今日成交量暴增 50% 以上且收紅。這是主力開始吃貨的第一天訊號。

**核心勝率來源**：

- 股價仍在低位（離 N 日低點 \< 5%）= 不是追高  
- 成交量暴增 50% \= 資金大量湧入  
- 收盤 \> 前一日收盤 \= 多方控盤

**選股條件**：

1. 今日收紅（Close \> Close\[1\]）  
2. 成交量 \>= 10 日均量 × 1.5 倍  
3. 收盤價 \<= 20 日最低收盤價 × 1.05

**注意**：原始碼第一行 `nput` 有拼寫錯誤，應為 `Input`。

**可調參數**： | 參數 | 預設值 | 說明 | |------|--------|------| | Length | 20 | 計算期數（低點回看） | | VLength | 10 | 均量期數 | | volpercent | 50 | 爆量增幅(%) | | Rate | 5 | 離低點幅度(%) |

**XScript 實作模組**：

Input: Length(20);        SetInputName(1, "計算期數");

Input: VLength(10);       SetInputName(2, "均量期數");

Input: volpercent(50);    SetInputName(3, "爆量增幅%");

Input: Rate(5);           SetInputName(4, "離低點幅度%");

settotalbar(3);

setbarback(maxlist(Length, VLength));

if Close \> Close\[1\] and

   Volume \>= average(volume, VLength) \* (1 \+ volpercent / 100\) and

   Close \<= lowest(close, Length) \* (1 \+ Rate / 100\)

then ret \= 1;

**適用場景**：選股、警示 **組合建議**：搭配 \[C3. 投信沉寂後首次大買\] 可找到法人剛進場的底部股

---

### A5. 區間未破底且創新高

**投資智慧**：找出在 60 日內**低點從未被跌破**（底部有撐）、且區間振幅 \< 25%（箱型整理）的股票。當收盤價向上突破區間高點，代表箱型被打破、新一波行情啟動。

**核心勝率來源**：

- 低點不破 \= 買盤持續支撐  
- 振幅限制 \= 排除大漲大跌的投機股  
- Close Crosses Over 前波高點 \= 突破買訊

**選股條件**：

1. 60 日區間內低點出現在最早一天（= 之後從未破底）  
2. 區間高點距離區間低點振幅 \< 25%  
3. 收盤價由下往上穿過前波高點

**可調參數**： | 參數 | 預設值 | 說明 | |------|--------|------| | period | 60 | 區間定義（天數） | | percent | 25 | 區間振幅定義(%) |

**XScript 實作模組**：

Input: period(60, "區間定義");

Input: percent(25, "區間振幅定義");

Condition1 \= False;

Condition2 \= False;

// 計算區間低點

Value1 \= Lowest(Low, Period);

// 判斷區間低點不破（低點出現在最遠一天）

IF Value1 \= Low\[Period \- 1\]

Then Condition1 \= True;

// 判斷區間高點 \<= 區間振幅

IF Highest(High\[1\], Period) \<= Value1 \* (1 \+ Percent / 100\)

Then Condition2 \= True;

// 區間低點不破 \+ 振幅有限 \+ 收盤突破前波高點

IF Condition1 and Condition2

and Close Crosses Over Highest(Close\[1\], Period)

Then Ret \= 1;

Outputfield1(Value1, 2, "前波低點");

Outputfield2(Highest(High\[1\], Period), 2, "前波高點");

**適用場景**：選股 **組合建議**：搭配 \[B1. 蓄勢待發\] 中的 MACD 轉強條件可增加確認

---

### A6. 布林帶寬壓縮突破

**投資智慧**：布林帶寬（BBandWidth）極窄代表股價波動極低、處於蓄勢狀態。當帶寬壓縮至 1.5% 以下，且股價突破布林上軌，往往是爆發性行情的起點。

**核心勝率來源**：

- 帶寬壓縮 \= 市場對股價共識高、供需平衡即將打破  
- 突破上軌 \= 多方主動出擊

**選股條件（兩段組合）**：

1. 布林帶寬 \< 1.5%（低波動壓縮）  
2. 收盤價 \>= 布林上軌（突破）

**可調參數**： | 參數 | 預設值 | 說明 | |------|--------|------| | length | 20 | 布林計算天期 | | width | 1.5 | 帶寬壓縮門檻(%) | | UpperBand | 2 | 布林通道標準差倍數 |

**XScript 實作模組**：

// \=== 模組一：布林帶寬壓縮篩選 \===

Input: length(20, "計算天期");

Input: width(1.5, "帶寬%");

variable: up1(0), down1(0), mid1(0), bbandwidth(0);

up1 \= bollingerband(Close, Length, 2);

down1 \= bollingerband(Close, Length, \-2);

mid1 \= (up1 \+ down1) / 2;

bbandwidth \= 100 \* (up1 \- down1) / mid1;

Condition1 \= bbandwidth \< width;

// \=== 模組二：突破布林上軌 \===

Condition2 \= close \>= bollingerband(Close, Length, 2);

// \=== 組合觸發 \===

if Condition1 and Condition2 then ret \= 1;

**適用場景**：選股、警示 **組合建議**：搭配 \[A4. 暴量剛起漲\] 增加量能確認

---

### A7. 無量變有量

**投資智慧**：一支長期冷門無量的股票（連續 10 天量 \< 500 張），突然今天爆出 2000 張以上的大量。這種「從沉睡中被叫醒」的訊號往往意味著有人開始大量佈局。

**核心勝率來源**：

- 長期無量 \= 市場遺忘、籌碼安定  
- 突然爆量 \= 新資金進場、供需劇變

**選股條件**：

1. 連續 10 天成交量 \<= 500 張  
2. 今日成交量 \> 2000 張

**可調參數**： | 參數 | 預設值 | 說明 | |------|--------|------| | v1 | 500 | 前期成交量上限（張） | | v2 | 2000 | 今日成交量下限（張） |

**XScript 實作模組**：

Input: v1(500, "前一根bar成交量");

Input: v2(2000, "這根bar成交量");

if trueall(volume\[1\] \<= v1, 10\) and volume \> v2

then ret \= 1;

**適用場景**：警示 **組合建議**：務必搭配 \[C5. 大股東站在買方\] 排除利空爆量

---

### A8. 盤整區間突破（簡化版）

**投資智慧**：與 A5 類似但參數更寬鬆——30 日內底部不破、振幅 \< 10%、收盤突破前波高點。適合短線波段操作。

**選股條件**：

1. 30 日區間內低點出現在最早一天（不破底）  
2. 區間高點距低點振幅 \< 10%  
3. 收盤突破前波收盤高點

**XScript 實作模組**：

Input: period(30);

Input: percent(10);

SetInputName(1, "未破底區間");

SetInputName(2, "盤整區間漲幅上限");

Condition1 \= False;

Condition2 \= False;

Value1 \= lowest(low, period);

if Value1 \= low\[period \- 1\]

then Condition1 \= True;

if highest(high\[1\], period) \<= Value1 \* (1 \+ percent / 100\)

then Condition2 \= True;

if Condition1 and Condition2 and close crosses over highest(close\[1\], period)

then ret \= 1;

**適用場景**：選股 **組合建議**：可疊加量能條件 `V = highest(V, period)` 增加確認

---

## B. 趨勢動能因子 (Trend / Momentum Indicators)

---

### B1. 蓄勢待發（均線糾結+MACD轉強）

**投資智慧**：當股價同時貼近月線（20MA）和季線（60MA），距離都在 2% 以內，代表短中長期成本趨近一致——這是多空拉鋸的臨界點。此時若 MACD 翻正且遞增，加上創 10 日新高，就是趨勢即將啟動的訊號。

**核心勝率來源**：

- 均線糾結 \= 多空勢均力敵，一旦突破方向明確  
- MACD \> 0 且遞增 \= 中期動能轉多  
- 創 10 日新高 \= 短線已率先表態

**選股條件**：

1. 股價距離 20MA \< 2%  
2. 股價距離 60MA \< 2%  
3. 收盤創 10 日新高  
4. MACD 值 \> 0 且遞增、DIF \> 0

**XScript 實作模組**：

Input: day(10);

Input: FastLength(12, "DIF短期期數"), SlowLength(26, "DIF長期期數"), MACDLength(9, "MACD期數");

variable: difValue(0), macdValue(0), oscValue(0), Kprice(0);

settotalbar(100);

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue, macdValue, oscValue);

if absvalue((average(close, 20\) \- close) / close) \* 100 \< 2

// 股價距離月線不到2%

and absvalue((average(close, 60\) \- close) / close) \* 100 \< 2

// 股價距離季線不到2%

and close \= highest(close, day)

// 股價創10日高點

and macdvalue \> macdvalue\[1\]

and macdvalue \> 0

and difvalue \> 0

then ret \= 1;

**適用場景**：選股 **組合建議**：搭配 \[C1. 籌碼 Elder Force\] 確認主力也在加碼

---

### B2. CMI 趨勢指數轉強

**投資智慧**：CMI（Choppy Market Index）用來判斷市場是趨勢行情還是盤整行情。CMI 連續 3 天 \>= 65 且平均值 \>= 81，代表股票已從盤整進入強趨勢。配合 Bias(7) \< 4 確保不是追高，以及平均成交金額 \>= 0.2 億確保流動性。

**核心勝率來源**：

- CMI 高值 \= 確認趨勢行情（非震盪市）  
- Bias 限制 \= 避免追在短線乖離過大時  
- 成交金額門檻 \= 排除冷門股

**選股條件**：

1. CMI 連續 3 日 \>= 65  
2. CMI 6 日平均 \>= 81  
3. 7 日 Bias \< 4%  
4. 5 日平均成交金額 \>= 0.2 億

**XScript 實作模組**：

Input: Period(10);

Var: CMI(0), AvgCMI(0);

CMI \= 100 \* (C \- C\[Period \- 1\]) / (Highest(H, Period) \- Lowest(L, Period));

AvgCMI \= average(CMI, 6);

if trueall(CMI \>= 65, 3\) and AvgCMI \>= 81 and Bias(7) \< 4

and Average(GetField("成交金額(億)", "D"), 5\) \>= 0.2

then ret \= 1;

**適用場景**：選股、警示 **組合建議**：搭配 \[A1. 低波動壓縮突破\] 可先找壓縮再等趨勢確認

---

### B3. 多頭架構剛轉強

**投資智慧**：利用線性回歸斜率（LinearRegSlope）判斷趨勢方向。當近 5 日股價趨勢線剛從下跌轉為上漲（斜率穿越零軸），且週線、月線、季線斜率全部為正（多頭排列），加上 9K \> 80（超買區強勢），就是多頭架構剛確立的訊號。最後用 `barslast > 10` 確保是 10 日以來第一次符合。

**核心勝率來源**：

- 五日斜率剛轉正 \= 最新短線轉折  
- 三均線斜率全正 \= 中長期趨勢支持  
- 9K \> 80 \= 動能充沛（非弱勢反彈）  
- 10 日內首次 \= 避免重複訊號

**XScript 實作模組**：

variable: rsv1(0), k1(0), d1(0);

stochastic(9, 3, 3, rsv1, k1, d1);

condition1 \= false;

value1 \= average(close, 5);

value2 \= average(close, 20);

value3 \= average(close, 60);

if linearregslope(close, 5\) crosses over 0

// 近五日趨勢線剛由下跌轉成上漲

and linearregslope(value1, 5\) \> 0

and linearregslope(value2, 5\) \> 0

and linearregslope(value3, 5\) \> 0

// 週線、月線及季線斜率都是正的

and k1 \> 80

// 9K大於80

then condition1 \= true;

if condition1

and barslast(condition1)\[1\] \> 10

// 近10日第一次符合

then ret \= 1;

**適用場景**：選股 **組合建議**：搭配 \[C6. 外資投信同步買超\] 雙重確認

---

### B4. 盤整後 MACD 黃金交叉

**投資智慧**：先找 90 日內振幅 \< 10% 的盤整股（排除大漲大跌），再等 MACD 柱狀圖（OSC）由負翻正且力道遞增。這是「長期橫盤後趨勢啟動」的經典訊號。

**核心勝率來源**：

- 90 日振幅 \< 10% \= 長期盤整確認  
- OSC 翻正且遞增 \= MACD 黃金交叉的進階版  
- 連續 5 日量 \> 500 \= 排除無量股

**XScript 實作模組**：

Input: SPeriod(5), LLPeriod(90);

Input: FastLength(12), SlowLength(26), MACDLength(9);

Var: difValue(0), macdValue(0), oscValue(0);

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue, macdValue, oscValue);

Condition1 \= trueall(V \> 500, SPeriod);

// 連續5日成交量 \> 500

Condition2 \= oscValue \> 0 and oscValue\[1\] \< 0

and oscValue\[1\] \> oscValue\[2\]

and oscValue\[0\] \> \-oscValue\[1\];

// MACD黃金交叉且OSC力道遞增

Condition3 \= absvalue(100 \* (Lowest(L, LLPeriod) \- Highest(H, LLPeriod))

/ Highest(H, LLPeriod)) \< 10;

// 90日最高與最低之幅度 \< 10%

Condition99 \= Condition1 and Condition2 and Condition3;

IF Condition99 Then Ret \= 1;

**適用場景**：選股 **組合建議**：可疊加 \[D1. 目標價折價\] 過濾高估值

---

### B5. 回檔到高勝率區間

**投資智慧**：純粹的統計因子——過去 30 天跌幅在 \-70% \~ \-28% 之間的股票，統計上有較高的反彈機率。這是基於歷史數據回測得出的「高勝率回檔區間」。

**核心勝率來源**：

- 完全基於統計回測最佳化後的參數  
- 跌幅過大（\> 70%）的排除（可能是基本面惡化）  
- 跌幅過小（\< 28%）的排除（回檔可能尚未結束）

**XScript 實作模組**：

value1 \= close\[1\] / close\[30\] \- 1;

if value1 \> \-0.703448

and value1 \< \-0.284939047

then ret \= 1;

**適用場景**：選股 **注意**：參數精確到小數點六位，建議搭配基本面因子避免接到基本面變壞的刀

---

## C. 籌碼因子 (Institutional / Smart Money)

---

### C1. 籌碼 Elder Force 指標

**投資智慧**：將 Elder Force Index 概念套用在籌碼上——取「綜合前十大券商買賣超張數」乘以「當日漲跌幅」，再做 EMA 平滑。當這個值處於特定（偏負的）區間時觸發，代表**主力在股價微跌時持續吸貨**（逆勢佈局）。

**核心勝率來源**：

- Elder Force \= 量 × 力（籌碼 × 價格變化）  
- EMA 平滑消除雜訊  
- 偏負區間觸發 \= 主力在股價尚未表態時已經進場

**關鍵公式**：`EMA(前十大券商買賣超 × (C/C[1]-1), N日)`

**可調參數**： | 參數 | 預設值 | 說明 | |------|--------|------| | Up | \-0.0925 | 因子上限 | | Down | \-0.095 | 因子下限 | | Days | 10 | EMA 計算天期 |

**XScript 實作模組**：

Input: Up(-0.0925), Down(-0.095);

Input: Days(10, "計算天期(日)");

SetBarFreq("AD");

SetTotalBar(Days \+ 10);

// 籌碼資料（可替換為其他籌碼主角）

Value11 \= Summation(GetField("綜合前十大券商買賣超張數", "D"), 1);

// 因子計算：籌碼 × 漲跌幅 的 EMA

Value99 \= EMA(Value11 \* (C / C\[1\] \- 1), Days);

If Value99 \>= Down / 100 and Value99 \<= Up / 100 Then Ret \= 1;

**適用場景**：選股 **組合建議**：搭配 \[A1. 低波動壓縮突破\] 等待突破訊號

**籌碼主角可替換清單**（腳本內建 13 個籌碼欄位）：

- 主力買賣超張數、外資買賣超、地緣券商、自營商、投信  
- 官股券商、法人、控盤者、散戶、前十大券商  
- 關聯券商、關鍵券商

---

### C2. 主力籌碼 Chaikin 指標

**投資智慧**：將 Chaikin A/D Oscillator 套用在籌碼上。先用 CLV（Close Location Value）加權主力買賣超，累積成 A/D Line，再取短期 EMA(3) 與長期 EMA(10) 的差值。當差值處於偏負區間（-1.5 \~ \-0.5），代表**主力在股價低檔區默默吸貨**。

**核心勝率來源**：

- CLV 加權 \= 收盤價越接近當日高點，主力買超越有價值  
- A/D 累積 \= 反映長期籌碼流向  
- Chaikin 振盪 \= 短期籌碼動能相對長期的背離/加速

**關鍵公式**：

- `CLV = ((C-L) - (H-C)) / (H-L)`  
- `AD = AD[1] + (CLV × 主力買賣超)`  
- `Factor = EMA(AD, 3) - EMA(AD, 10)`

**可調參數**： | 參數 | 預設值 | 說明 | |------|--------|------| | Up | \-0.5 | 因子上限 | | Down | \-1.5 | 因子下限 | | Days | 1 | 籌碼計算天期 | | Len1 | 3 | EMA 短期 | | Len2 | 10 | EMA 長期 |

**XScript 實作模組**：

Input: Up(-0.5), Down(-1.5);

Input: Days(1, "籌碼計算天期(日)");

Input: Len1(3, "EMA短計算天期(日)");

Input: Len2(10, "EMA長計算天期(日)");

Vars: CLV(0), AD(0);

SetBarFreq("AD");

SetTotalBar(Days \+ Len1 \+ Len2 \+ 10);

// 籌碼主角（預設：主力買賣超）

Value1 \= Summation(GetField("主力買賣超張數", "D"), Days);

Value50 \= Value1;

// 計算 CLV (Close Location Value)

CLV \= ((C \- L) \- (H \- C)) / (H \- L);

// 計算 A/D Line

AD \= AD\[1\] \+ (CLV \* Value50);

// Chaikin 因子

Value99 \= EMA(AD, Len1) \- EMA(AD, Len2);

If Value99 \>= Down and Value99 \<= Up Then Ret \= 1;

**適用場景**：選股 **組合建議**：搭配 \[A5. 區間未破底創新高\] 等待價格確認

---

### C3. 投信沉寂後首次大買

**投資智慧**：投信連續 5 天以上都沒有買超，今天突然買超 500 張以上。這代表投信對這檔股票重新產生興趣，往往是投信開始建倉的第一天。

**核心勝率來源**：

- 長期不買 \= 之前沒有被納入持股  
- 突然大買 \= 新的研究報告給出買進建議、或基本面出現變化

**XScript 實作模組**：

Input: day(5, "連續沒有買超的天數");

value1 \= GetField("投信買賣超", "D");

if trueall(value1\[1\] \<= 0, day) and value1 \> 500

then ret \= 1;

**適用場景**：警示 **組合建議**：搭配 \[D2. EV/EBITDA\] 確保估值不貴

---

### C4. 投信初次進場建倉

**投資智慧**：投信目前持股低於 500 張（= 幾乎沒有持股），但今天買超量超過當日成交量的 20%。這意味著投信從零開始大量建倉，是極強的看好訊號。

**核心勝率來源**：

- 持股極低 \= 全新的佈局，不是既有部位的調整  
- 買超占成交量 20% 以上 \= 投信是當天最主要的買方

**XScript 實作模組**：

Input: v1(500, "投信估計持股上限(張)");

value1 \= GetField("投信持股", "D");

value2 \= GetField("投信買賣超", "D");

if value1 \< v1 and value2 \> VOLUME \* 0.2

then ret \= 1;

**適用場景**：警示 **組合建議**：搭配 \[A3. 整理後創新高\] 確認技術面同步轉強

---

### C5. 大股東站在買方

**投資智慧**：當「最知道公司價值的人」在買進時跟著買。監控五個內部人指標中任一個出現買方訊號：內部人持股比例增加、千張大戶比例增加 0.5% 以上、或關鍵/關聯/地緣券商大量買超。

**核心勝率來源**：

- 內部人增持 \= 公司派看好自家股票  
- 大戶比例增加 \= 大資金認為低估  
- 關鍵/關聯券商 \= 公司派常用分點券商的動向

**XScript 實作模組**：

Input: v1(500, "買超下限張數");

value1 \= GetField("關鍵券商買賣超張數", "D");

value2 \= GetField("關聯券商買賣超張數", "D");

value3 \= GetField("地緣券商買賣超張數", "D");

if GetField("內部人持股比例", "M") \> GetField("內部人持股比例", "M")\[1\]

or GetField("大戶持股比例", "W", param := 1000\) \> GetField("大戶持股比例", "W", param := 1000)\[1\] \+ 0.5

or value1 \>= v1

or value2 \>= v1

or value3 \>= v1

then ret \= 1;

outputfield(1, GetField("內部人持股比例", "M"), 0, "內部人");

outputfield(2, GetField("內部人持股比例", "M")\[1\], 0, "前期內部人");

outputfield(3, value1, 0, "關鍵券商");

outputfield(4, GetField("大戶持股比例", "W", param := 1000), 1, "千張大戶比例");

outputfield(5, GetField("大戶持股比例", "W", param := 1000)\[1\], 1, "前期千張大戶比例");

**適用場景**：選股 **組合建議**：搭配 \[D1. 目標價折價\] 找到大股東在低估時買進的標的

---

### C6. 低價股外資投信同步買超

**投資智慧**：外資和投信同一天各買超 800 張以上，且這是 60 天以來首次同步大買，加上股價 \< 50 元。雙法人罕見同步 \= 極高確信度；低價股 \= 補漲空間大。

**核心勝率來源**：

- 外資+投信同步 \= 兩個獨立研究團隊同時看好  
- 60 日首次 \= 訊號稀缺性高  
- 低價限制 \= 排除已充分反映的高價股

**XScript 實作模組**：

Input: days(60, "計算期間");

Input: M1(800, "最低買超張數");

value1 \= getField("外資買賣超", "D");

value2 \= getField("投信買賣超", "D");

condition1 \= value1 \> M1 and value2 \> M1;

if condition1

and barslast(condition1)\[1\] \>= days

and close \< 50

then ret \= 1;

**適用場景**：選股、警示 **組合建議**：搭配 \[B1. 蓄勢待發\] 確認技術面也剛啟動

---

### C7. 散戶持股比例急遽降低

**投資智慧**：利用集保資料，計算 10 張以下小股東的持股比例在一週之間降低超過 20%。散戶大量出脫 \= 籌碼正在被大戶/法人吸收，是「聰明錢接手」的訊號。

**核心勝率來源**：

- 散戶急售 \= 恐慌出場或被法人洗出  
- 比例急降 \= 籌碼集中化加速

**狀態**：僅有邏輯描述，無完整程式碼。

**實作建議**：

// 需使用集保欄位（每週更新）

// GetField("散戶持股比例", "W") 或類似欄位

// 比較本週與上週的持股變化

**適用場景**：選股（週頻） **組合建議**：搭配 \[C5. 大股東站在買方\] 雙重確認籌碼移轉

---

### C8. 主力默默吸納籌碼

**投資智慧**：尋找主力在股價不動聲色的情況下持續買進的標的。

**狀態**：僅有標題，無程式碼。

**實作建議**：可組合 \[C1. Elder Force\] \+ \[A1. 低波動壓縮\] 來實現類似效果——籌碼因子偏正但股價尚未突破。

---

## D. 價值因子 (Value / Fundamental)

---

### D1. 股價距離目標價折價過大

**投資智慧**：為穩定獲利的公司估算合理目標價——用每股淨值加上近 4 年平均 EPS × 7 倍本益比。當股價低於目標價 40% 以上，代表嚴重低估。前提是連續 7 年 EPS \> 1 且年度差異 \< 1.5（排除景氣循環股）。

**核心勝率來源**：

- 穩定獲利 \= 排除虧損股和暴起暴落的景氣循環股  
- 淨值+盈餘估值 \= 簡單但有效的價值錨定  
- 40% 折價 \= 充分的安全邊際

**關鍵公式**：`目標價 = 每股淨值 + Avg(EPS, 4年) × 7`

**XScript 實作模組**：

var: tp(0);

if highest(GetField("每股稅後淨利(元)", "Y"), 7\) \- lowest(GetField("每股稅後淨利(元)", "Y"), 7\) \< 1.5

and trueall(GetField("每股稅後淨利(元)", "Y") \> 1, 7\)

// 每年EPS差距不大且每年賺錢

then tp \= GetField("每股淨值(元)", "Q") \+ average(GetField("每股稅後淨利(元)", "Y"), 4\) \* 7;

Input: rate(40, "折價比率");

if close \* (1 \+ rate / 100\) \< tp

then ret \= 1;

outputfield(1, tp, 1, "目標價");

outputfield(2, tp / close \- 1, 1, "折價率");

**適用場景**：選股 **組合建議**：搭配 \[C5. 大股東站在買方\] 找到內部人也在低估時增持的標的

---

### D2. EV/EBITDA 低估值篩選

**投資智慧**：企業價值（EV \= 總市值 \+ 負債 \- 現金 \- 短期投資）除以近四季 EBITDA，若 \< 4 代表企業嚴重低估。EV/EBITDA 比 P/E 更能反映企業真實價值，因為排除了資本結構和折舊政策差異。

**核心勝率來源**：

- EV/EBITDA 是全球併購最常用的估值指標  
- \< 4 意味著不到 4 年就能回本  
- 排除 EBITDA \<= 0 的虧損公司

**關鍵公式**：`EV/EBITDA = (總市值×100 + 負債 - 現金 - 短期投資) / Sum(EBITDA, 4季)`

**XScript 實作模組**：

value1 \= GetField("總市值", "D");           // 單位：億

value2 \= GetField("負債總額", "Q");         // 單位：百萬

value3 \= GetField("現金及約當現金", "Q");   // 單位：百萬

value4 \= GetField("短期投資", "Q");         // 單位：百萬

value5 \= GetField("稅前息前折舊前淨利", "Q"); // 單位：百萬

var: pricingm1(0);

Input: bl(4, "上限值");

if value5 \> 0 then begin

    pricingm1 \= (value1 \* 100 \+ value2 \- value3 \- value4) / summation(value5, 4);

    if pricingm1 \< bl and pricingm1 \> 1

    then ret \= 1;

    outputfield(1, pricingm1, 1, "EV/EBITDA");

    outputfield(2, value1 \* 100 \+ value2 \- value3 \- value4, 0, "EV");

    outputfield(3, value5, 0, "EBITDA");

    outputfield(4, value1, 0, "總市值");

    outputfield(5, value2, 0, "負債總額");

    outputfield(6, value3, 0, "現金");

    outputfield(7, value4, 0, "短期投資");

end;

**適用場景**：選股 **組合建議**：搭配 \[A1. 低波動壓縮突破\] 在低估值股中找動能啟動點

---

### D3. GVI 低檔回升

**投資智慧**：GVI（Growth Value Index）= (1/PBR) × (1+ROE)^5。這個指標結合了價值（淨值比倒數）與成長（ROE 五次方放大成長效果）。當 GVI 向上穿越 1.2，代表「用便宜的價格買到高成長」的機會浮現。

**核心勝率來源**：

- PBR 低 \= 價格相對淨值便宜  
- ROE 高 \= 企業賺錢效率好  
- Cross Over 1.2 \= 轉折訊號，代表成長/價值比剛進入甜蜜點

**關鍵公式**：`GVI = (1/PBR) × (1+ROE)^5`

**XScript 實作模組**：

value1 \= GetField("股價淨值比", "D");

value2 \= GetField("股東權益報酬率", "Q");

var: GVI(0);

GVI \= 1 / value1 \* (1 \+ value2) \* (1 \+ value2) \* (1 \+ value2) \* (1 \+ value2) \* (1 \+ value2);

if GVI cross over 1.2

then ret \= 1;

**適用場景**：選股 **組合建議**：搭配 \[C3. 投信沉寂後首次大買\] 尋找法人剛開始注意的便宜成長股

---

### D4. 市值營收比偏低

**投資智慧**：總市值 / 年營收 \< 1，代表市場對這家公司的估值低於它一年創造的營收。這在成長型產業中特別有意義——市場可能低估了營收轉化為獲利的潛力。

**核心勝率來源**：

- PSR（Price-to-Sales Ratio）\< 1 \= 營收被嚴重低估  
- 適合還在虧損但營收高速成長的公司

**XScript 實作模組**：

value1 \= getField("總市值(億)", "D");

value2 \= getField("營業收入淨額", "Y"); // 單位：百萬

value3 \= (value1 \* 100\) / value2;        // 總市值營收比

Input: ratio(1, "總市值營收比");

if value3 \< ratio then ret \= 1;

**適用場景**：選股 **組合建議**：搭配 \[D6. 研發費用市值比高\] 找到高研發投入但被低估的成長股

---

### D5. 股價距離 DCF 合理價偏低

**投資智慧**：以 DCF（現金流折現）概念估算合理價——假設未來 10 年營業利益以 3% 成長率、2% 折現率計算，加上每股淨值作為清算價值。當市價 / (淨值 \+ 折現營業利益) \< 1 時觸發。前提是連續 5 年營業利益為正且波動 \< 50%。

**核心勝率來源**：

- DCF 估值 \= 最嚴謹的內在價值評估  
- 連續 5 年正營業利益 \+ 波動 \< 50% \= 穩定經營的護城河  
- 市價低於合理價 \= 安全邊際

**關鍵公式**：`合理價 = 每股淨值 + Σ(營業利益 × (1+g)^n / (1+r)^n) / 股本`

**XScript 實作模組**：

variable: idx(0), t(0);

Input: r1(3, "假設未來十年營業利益年成長率");

Input: r2(2, "未來十年平均年利率");

Input: r3(100, "未來獲利折現合計淨值與市價比");

value1 \= GetField("營業利益", "Y");       // 單位：百萬

value2 \= GetField("最新股本");            // 單位：億

value3 \= GetField("每股淨值(元)", "Y");

value11 \= maxlist(GetField("營業利益", "Y"), GetField("營業利益", "Y")\[1\], GetField("營業利益", "Y")\[2\], GetField("營業利益", "Y")\[3\], GetField("營業利益", "Y")\[4\]);

value12 \= minlist(GetField("營業利益", "Y"), GetField("營業利益", "Y")\[1\], GetField("營業利益", "Y")\[2\], GetField("營業利益", "Y")\[3\], GetField("營業利益", "Y")\[4\]);

if trueall(value1 \> 0, 5\) and (value11 \- value12) / value11 \< 0.5 then begin

    t \= 0;

    for idx \= 1 to 10 begin

        t \= t \+ value1 \* power(1 \+ r1 / 100, idx) / power(1 \+ r2 / 100, idx);

    end;

    // t=百萬, value2=億, 換成每股

    value5 \= t / value2 / 100;

    value6 \= close / (value3 \+ value5);

    if value6 \< r3 / 100

    then ret \= 1;

end;

outputfield(1, value5, 2, "估算每股營業利益");

outputfield(2, value6, 1, "市價/淨值比", order := \-1);

**適用場景**：選股 **組合建議**：搭配 \[C5. 大股東站在買方\] 確認內部人也認為被低估

---

### D6. 研發費用市值比高

**投資智慧**：研發費用 / 總市值 \> 15%，代表公司將大量資源投入創新。高研發投入是未來競爭力的領先指標，若市場尚未給予溢價（市值偏低），就是潛在的低估機會。

**核心勝率來源**：

- 研發密集度高 \= 技術護城河深  
- 市值未反映 \= 市場低估未來成長

**XScript 實作模組**：

value1 \= getField("總市值(億)", "D");

value2 \= getField("研發費用", "Y"); // 百萬

value3 \= value2 / (value1 \* 100\) \* 100;

if value3 \> 15 then ret \= 1;

**適用場景**：選股 **組合建議**：搭配 \[D4. 市值營收比\] 找到營收高但市值低的研發型公司

---

## E. 複合因子 (Composite / Multi-Factor)

---

### E1. 創百日高（價量+壓縮+大盤）

**投資智慧**：與 A2 類似但回看期更長（100 日），歷史回測數據顯示 2015-2020 期間勝率 68.99%、129 次交易、總報酬 51.11%。是經過驗證的穩健策略。

**回測績效（2015/04-2020/04）**： | 指標 | 數值 | |------|------| | 總交易次數 | 129 | | 勝率 | 68.99% | | 總報酬率 | 51.11% | | 平均報酬率 | 0.40% | | 最大單筆獲利 | 12.25% | | 最大單筆虧損 | \-12.26% | | 最大連續虧損 | \-11.19% | | 最大區間獲利 | 76.24% |

**XScript 實作模組**：

Input: SPeriod(13), LPeriod(100);

Condition1 \= trueall(V \> 500, 5);

// 連續5日成交量 \> 500

Condition20 \= H \= Highest(H, LPeriod);

Condition2 \= Condition20 and Not Condition20\[1\];

// 創百日新高（第一次）

Condition3 \= (Highest(C, SPeriod) \- Lowest(C, SPeriod)) / Lowest(C, SPeriod) \< 0.05;

// 區間壓縮

Condition4 \= V \= Highest(V, SPeriod);

// 創區間大量

Condition100 \= Condition1 and Condition2 and Condition3 and Condition4;

If Condition100 Then Ret \= 1;

**適用場景**：選股

---

### E2. 基本面好轉 \+ 出量創新高

**投資智慧**：結合 A1 的價量突破模式（收盤+量同創新高、區間壓縮）搭配基本面改善訊號。原始碼僅包含技術面部分，建議搭配毛利率/營收成長條件使用。

**狀態**：技術面程式碼同 A1，需自行加入基本面條件。

**實作建議**：在 A1 基礎上加入：

// 加入基本面條件範例

and GetField("營收月增率", "M") \> 0

and GetField("毛利率", "Q") \> GetField("毛利率", "Q")\[1\]

---

### E3. 高現金殖利率 \+ 營收成長

**投資智慧**：現金股利殖利率 \> 7%（高股息防禦）且連續 2 個月營收年增率 \> 5%（成長確認）。「高息+成長」是攻守兼備的選股策略。

**狀態**：僅有邏輯描述，無完整程式碼。

**實作建議**：

// 高現金殖利率

Condition1 \= GetField("現金股利殖利率", "D") \> 7;

// 連續2個月營收年增率 \> 5%

Condition2 \= trueall(GetField("月營收年增率", "M") \> 5, 2);

if Condition1 and Condition2 then ret \= 1;

**適用場景**：選股 **組合建議**：搭配 \[D2. EV/EBITDA\] 排除高配息但高負債的地雷股

---

### E4. 連續兩季毛利率成長 \+ 月營收創新高

**投資智慧**：毛利率連續提升 \= 產品競爭力增強或成本優化；月營收創 13 個月新高 \= 需求面持續擴張。兩者同時出現代表公司進入「量價齊揚」的最佳經營狀態。

**狀態**：僅有標題描述，無完整程式碼。

**實作建議**：

// 連續兩季毛利率成長

Condition1 \= GetField("毛利率", "Q") \> GetField("毛利率", "Q")\[1\]

         and GetField("毛利率", "Q")\[1\] \> GetField("毛利率", "Q")\[2\];

// 月營收創13個月新高

Condition2 \= GetField("月營收", "M") \= Highest(GetField("月營收", "M"), 13);

if Condition1 and Condition2 then ret \= 1;

**適用場景**：選股 **組合建議**：搭配 \[B1. 蓄勢待發\] 等待技術面的啟動訊號

---

## 附錄：因子速查矩陣

### 依策略風格速查

| 策略風格 | 推薦因子組合 |
| :---- | :---- |
| 底部抄底 | A4 暴量起漲 \+ C3 投信首次大買 \+ D1 目標價折價 |
| 突破追漲 | A2 價量新高 \+ B2 CMI轉強 \+ C1 Elder Force |
| 價值投資 | D2 EV/EBITDA \+ D5 DCF合理價 \+ C5 大股東買方 |
| 盤整等突破 | A6 布林壓縮 \+ B1 蓄勢待發 \+ A5 未破底創新高 |
| 法人跟單 | C3 投信首次大買 \+ C4 投信建倉 \+ C6 雙法人同步 |
| 股息防禦 | E3 高殖利率+營收 \+ D3 GVI回升 \+ D4 市值營收比 |
| 成長獵手 | E4 毛利率+營收 \+ D6 研發費用比 \+ A3 整理後新高 |

### 依觸發頻率速查

| 頻率 | 因子 |
| :---- | :---- |
| 盤中即時 | A7 無量變有量、C3 投信首次大買、C4 投信建倉 |
| 每日收盤 | A1~~A6、B1~~B4、C1~~C2、C5~~C6 |
| 每週更新 | C7 散戶持股、D3 GVI |
| 每季更新 | D1 目標價、D2 EV/EBITDA、D5 DCF、E4 毛利率 |

---

本文件由高勝率腳本反向工程產生，共萃取 **28 個因子模組**（含 4 個待補完） 來源：高勝率因子腳本.txt（35 支策略腳本） 用途：上傳至 AI 知識庫作為策略組裝的積木庫  
