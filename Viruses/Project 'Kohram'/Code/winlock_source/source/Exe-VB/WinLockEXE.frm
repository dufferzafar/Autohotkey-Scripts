VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form MainFrm 
   Caption         =   "WinLock"
   ClientHeight    =   4260
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5085
   LinkTopic       =   "Form1"
   ScaleHeight     =   4260
   ScaleWidth      =   5085
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame Keys 
      BorderStyle     =   0  'None
      Caption         =   "Keys"
      Height          =   2775
      Left            =   240
      TabIndex        =   7
      Top             =   480
      Width           =   4575
      Begin VB.CheckBox Disable_CtrlAltDel 
         Caption         =   "Disable Ctrl+Alt+Del, Ctrl+Shift+Esc (Win NT, 2K)"
         Height          =   375
         Left            =   120
         TabIndex        =   13
         Top             =   2160
         Width           =   3975
      End
      Begin VB.CheckBox Disable_TaskMgr 
         Caption         =   "Disable Task Manager (Win NT, 2K)"
         Height          =   375
         Left            =   120
         TabIndex        =   12
         Top             =   1776
         Width           =   3975
      End
      Begin VB.CheckBox Disable_TaskSwitching 
         Caption         =   "Disable Task Switching Keys (Win NT, 2K)"
         Height          =   375
         Left            =   120
         TabIndex        =   11
         Top             =   1392
         Width           =   3975
      End
      Begin VB.CheckBox Disable_AltTab2 
         Caption         =   "Disable Alt+Tab, Alt+Esc (Win NT, 2K)"
         Height          =   375
         Left            =   120
         TabIndex        =   10
         Top             =   1008
         Width           =   3975
      End
      Begin VB.CheckBox Disable_AltTab1 
         Caption         =   "Disable Alt+Tab, Alt+Esc (Win ?)"
         Height          =   375
         Left            =   120
         TabIndex        =   9
         Top             =   624
         Width           =   3975
      End
      Begin VB.CheckBox Disable_AllKeys 
         Caption         =   "Disable all special keys (Win 9x)"
         Height          =   375
         Left            =   120
         TabIndex        =   8
         Top             =   240
         Width           =   3975
      End
   End
   Begin VB.Frame Hide 
      BorderStyle     =   0  'None
      Caption         =   "Hide"
      Height          =   2775
      Left            =   240
      TabIndex        =   2
      Top             =   480
      Width           =   4575
      Begin VB.CheckBox Hide_DeskProcess 
         Caption         =   "Run process in new desktop (Win NT, 2K, XP)"
         Height          =   375
         Left            =   120
         TabIndex        =   14
         Top             =   1776
         Width           =   3855
      End
      Begin VB.CheckBox Hide_SystemClock 
         Caption         =   "Hide System Clock (Win 9x, NT, 2K, XP)"
         Height          =   375
         Left            =   120
         TabIndex        =   6
         Top             =   1392
         Width           =   3375
      End
      Begin VB.CheckBox Hide_Taskbar 
         Caption         =   "Hide Taskbar (Win 9x, NT, 2K, XP)"
         Height          =   375
         Left            =   120
         TabIndex        =   5
         Top             =   1008
         Width           =   3375
      End
      Begin VB.CheckBox Hide_StartButton 
         Caption         =   "Hide Start Button (Win 9x, NT, 2K, XP)"
         Height          =   375
         Left            =   120
         TabIndex        =   4
         Top             =   624
         Width           =   3375
      End
      Begin VB.CheckBox Hide_Desktop 
         Caption         =   "Hide Desktop (Win 9x, NT, 2K, XP)"
         Height          =   375
         Left            =   120
         TabIndex        =   3
         Top             =   240
         Width           =   3375
      End
   End
   Begin VB.CommandButton Exit 
      Caption         =   "Exit"
      Height          =   495
      Left            =   1815
      TabIndex        =   1
      Top             =   3600
      Width           =   1455
   End
   Begin MSComctlLib.TabStrip Tab 
      Height          =   3255
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   4815
      _ExtentX        =   8493
      _ExtentY        =   5741
      _Version        =   393216
      BeginProperty Tabs {1EFB6598-857C-11D1-B16A-00C0F0283628} 
         NumTabs         =   2
         BeginProperty Tab1 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "Hide"
            Object.Tag             =   "Hide"
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab2 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "Keys"
            Object.Tag             =   "Keys"
            ImageVarType    =   2
         EndProperty
      EndProperty
   End
End
Attribute VB_Name = "MainFrm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'************************************************************
'* WinLock - Lock Desktop, Taskbar and disable Ctrl+Alt+Del *
'*           and task switching keys.                       *
'*                                                          *
'*(c) A. Miguel Feijão, 8/12/2004                           *
'************************************************************

Option Explicit

' Functions inside the DLL
Private Declare Function Desktop_Show_Hide Lib "WinLockDll.dll" (ByVal bShowHide As Boolean) As Integer
Private Declare Function StartButton_Show_Hide Lib "WinLockDll.dll" (ByVal bShowHide As Boolean) As Integer
Private Declare Function Taskbar_Show_Hide Lib "WinLockDll.dll" (ByVal bShowHide As Boolean) As Integer
Private Declare Function Clock_Show_Hide Lib "WinLockDll.dll" (ByVal bShowHide As Boolean) As Integer
Private Declare Function Process_Desktop Lib "WinLockDll.dll" (ByVal szDesktopName As String, ByVal szPath As String) As Integer
Private Declare Function Keys_Enable_Disable Lib "WinLockDll.dll" (ByVal bEnableDisable As Boolean) As Integer
Private Declare Function AltTab1_Enable_Disable Lib "WinLockDll.dll" (ByVal bEnableDisable As Boolean) As Integer
Private Declare Function AltTab2_Enable_Disable Lib "WinLockDll.dll" (ByVal hWnd As Long, ByVal bEnableDisable As Boolean) As Integer
Private Declare Function TaskSwitching_Enable_Disable Lib "WinLockDll.dll" (ByVal bEnableDisable As Boolean) As Integer
Private Declare Function TaskManager_Enable_Disable Lib "WinLockDll.dll" (ByVal bEnableDisable As Boolean) As Integer
Private Declare Function CtrlAltDel_Enable_Disable Lib "WinLockDll.dll" (ByVal bEnableDisable As Boolean) As Integer

Private Sub Form_Load()
    Me![Hide].Visible = True
    Me![Keys].Visible = False
End Sub

Private Sub Exit_Click()
    ' Enable everything before quitting
    Desktop_Show_Hide (True)
    StartButton_Show_Hide (True)
    Taskbar_Show_Hide (True)
    Clock_Show_Hide (True)
    Keys_Enable_Disable (True)
    AltTab1_Enable_Disable (True)
    AltTab2_Enable_Disable 0, True
    TaskSwitching_Enable_Disable (True)
    TaskManager_Enable_Disable (True)
    CtrlAltDel_Enable_Disable (True)

    ' Close app
    Unload MainFrm
End Sub

Private Sub Tab_Click()
    If Me![Tab].SelectedItem = "Hide" Then
        Me![Hide].Visible = True
        Me![Keys].Visible = False
    Else
        Me![Hide].Visible = False
        Me![Keys].Visible = True
    End If
End Sub

Private Sub Hide_Desktop_Click()
    If Me![Hide_Desktop] Then
        Desktop_Show_Hide (False)
    Else
        Desktop_Show_Hide (True)
    End If
End Sub

Private Sub Hide_StartButton_Click()
    If Me![Hide_StartButton] Then
        StartButton_Show_Hide (False)
    Else
        StartButton_Show_Hide (True)
    End If
End Sub

Private Sub Hide_Taskbar_Click()
    If Me![Hide_Taskbar] Then
        Taskbar_Show_Hide (False)
     Else
        Taskbar_Show_Hide (True)
    End If
End Sub

Private Sub Hide_SystemClock_Click()
    If Me![Hide_SystemClock] Then
        Clock_Show_Hide (False)
    Else
        Clock_Show_Hide (True)
    End If
End Sub

Private Sub Hide_DeskProcess_Click()
    If Me![Hide_DeskProcess] Then
        Process_Desktop "MyDesktop2", "Calc.exe"
    Else
        
    End If
End Sub

Private Sub Disable_AllKeys_Click()
    If Me![Disable_AllKeys] Then
        Keys_Enable_Disable (False)
    Else
        Keys_Enable_Disable (True)
    End If
End Sub

Private Sub Disable_AltTab1_Click()
    If Me![Disable_AltTab1] Then
        AltTab1_Enable_Disable (False)
    Else
        AltTab1_Enable_Disable (True)
    End If
End Sub

Private Sub Disable_AltTab2_Click()
    If Me![Disable_AltTab2] Then
        AltTab2_Enable_Disable 0, False
    Else
        AltTab2_Enable_Disable 0, True
    End If
End Sub

Private Sub Disable_TaskSwitching_Click()
    If Me![Disable_TaskSwitching] Then
        TaskSwitching_Enable_Disable (False)
    Else
        TaskSwitching_Enable_Disable (True)
    End If
End Sub

Private Sub Disable_TaskMgr_Click()
    If Me![Disable_TaskMgr] Then
        TaskManager_Enable_Disable (False)
    Else
        TaskManager_Enable_Disable (True)
    End If
End Sub

Private Sub Disable_CtrlAltDel_Click()
    If Me![Disable_CtrlAltDel] Then
        CtrlAltDel_Enable_Disable (False)
    Else
        CtrlAltDel_Enable_Disable (True)
    End If
End Sub

