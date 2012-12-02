/******************************************************************
 * WinLock - Lock Desktop, Taskbar and disable Ctrl+Alt+Del       *
 *           and task switching keys.                             *
 *                                                                *
 * (c) A. Miguel Feijão, 1/12/2004                                *
 ******************************************************************/

#define    WIN32_LEAN_AND_MEAN
#define    _WIN32_WINNT 0x0400

#include   <windows.h>
#include   <commctrl.h>
#include   <stdlib.h>
#include   <stdio.h>

#include   "../dll/winlockdll.h"
#include   "resource.h"


#define DESKTOPNAME "MyDesktop2"	// New desktop name

typedef struct _MY_THREAD_DATA
{
	// Data used by Library. Don't change order !
	struct _THREAD_DATA;

	// Add here data for your thread
	char  szMsg[100];
} MY_THREAD_DATA;

MY_THREAD_DATA td;


/***************************************
 * Run this thread in the new desktop. *
 ***************************************/
DWORD WINAPI MyThread(LPVOID lpParameter)
{
	SetThreadDesktop(((MY_THREAD_DATA *)lpParameter)->hDesk);

	MessageBox(NULL, ((MY_THREAD_DATA *)lpParameter)->szMsg, "Desktop", MB_OK);

	return 0;
}


/**************************************************
 * Callback function that handles the messages    *
 * for the PropertySheet windows.                 *
 **************************************************/
BOOL CALLBACK PageProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
    RECT	r;
    int		width, height, cx, cy;
	UINT	state;

	// Handle messages to the property page
	switch (uMsg)
	{
	    // Page about to be displayed for the first time
		case WM_INITDIALOG:
             // Center dialog window on screen.
             width = GetSystemMetrics(SM_CXSCREEN);
             height = GetSystemMetrics(SM_CYSCREEN);
             GetWindowRect(GetParent(hWnd), &r);
             cx = r.right - r.left;
             cy = r.bottom - r.top;
             MoveWindow(GetParent(hWnd), (width - cx)/2, (height - cy)/2, cx, cy, FALSE);
             break;

		// Notification messages from controls
        case WM_COMMAND:
             switch(LOWORD(wParam))
			 {

				 case IDC_DESKTOP:
					  state = IsDlgButtonChecked(hWnd, IDC_DESKTOP);
					  if (!Desktop_Show_Hide(state == BST_UNCHECKED))  
						CheckDlgButton(hWnd, IDC_DESKTOP, state == BST_CHECKED ? BST_UNCHECKED : BST_CHECKED);
				      break;

				 case IDC_STARTBUTTON:
					  state = IsDlgButtonChecked(hWnd, IDC_STARTBUTTON);
					  if (!StartButton_Show_Hide(state == BST_UNCHECKED))
						  CheckDlgButton(hWnd, IDC_STARTBUTTON, state == BST_CHECKED ? BST_UNCHECKED : BST_CHECKED);
					  break;

				 case IDC_TASKBAR:
                      state = IsDlgButtonChecked(hWnd, IDC_TASKBAR);
					  if (!Taskbar_Show_Hide(state == BST_UNCHECKED))
						  CheckDlgButton(hWnd, IDC_TASKBAR, state == BST_CHECKED ? BST_UNCHECKED : BST_CHECKED);
					  break;

				 case IDC_CLOCK:
                      state = IsDlgButtonChecked(hWnd, IDC_CLOCK);
					  if (!Clock_Show_Hide(state == BST_UNCHECKED)) 
						  CheckDlgButton(hWnd, IDC_CLOCK, state == BST_CHECKED ? BST_UNCHECKED : BST_CHECKED);
					  break;

				 case IDC_KEYS:
                      state = IsDlgButtonChecked(hWnd, IDC_KEYS);
					  if (!Keys_Enable_Disable(state == BST_UNCHECKED))
						  CheckDlgButton(hWnd, IDC_KEYS, state == BST_CHECKED ? BST_UNCHECKED : BST_CHECKED);
					  break;

				 case IDC_ALTTAB1:
                      state = IsDlgButtonChecked(hWnd, IDC_ALTTAB1);
					  if (!AltTab1_Enable_Disable(state == BST_UNCHECKED))
						  CheckDlgButton(hWnd, IDC_ALTTAB1, state == BST_CHECKED ? BST_UNCHECKED : BST_CHECKED);
					  break;

				 case IDC_ALTTAB2:
                      state = IsDlgButtonChecked(hWnd, IDC_ALTTAB2);
					  if (!AltTab2_Enable_Disable(NULL, state == BST_UNCHECKED))
						  CheckDlgButton(hWnd, IDC_ALTTAB2, state == BST_CHECKED ? BST_UNCHECKED : BST_CHECKED);
					  break;

				 case IDC_TASKSWITCH:
                      state = IsDlgButtonChecked(hWnd, IDC_TASKSWITCH);
					  if (!TaskSwitching_Enable_Disable(state == BST_UNCHECKED))
						  CheckDlgButton(hWnd, IDC_TASKSWITCH, state == BST_CHECKED ? BST_UNCHECKED : BST_CHECKED);
					  break;

				 case IDC_TASKMGR:
                      state = IsDlgButtonChecked(hWnd, IDC_TASKMGR);
					  if (!TaskManager_Enable_Disable(state == BST_UNCHECKED))
						  CheckDlgButton(hWnd, IDC_TASKMGR, state == BST_CHECKED ? BST_UNCHECKED : BST_CHECKED);
					  break;

				 case IDC_CTRLALTDEL:
                      state = IsDlgButtonChecked(hWnd, IDC_CTRLALTDEL);
					  if (!CtrlAltDel_Enable_Disable(state == BST_UNCHECKED))
						  CheckDlgButton(hWnd, IDC_CTRLALTDEL, state == BST_CHECKED ? BST_UNCHECKED : BST_CHECKED);
					  break;
			 
				 case IDC_DESKTHREAD:
					  // Initialize thread data block
					  strcpy(td.szDesktopName, DESKTOPNAME);
	                  strcpy(td.szMsg, "Message from new desktop !");

					  if (!Thread_Desktop(MyThread, (THREAD_DATA *)&td))
						  CheckDlgButton(hWnd, IDC_DESKTHREAD, BST_UNCHECKED);
					  break;
			 
				 case IDC_DESKPROCESS:
					  if (!Process_Desktop(DESKTOPNAME, "Calc.exe"))
						  CheckDlgButton(hWnd, IDC_DESKPROCESS, BST_UNCHECKED);
					  break;
			 }
			 break;

		// Notification messages for Property pages
		case WM_NOTIFY:
			 switch (((LPNMHDR)lParam)->code)
             {
                 case PSN_APPLY:	// User pressed Ok or Apply
				 case PSN_RESET:	// User pressed Cancel
					  // Enable everything before quitting					  
					  Desktop_Show_Hide(TRUE);  
					  StartButton_Show_Hide(TRUE);
                      Taskbar_Show_Hide(TRUE); 
                      Clock_Show_Hide(TRUE); 
                      Keys_Enable_Disable(TRUE);
                      AltTab1_Enable_Disable(TRUE);
                      AltTab2_Enable_Disable(NULL, TRUE); 
                      TaskSwitching_Enable_Disable(TRUE);
                      TaskManager_Enable_Disable(TRUE); 
                      CtrlAltDel_Enable_Disable(TRUE); 

					  SetWindowLong(hWnd, DWL_MSGRESULT, FALSE);
					  return TRUE;
             }
		     break;

	}//switch(uMsg)

	return FALSE;
}


/*****************************************
 * Program entry point.                  *
 *****************************************/
int WINAPI WinMain(HINSTANCE hInstance, 
                   HINSTANCE hPrevInstance, 
                   LPSTR lpCmdLine, 
                   int nCmdShow)
{
    MSG						msg;		// MSG struct for message loop
   	INITCOMMONCONTROLSEX	icc;		// Struct for common controls (property pages) initialization
	PROPSHEETHEADER			psh;		// Property sheet header struct
	PROPSHEETPAGE			psp[2];		// Property page struct
	HWND					hControl;	// Property sheet control handle 


	// Initialize common control for propoerty sheets
	icc.dwSize = sizeof(INITCOMMONCONTROLSEX);
	icc.dwICC = ICC_BAR_CLASSES;
	InitCommonControlsEx(&icc);

	// Create page 0
	ZeroMemory(&psp[0], sizeof(PROPSHEETPAGE));
	psp[0].dwSize = sizeof(PROPSHEETPAGE);
	psp[0].hInstance = hInstance;
	psp[0].pszTemplate = MAKEINTRESOURCE(IDD_HIDE);
	psp[0].pfnDlgProc = PageProc;

	// Create page 1
	ZeroMemory(&psp[1], sizeof(PROPSHEETPAGE));
	psp[1].dwSize = sizeof(PROPSHEETPAGE);
	psp[1].hInstance = hInstance;
	psp[1].pszTemplate = MAKEINTRESOURCE(IDD_KEYS);
	psp[1].pfnDlgProc = PageProc;

	// Create control
	ZeroMemory(&psh, sizeof(PROPSHEETHEADER));
	psh.dwSize = sizeof(PROPSHEETHEADER);
	psh.dwFlags = PSH_PROPSHEETPAGE | PSH_MODELESS | PSH_NOAPPLYNOW | 0x02000000; // | PSH_NOCONTEXTHELP;
	psh.hInstance = hInstance;
	psh.pszCaption = "WinLock";
	psh.nPages = 2;
	psh.ppsp = (LPCPROPSHEETPAGE) &psp;

	hControl = (HWND)PropertySheet(&psh);

	// Main loop
	while (GetMessage(&msg, NULL, 0, 0))
	{
		if (!PropSheet_IsDialogMessage(hControl, &msg))
		{
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
		if (!PropSheet_GetCurrentPageHwnd(hControl))
		{
			DestroyWindow(hControl);
			PostQuitMessage(0);
		}
	}

    return 0;
}
