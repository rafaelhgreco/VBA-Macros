VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Planilha2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Sub DestacarPalavrasBaseConsulta()
    Dim ws As Worksheet
    Dim rng As Range
    Dim cell As Range
    Dim palavra As String
    
    ' Define a planilha espec�fica "BaseConsulta"
    Set ws = Worksheets("BaseConsulta")
    
    ' Pergunta ao usu�rio a palavra a ser buscada
    palavra = InputBox("Digite a palavra que deseja buscar (diferencia mai�sculas de min�sculas):")
    
    ' Verifica se o usu�rio inseriu algo
    If palavra = "" Then
        MsgBox "Por favor, insira uma palavra.", vbExclamation
        Exit Sub
    End If
    
    ' Define o intervalo de c�lulas onde ser� feita a busca (ajuste conforme necess�rio)
    Set rng = ws.Range("B1:B43006") ' Ou, por exemplo: Set rng = ws.Range("A1:D100")
    
    ' Limpa formata��es anteriores
    rng.Interior.ColorIndex = xlNone
    
    ' Percorre cada c�lula no intervalo
    For Each cell In rng
        ' Verifica se a c�lula n�o est� vazia e faz a compara��o de substring (case-sensitive)
        If Not IsEmpty(cell.Value) Then
            ' Verifica se a palavra buscada existe dentro da c�lula (case-sensitive)
            If InStr(1, cell.Value, palavra, vbBinaryCompare) > 0 Then
                ' Se a palavra for encontrada, pinta a c�lula de amarelo
                cell.Interior.Color = RGB(255, 255, 0)
            End If
        End If
    Next cell
    
    MsgBox "Busca conclu�da na planilha BaseConsulta!", vbInformation
End Sub

