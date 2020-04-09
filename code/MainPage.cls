VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "MainPage"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'======================================
'   ҳ�������
    Dim Page As GPage
    Dim UITime As Long, UIMode As Boolean
    Dim Boys As Boolean, Girls As Boolean
    Dim FX As Long, FY As Long, FXO As Long, FYO As Long, sx As Long, sy As Long
    Dim PFocus As Integer
    Dim P1 As Long, P2 As Long
    Dim FloatMode As Boolean
    Dim StickMap() As Boolean
'======================================
Public Sub SummonStick(Optional ByVal RepIndex As Integer = -1)
    Dim MyS() As Student, i As Integer, X As Long, y As Long
    ReDim MyS(0)
    For i = P1 To P2
        If (Stu(i).Sex = "��" And Boys) Or (Stu(i).Sex = "Ů" And Girls) Then
            If CheckIgnore(i) = False Then
                For X = 1 To UBound(Sticks)
                    If Sticks(X).Person.Number = Stu(i).Number Then GoTo NextStu
                Next
                ReDim Preserve MyS(UBound(MyS) + 1)
                MyS(UBound(MyS)) = Stu(i)
            End If
        End If
NextStu:
    Next
    
    If UBound(MyS) = 0 Then
        SetWindowPos GHwnd, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE Or SWP_NOMOVE
        MsgBox "û�з���ҡ�Ż����õ�ѧ�����Ա��鵽Ŷ��" & vbCrLf & "���Գ��Էſ�������Χ���ƣ����߲������Ա�~", 64, "û�˿��Գ���"
        SetWindowPos GHwnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE Or SWP_NOMOVE
        Exit Sub
    End If
    
    Dim Tar As Student
    Randomize
    Tar = MyS(Int(Rnd * UBound(MyS)) + 1)
    
    If RepIndex <> -1 Then
        Sticks(RepIndex).Person = Tar
        Exit Sub
    End If
    
    Dim Area() As POINT
    ReDim Area(0)
    For X = 0 To UBound(StickMap, 1)
        For y = 0 To UBound(StickMap, 2)
            If Not StickMap(X, y) Then
                ReDim Preserve Area(UBound(Area) + 1)
                Area(UBound(Area)).X = X: Area(UBound(Area)).y = y
            End If
        Next
    Next
    
    If UBound(Area) = 0 Then
        SetWindowPos GHwnd, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE Or SWP_NOMOVE
        MsgBox "��Ļ��û�п�λҡ����Ŷ~" & vbCrLf & "����'�ر�'��ť��������ҡ�Ż�~", 64, "û�п�λ��"
        SetWindowPos GHwnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE Or SWP_NOMOVE
        Exit Sub
    End If
    
    Dim TA As POINT
    TA = Area(Int(Rnd * UBound(Area)) + 1)
    StickMap(TA.X, TA.y) = True
    
    ReDim Preserve Sticks(UBound(Sticks) + 1)
    With Sticks(UBound(Sticks))
        .Person = Tar
        .time = GetTickCount
        .X = TA.X * 350 + (GW / 2 - UBound(StickMap, 1) * 350 / 2) - 100
        .y = TA.y * 80 + ((GH - 450) / 2 - UBound(StickMap, 2) * 80 / 2)
    End With
    
End Sub
Public Sub ResetMap()
    ReDim StickMap(Int((GW * 0.1 + (GW * 0.8 - 250)) / 350), Int((GH * 0.1 + (GH - 450 - GH * 0.2)) / 80))
End Sub
Public Sub Update()
    '��Ϸÿһ֡�Ĺ��̣����ƹ�������ڴ˴���
    Dim pro As Single
    pro = IIf(UIMode, 1, 0)
    If UITime <> 0 Then
        pro = (GetTickCount - UITime) / 300
        If pro > 1 Then
            On Error Resume Next
            pro = 1: UITime = 0: ReDim Sticks(0)
            Call ResetMap
        End If
        If UIMode = False Then pro = 1 - pro
        pro = Cubic(pro, 0, 1, 1, 1)
    End If
    
    Page.Clear argb(50 * pro, 5 * pro, 0, 0) '��ջ���
    
    Dim p As POINTAPI
    Page.DrawImage "float.png", FX, FY + (GH - FY) * pro, alpha:=1 - pro, pos:=posOnCenter
    If CheckMouse2 = mMouseDown And FloatMode = False Then
        FloatMode = True: FXO = FX: FYO = FY
        GetCursorPos p
        sx = p.X - FX: sy = p.y - FY
    End If
    If FloatMode Then
        GetCursorPos p
        FX = p.X - sx: FY = p.y - sy
        If Not IsKeyPress(VK_LBUTTON) Then
            If Abs(FX - FXO) <= 15 And Abs(FY - FYO) <= 15 Then
                UIMode = True: UITime = GetTickCount
            End If
            FloatMode = False
        End If
        If IsKeyPress(VK_RBUTTON) Then
            On Error Resume Next
            Unload GameWindow
            End
        End If
    End If
    
    Page.DrawImage "ui.png", GW / 2, GH - 350 * pro, alpha:=pro, pos:=posOnCenter
    Page.DrawImage "clear.png", GW / 2, GH - 150 * pro, alpha:=1 * pro, pos:=posOnCenter
    If CheckMouse2 = mMouseUp And UIMode = True Then
        UIMode = False: UITime = GetTickCount
    End If
    
    Page.DrawImage "dia1.png", GW / 2 - 260, GH - 320 * pro, alpha:=pro
    Dim SexStr As String
    If Boys Then SexStr = "ֻ������"
    If Girls Then SexStr = "ֻ��Ů��"
    If Boys And Girls Then SexStr = "�Ա�����"
    If Not (Boys Or Girls) Then SexStr = "ѡ���Ա�"
    
    Page.Writes SexStr, GW / 2 - 192, GH - 292 * pro, 20, argb(255 * pro, 255, 255, 255), align:=StringAlignmentCenter, style:=FontStyleBold
    Page.DrawImage "dia2.png", GW / 2 - 40, GH - 320 * pro, alpha:=pro
    Page.Writes "������Χ��" & P1 & "~" & P2, GW / 2 + 72, GH - 292 * pro, 20, argb(255 * pro, 255, 255, 255), align:=StringAlignmentCenter, style:=FontStyleBold
    
    Page.DrawImage "boy" & IIf(Boys, 1, 0) & ".png", GW / 2 - 240, GH - 350 * pro, alpha:=1 * pro, pos:=posOnCenter
    If CheckMouse2 = mMouseUp Then Boys = Not Boys
    Page.DrawImage "girl" & IIf(Girls, 1, 0) & ".png", GW / 2 - 185, GH - 350 * pro, alpha:=1 * pro, pos:=posOnCenter
    If CheckMouse2 = mMouseUp Then Girls = Not Girls
    
    Dim barW As Long
    barW = Page.Res.ImgSize("areabar.png", imgGetWidth)
    Page.DrawImage "areabar.png", GW / 2 - 115 + 230 * (P1 - 1) / (UBound(Stu) - 1), GH - 362 * pro, alpha:=1 * pro, CW:=(P2 - P1 + 1) / UBound(Stu) * barW
    Dim P1X As Long, P2X As Long
    P1X = GW / 2 - 110 + 230 * (P1 - 1) / (UBound(Stu) - 1)
    P2X = GW / 2 - 110 + 230 * (P2 - 1) / (UBound(Stu) - 1)
    Dim m As Integer
    If PFocus = 0 Then
        m = CheckMouse(597, 522, 256, 34)
    Else
        m = CheckMouse(0, 0, GW, GH)
    End If
    
    If m > 0 And Mouse.button > 0 Then
        If PFocus = 0 Then
            If Mouse.X >= P1X - 15 And Mouse.X <= P1X + 15 Then PFocus = 1
            If Mouse.X >= P2X - 15 And Mouse.X <= P2X + 15 Then PFocus = 2
        End If
        If PFocus = 1 Then P1 = (Mouse.X - 597) / 256 * (UBound(Stu) - 1) + 1
        If PFocus = 2 Then P2 = (Mouse.X - 597) / 256 * (UBound(Stu) - 1) + 1
    ElseIf PFocus <> 0 Then
        PFocus = 0
    End If
    Page.DrawImage "area1.png", P1X, GH - 355 * pro, alpha:=1 * pro, pos:=posOnCenter
    Page.DrawImage "area2.png", P2X, GH - 355 * pro, alpha:=1 * pro, pos:=posOnCenter
    If P1 >= P2 Then P1 = P2 - 1
    If P1 < 1 Then P1 = 1
    If P1 >= P2 Then P2 = 2
    If P2 > UBound(Stu) Then P2 = UBound(Stu)
    
    If Boys Or Girls Then Page.DrawImage "go.png", GW / 2 + 230, GH - 355 * pro, alpha:=1 * pro, pos:=posOnCenter
    If CheckMouse2 = mMouseUp Then Call SummonStick
    
    Page.Writes GameWindow.Caption, GW / 2, (GH - 450) / 2 + 12, 64, argb(200 * pro, 255, 255, 255), align:=StringAlignmentCenter, style:=FontStyleBold
    
    Dim pro2 As Single, BX As Single, BY As Single, pro3 As Single
    Dim Name As String
    For i = 1 To UBound(Sticks)
ReDraw:
        With Sticks(i)
            pro2 = (GetTickCount - .time) / 500
            If pro2 > 1 Then pro2 = 1
            pro2 = Cubic(pro2, 0, 1, 1, 1) * pro
            BX = GW / 2 + pro2 * (.X - GW / 2)
            BY = GH + pro2 * (.y - GH)
            pro3 = (GetTickCount - .time - 500) / 500
            If pro3 < 0 Then pro3 = 0
            If pro3 > 1 Then pro3 = 1
            pro3 = Cubic(pro3, 0, 1, 1, 1)
            Page.Paint 2, BX, BY, 60 * pro2 + 190 * pro3 * pro, 60 * pro2 * pro, argb(255, 74 + (255 - 74) * pro3, 74 + (255 - 74) * pro3, 84 + (255 - 84) * pro3), Radius:=60 * pro3
            If PFocus = 0 Then
                If CheckMouse2 = mMouseUp Then
                    SummonStick i
                    .time = GetTickCount - 500
                    GoTo ReDraw
                End If
            End If
            Page.Paint 2, BX, BY, 250 * pro, 60 * pro, IIf(.Person.Sex = "��", argb(255 * pro3 * pro, 37, 209, 222), argb(255 * pro3 * pro, 253, 86, 60)), Radius:=60 * pro3 * pro, style:=1, size:=3 * pro3
            Page.Paint 1, BX + 30, BY + 30, 61 * pro3, 61 * pro3, IIf(.Person.Sex = "��", argb(255 * pro3, 37, 209, 222), argb(255 * pro3, 253, 86, 60)), pos:=posOnCenter
            Page.Writes IIf(.Person.Sex = "��", "��", "��"), BX + 29, BY + 6, 36, IIf(.Person.Sex = "��", argb(255 * pro2, 37 + (255 - 37) * pro3, 209 + (255 - 209) * pro3, 222 + (255 - 222) * pro3), argb(255 * pro2, 253 + (255 - 253) * pro3, 86 + (255 - 86) * pro3, 60 + (255 - 60) * pro3)), style:=FontStyleBold, align:=StringAlignmentCenter
            Randomize
            If pro3 < 1 Then Name = Wo(Int(Rnd * UBound(Wo)) + 1) & Wo(Int(Rnd * UBound(Wo)) + 1) & Wo(Int(Rnd * UBound(Wo)) + 1)
            If pro3 = 1 Then Name = .Person.Name
            Page.Writes Name, BX + 55 * pro3 + 10 * pro3, BY + 7.5, 32, argb(255 * Cubic(pro3, 0, 0, 0, 1), 64, 64, 75)
            Page.Writes IIf(pro3 < 1, format(Int(Rnd * 100), "00"), format(.Person.Number, "00")), BX + 234 * pro3, BY + 13.5, 24, argb(255 * Cubic(pro3, 0, 0, 0, 1), 128, 128, 138), align:=StringAlignmentFar, style:=FontStyleBoldItalic
        End With
    Next
End Sub
Public Sub Wheel(Direction As Integer, Depth As Single)
    '�������¼�
    'Direction:����Depth�����
End Sub
Public Sub AnimationMsg(id As String, msg As String)
    '������Ϣ����
End Sub
Public Sub Enter()
    'ҳ������¼�
End Sub
Public Sub Leave()
    'ҳ���뿪�¼�
End Sub
Public Sub Gotfocus()
    '����ȡ�ý����¼�
End Sub
Public Sub Lostfocus()
    '����ʧȥ�����¼�
End Sub
Public Sub AnimationDone(id As Integer)
    '�������Ž����¼�
    'id�������Ķ���ID
End Sub
Private Sub Class_Initialize()
    '����ҳ�������
    Set Page = New GPage
    Page.Create Me
    '������Ϸ��Դ
    Page.Res.NewImages App.path & "\assets"
    '����ҳ��
    ECore.Add Page, "MainPage"
    Boys = True: Girls = True
    FX = GW - 100: FY = GH - 150
    P1 = 1: P2 = UBound(Stu)
    ReDim Sticks(0)
    '===============================================
    '   �����Ҫ���Ӷ�����������ڴ˴�
    
    '===============================================
End Sub