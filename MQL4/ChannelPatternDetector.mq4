//+------------------------------------------------------------------+
//|                                       ChannelPatternDetector.mq4 |
//| 				                 Copyright © 2014-2016, EarnForex.com |
//|                                       https://www.earnforex.com/ |
//+------------------------------------------------------------------+
#property copyright "EarnForex.com"
#property link      "https://www.earnforex.com/metatrader-indicators/Channel-Pattern-Detector/"
#property indicator_chart_window
#property version "1.01"

#property description "Finds channels and marks them with lines."
#property description "Uses OBJ_TREND objects."
#property description "1. Detects and draws 3-point lines."
#property description "2. Finds pairs, hides unpaired lines."
#property description "3. Finds pairs that form channels, hides non-channel lines."
#property description "Can send email, sound and visual alerts if enabled."
#property description "Uses objects' descriptions to store data."
#property description "WARNING: This indicator can remove your objects and chart's comment."

#include "iChartPatternDetector.mqh"

input double Threshold = 0.007; // Threshold (as multiplier of (Highest - Lowest) @ LookBack)
input int MinBars = 10; // MinBars (minimum number of bars for a line)
input int MaxBars = 150; // MaxBars (maximum number of bars for a line)
input double Symmetry = 0.25; // Symmetry (symmetry coefficient for middle point location. 1 - maximum symmetry, 0 - minimum.)
input double PairMatchingRatio = 0.7; // PairMatchingRatio (how equal should be the lines' length for them to count as pair? 1 - same length, 0 - any length.)
input double AngleDifference = 0.0007; // AngleDifference (maximum angle difference for channel lines. As multiplier of (Highest - Lowest) @ LookBack.)
input string NamePrefix = "LF-";
input int LookBack = 150; // LookBack (how many bars to look back?)
input color ColorSupportUp = clrLimeGreen;
input color ColorSupportDown = clrRed;
input color ColorResistanceUp = clrGreen;
input color ColorResistanceDown = clrMagenta;
input bool EmailAlert = false;
input bool SoundAlert = false;
input bool VisualAlert = false;

CChartPatternDetector* CPD;

void init()
{
   Comment("ChannelPatternDetector");
   CPD = new CChartPatternDetector(PairMatchingRatio, LookBack, NamePrefix, ColorSupportUp, ColorSupportDown, ColorResistanceUp, ColorResistanceDown, EmailAlert, SoundAlert, VisualAlert);
}

void deinit()
{
   CPD.DeleteObjects();
   delete CPD;
   Comment("");
}

int start()
{
   int limit = Bars;
   int IC = IndicatorCounted();
   if (IC >= 0) limit = Bars - IC - 1;
   // Launches only on new bars. Does not use latest (current) bar in calculations.
   if (limit > 0)
   {
      CPD.FindLines(Threshold, MinBars, MaxBars, Symmetry, limit);
      CPD.FilterPairs();
      CPD.FilterChannels(AngleDifference);
   }
   return(0);
}
//+------------------------------------------------------------------+