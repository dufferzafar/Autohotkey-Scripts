#ifndef WINLOCKDLL_H
#define WINLOCKDLL_H

typedef struct _THREAD_DATA
{
	HDESK hDesk;
	char  szDesktopName[20];
} THREAD_DATA;

#ifdef  _DLL_
#define DLL_EXP_IMP __declspec(dllexport)
#else
#define DLL_EXP_IMP __declspec(dllimport)
#endif

DLL_EXP_IMP int WINAPI Desktop_Show_Hide(BOOL bShowHide);
DLL_EXP_IMP int WINAPI StartButton_Show_Hide(BOOL bShowHide);
DLL_EXP_IMP int WINAPI Taskbar_Show_Hide(BOOL bShowHide);
DLL_EXP_IMP int WINAPI Clock_Show_Hide(BOOL bShowHide);
DLL_EXP_IMP int WINAPI Keys_Enable_Disable(BOOL bEnableDisable);
DLL_EXP_IMP int WINAPI AltTab1_Enable_Disable(BOOL bEnableDisable);
DLL_EXP_IMP int WINAPI AltTab2_Enable_Disable(HWND hWnd, BOOL bEnableDisable);
DLL_EXP_IMP int WINAPI TaskSwitching_Enable_Disable(BOOL bEnableDisable);
DLL_EXP_IMP int WINAPI TaskManager_Enable_Disable(BOOL bEnableDisable);
DLL_EXP_IMP int WINAPI CtrlAltDel_Enable_Disable(BOOL bEnableDisable);
DLL_EXP_IMP int WINAPI Thread_Desktop(LPTHREAD_START_ROUTINE ThreadFunc, THREAD_DATA *td);
DLL_EXP_IMP int WINAPI Process_Desktop(char *szDesktopName, char *szPath);

#endif