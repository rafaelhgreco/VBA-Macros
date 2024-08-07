VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Planilha1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Sub CopiarParaPasta2()
    Dim FSO As Object
    Dim folderPath As String
    Dim file As Object
    Dim wb As Workbook
    Dim wsDadosBasicos As Worksheet
    Dim wsDadosCentro As Worksheet
    Dim nextRow As Long
    Dim lastRow As Long
    Dim dialogBox As FileDialog
    Dim erroLog As String
    
    Set dialogBox = Application.FileDialog(msoFileDialogFolderPicker)
    dialogBox.Title = "Selecione a Pasta Contendo os Arquivos Excel"
    
    If dialogBox.Show = -1 Then
        folderPath = dialogBox.SelectedItems(1)
    Else
        MsgBox "Nenhum diret�rio selecionado. Opera��o cancelada.", vbExclamation
        Exit Sub
    End If
    
    Set FSO = CreateObject("Scripting.FileSystemObject")
    
    If Not FSO.FolderExists(folderPath) Then
        MsgBox "O diret�rio especificado n�o existe.", vbCritical
        Exit Sub
    End If
    
    nextRow = 1
    erroLog = ""

    For Each file In FSO.GetFolder(folderPath).Files
        If LCase(file.Name) Like "*.xls*" Then
            Set wb = Workbooks.Open(file.Path)
            
            On Error Resume Next
            Set wsDadosBasicos = wb.Sheets("Unidades de medida alternativa")    'ajustar abas
            Set wsDadosCentro = wb.Sheets("Texto Compras")
            On Error GoTo 0
            
            If Not wsDadosBasicos Is Nothing And Not wsDadosCentro Is Nothing Then
                lastRow = ThisWorkbook.Sheets("Pasta2").Cells(Rows.Count, 1).End(xlUp).Row
                With ThisWorkbook.Sheets("Pasta2")
                    .Cells(lastRow + 1, 1).Resize(92, 1).Value = wsDadosBasicos.Range("B9:B100").Value ' ajustar colunas
                    .Cells(lastRow + 1, 2).Resize(92, 1).Value = wsDadosBasicos.Range("C9:C100").Value
                    .Cells(lastRow + 1, 3).Resize(92, 1).Value = wsDadosBasicos.Range("D9:D100").Value
                    .Cells(lastRow + 1, 4).Resize(92, 1).Value = wsDadosCentro.Range("C9:C100").Value
                    .Cells(lastRow + 1, 5).Resize(92, 1).Value = file.Name ' Ajuste para preencher a coluna 3 corretamente
                End With
                
                wb.Close False
            Else
                erroLog = erroLog & vbCrLf & "As abas 'Dados b�sicos' e 'Dados de centro' n�o foram encontradas no arquivo " & file.Name
            End If
            
            Set wsDadosBasicos = Nothing
            Set wsDadosCentro = Nothing
        End If
    Next file
    
    If Len(erroLog) > 0 Then
        MsgBox "Os seguintes erros foram encontrados:" & vbCrLf & erroLog, vbCritical
    End If
    
    Set FSO = Nothing
End Sub

