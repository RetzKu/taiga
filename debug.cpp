/*
** Taiga, a lightweight client for MyAnimeList
** Copyright (C) 2010, Eren Okka
** 
** This program is free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
** 
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
** 
** You should have received a copy of the GNU General Public License
** along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "std.h"
#include "announce.h"
#include "common.h"
#include "dlg/dlg_main.h"
#include "recognition.h"
#include "resource.h"
#include "settings.h"
#include "string.h"
#include "taiga.h"
#include "theme.h"
#include "ui/ui_taskbar.h"

class CDebugTest {
public:
  CDebugTest() : m_dwTick(0) {}
  void Start();
  void End(wstring str, BOOL show);
private:
  DWORD m_dwTick;
};
CDebugTest Test;

// =============================================================================

void DebugTest() {
  // Start ticking
  Test.Start();

  // Define variables
  CEpisode episode;
  int value = 0;
  wstring str;

  for (int i = 0; i < 50000; i++) {
    // Old: 562
    //Meow.ExamineTitleEx(L"[Eclipse] Fullmetal Alchemist Brotherhood - 48 (1280x720 h264) [979D4FA5].mkv", episode, true, true, true, true, true);

    // New: 483 -> 546 -> 531 -> 702 -> 624 -> 608 -> 686 -> 639 -> 624 -> 655 -> 608 -> 592
    //Meow.ExamineTitle(L"[Eclipse] Fullmetal Alchemist Brotherhood - 48v2 (1280x720 h264) [979D4FA5].mkv", episode, true, true, true, true, true);

    // 
    //Meow.ExamineTitle(L"[Eclipse] Fullmetal Alchemist Brotherhood - 48 (1280x720 h264) [979D4FA5].mkv", episode, false, false, true, false, true);
  }

  // Show result
  //str = episode.Title;
  Test.End(str, 0);
  //ExecuteAction(L"About");
  ExecuteAction(L"RecognitionTest");
  //ExecuteAction(L"SearchAnime(fullmetal)");
}

// =============================================================================

void CDebugTest::Start() {
  m_dwTick = GetTickCount();
}

void CDebugTest::End(wstring str, BOOL show) {
  m_dwTick = GetTickCount() - m_dwTick;
  str = ToWSTR(m_dwTick) + L" ms | Text: [" + str + L"]";
  if (show) MainWindow.SetText(str.c_str());
}