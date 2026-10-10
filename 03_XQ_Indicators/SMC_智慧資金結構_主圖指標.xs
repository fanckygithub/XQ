{@type:indicator}
{
    SMC 智慧資金結構 (移植自 LuxAlgo Smart Money Concepts，精簡版 v1)
    主圖疊圖指標，全部為「收盤確認」邏輯，無未來函數。

    內容：
    1. 擺動結構 BOS / CHoCH（連線 PlotLine + 訊號點）
    2. 最新有效 Order Block（多方 / 空方，被收盤穿越即失效）
    3. 最新有效 Fair Value Gap（多方 / 空方，被影線回補即失效）
    4. 強弱高低點 + 中軸 EQ（溢價 / 折價分界）
    5. 等高點 EQH / 等低點 EQL

    與原版差異：
    - 未實作 internal structure（內部結構）、多週期線、OB 波動過濾
    - 以文字標籤取代：BOS / CHoCH 以「不同 Plot 序列 = 不同顏色」區分

    PlotLine 索引：21 多方BOS / 22 多方CHoCH / 23 空方BOS / 24 空方CHoCH / 25 EQH / 26 EQL
    Plot 索引：見檔尾輸出區塊
}

input: swingLen(20, "擺動結構長度");
input: showOB(1, "顯示 Order Block", inputkind:=Dict(["顯示",1],["隱藏",0]), quickedit:=true);
input: showFVG(1, "顯示 FVG", inputkind:=Dict(["顯示",1],["隱藏",0]), quickedit:=true);
input: showZone(1, "顯示強弱高低點與EQ", inputkind:=Dict(["顯示",1],["隱藏",0]), quickedit:=true);
input: showEqHL(1, "顯示等高低點", inputkind:=Dict(["顯示",1],["隱藏",0]), quickedit:=true);
input: fvgFilter(1, "FVG 自動過濾小缺口", inputkind:=Dict(["開啟",1],["關閉",0]));
input: eqThreshold(0.1, "等高低點容差(ATR倍數)");
input: atrLen(50, "ATR 期數");

// ===== 擺動結構狀態 =====
var: legDir(0), prevLeg(0);              // 1=多方腿(剛出低點) 0=空方腿(剛出高點)
var: newLegHigh(false), newLegLow(false);
var: startBear(false), startBull(false); // 確認新高點 / 新低點
var: hiLevel(0), hiBar(0), hiCrossed(true);
var: loLevel(0), loBar(0), loCrossed(true);
var: prevHiLevel(0), prevHiBar(0);
var: prevLoLevel(0), prevLoBar(0);
var: trendBias(0);                       // 1 多頭結構 -1 空頭結構 0 未定
var: bullBreak(false), bearBreak(false);
var: atrVal(0);

// ===== OB 狀態 =====
var: bullObOn(false), bullObTop(0), bullObBot(0);
var: bearObOn(false), bearObTop(0), bearObBot(0);
var: scanN(0), scanIdx(0), obOff(0), extremeVal(0);

// ===== FVG 狀態 =====
var: bullFvgOn(false), bullFvgTop(0), bullFvgBot(0);
var: bearFvgOn(false), bearFvgTop(0), bearFvgBot(0);
var: cumDelta(0), deltaPer(0), fvgThresh(0);
var: isBullFvg(false), isBearFvg(false);

// ===== 強弱高低點 =====
var: trailTop(0), trailBot(0), eqMid(0);

// ===== 訊號點 =====
var: dotBosUp(false), dotChochUp(false), dotBosDn(false), dotChochDn(false);

if CurrentBar > swingLen + 3 then begin

    atrVal = ATR(atrLen);
    dotBosUp = false;
    dotChochUp = false;
    dotBosDn = false;
    dotChochDn = false;

    // ---------- 1. 腿(leg)判定：與 LuxAlgo 相同 ----------
    prevLeg = legDir;
    newLegHigh = High[swingLen] > Highest(High, swingLen);
    newLegLow = Low[swingLen] < Lowest(Low, swingLen);
    if newLegHigh then
        legDir = 0
    else if newLegLow then
        legDir = 1;

    startBear = (legDir = 0) and (prevLeg = 1);
    startBull = (legDir = 1) and (prevLeg = 0);

    // ---------- 2. 登錄新擺動高低點 ----------
    if startBear then begin
        prevHiLevel = hiLevel;
        prevHiBar = hiBar;
        hiLevel = High[swingLen];
        hiBar = CurrentBar - swingLen;
        hiCrossed = false;
        trailTop = hiLevel;
        if showEqHL = 1 and prevHiLevel > 0 and AbsValue(hiLevel - prevHiLevel) < eqThreshold * atrVal then
            PlotLine(25, prevHiBar, prevHiLevel, hiBar, hiLevel, "EQH 等高點", add:=1);
    end;

    if startBull then begin
        prevLoLevel = loLevel;
        prevLoBar = loBar;
        loLevel = Low[swingLen];
        loBar = CurrentBar - swingLen;
        loCrossed = false;
        trailBot = loLevel;
        if showEqHL = 1 and prevLoLevel > 0 and AbsValue(loLevel - prevLoLevel) < eqThreshold * atrVal then
            PlotLine(26, prevLoBar, prevLoLevel, loBar, loLevel, "EQL 等低點", add:=1);
    end;

    // 強弱高低點隨價格延伸
    if CurrentBar = swingLen + 4 then begin
        trailTop = High;
        trailBot = Low;
    end;
    trailTop = MaxList(trailTop, High);
    trailBot = MinList(trailBot, Low);
    eqMid = (trailTop + trailBot) / 2;

    // ---------- 3. 結構突破 BOS / CHoCH (收盤確認) ----------
    bullBreak = hiLevel > 0 and (not hiCrossed) and Close > hiLevel;
    bearBreak = loLevel > 0 and (not loCrossed) and Close < loLevel;

    if bullBreak then begin
        hiCrossed = true;
        if trendBias = -1 then begin
            PlotLine(22, hiBar, hiLevel, CurrentBar, hiLevel, "多方 CHoCH", add:=1);
            dotChochUp = true;
        end else begin
            PlotLine(21, hiBar, hiLevel, CurrentBar, hiLevel, "多方 BOS", add:=1);
            dotBosUp = true;
        end;
        trendBias = 1;

        // 多方 OB：突破前，擺動高點到現在之間的最低價 K 棒
        scanN = MinList(CurrentBar - hiBar + 1, 300);
        extremeVal = Low;
        obOff = 0;
        for scanIdx = 0 to scanN - 1 begin
            if Low[scanIdx] < extremeVal then begin
                extremeVal = Low[scanIdx];
                obOff = scanIdx;
            end;
        end;
        bullObTop = High[obOff];
        bullObBot = Low[obOff];
        bullObOn = true;
    end;

    if bearBreak then begin
        loCrossed = true;
        if trendBias = 1 then begin
            PlotLine(24, loBar, loLevel, CurrentBar, loLevel, "空方 CHoCH", add:=1);
            dotChochDn = true;
        end else begin
            PlotLine(23, loBar, loLevel, CurrentBar, loLevel, "空方 BOS", add:=1);
            dotBosDn = true;
        end;
        trendBias = -1;

        // 空方 OB：突破前，擺動低點到現在之間的最高價 K 棒
        scanN = MinList(CurrentBar - loBar + 1, 300);
        extremeVal = High;
        obOff = 0;
        for scanIdx = 0 to scanN - 1 begin
            if High[scanIdx] > extremeVal then begin
                extremeVal = High[scanIdx];
                obOff = scanIdx;
            end;
        end;
        bearObTop = High[obOff];
        bearObBot = Low[obOff];
        bearObOn = true;
    end;

    // OB 失效：收盤穿越
    if bullObOn and Close < bullObBot then bullObOn = false;
    if bearObOn and Close > bearObTop then bearObOn = false;

    // ---------- 4. FVG ----------
    deltaPer = 0;
    if Open[1] <> 0 then deltaPer = (Close[1] - Open[1]) / Open[1] * 100;
    cumDelta = cumDelta + AbsValue(deltaPer);
    fvgThresh = 0;
    if fvgFilter = 1 then fvgThresh = cumDelta / CurrentBar * 2;

    isBullFvg = Low > High[2] and Close[1] > High[2] and deltaPer > fvgThresh;
    isBearFvg = High < Low[2] and Close[1] < Low[2] and (-1 * deltaPer) > fvgThresh;

    // 失效：影線回補
    if bullFvgOn and Low < bullFvgBot then bullFvgOn = false;
    if bearFvgOn and High > bearFvgTop then bearFvgOn = false;

    if isBullFvg then begin
        bullFvgTop = Low;
        bullFvgBot = High[2];
        bullFvgOn = true;
    end;
    if isBearFvg then begin
        bearFvgTop = Low[2];
        bearFvgBot = High;
        bearFvgOn = true;
    end;

    // ---------- 5. 輸出 ----------
    // Plot1~4 OB
    if showOB = 1 and bullObOn then begin
        Plot1(bullObTop, "多方OB上緣");
        Plot2(bullObBot, "多方OB下緣");
    end else begin
        NoPlot(1);
        NoPlot(2);
    end;
    if showOB = 1 and bearObOn then begin
        Plot3(bearObTop, "空方OB上緣");
        Plot4(bearObBot, "空方OB下緣");
    end else begin
        NoPlot(3);
        NoPlot(4);
    end;

    // Plot5~8 FVG
    if showFVG = 1 and bullFvgOn then begin
        Plot5(bullFvgTop, "多方FVG上緣");
        Plot6(bullFvgBot, "多方FVG下緣");
    end else begin
        NoPlot(5);
        NoPlot(6);
    end;
    if showFVG = 1 and bearFvgOn then begin
        Plot7(bearFvgTop, "空方FVG上緣");
        Plot8(bearFvgBot, "空方FVG下緣");
    end else begin
        NoPlot(7);
        NoPlot(8);
    end;

    // Plot9~11 強弱高低點與EQ
    if showZone = 1 and trailTop > 0 then begin
        Plot9(trailTop, "強弱高點");
        Plot10(eqMid, "EQ中軸");
        Plot11(trailBot, "強弱低點");
    end else begin
        NoPlot(9);
        NoPlot(10);
        NoPlot(11);
    end;

    // Plot12~15 結構訊號點 (多方畫在K棒下方，空方畫在K棒上方)
    if dotBosUp then Plot12(Low - atrVal * 0.5, "多方BOS") else NoPlot(12);
    if dotChochUp then Plot13(Low - atrVal * 0.5, "多方CHoCH") else NoPlot(13);
    if dotBosDn then Plot14(High + atrVal * 0.5, "空方BOS") else NoPlot(14);
    if dotChochDn then Plot15(High + atrVal * 0.5, "空方CHoCH") else NoPlot(15);

end;
