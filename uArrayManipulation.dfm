object frmEmployeeRegister: TfrmEmployeeRegister
  Left = 0
  Top = 0
  Caption = 'Cadastro de Funcion'#225'rios'
  ClientHeight = 375
  ClientWidth = 580
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  TextHeight = 15
  object LblId: TLabel
    Left = 24
    Top = 19
    Width = 39
    Height = 15
    Caption = 'C'#243'digo'
  end
  object LblName: TLabel
    Left = 24
    Top = 69
    Width = 33
    Height = 15
    Caption = 'Nome'
  end
  object LblLastName: TLabel
    Left = 24
    Top = 124
    Width = 61
    Height = 15
    Caption = 'Sobrenome'
  end
  object LblBirthDate: TLabel
    Left = 24
    Top = 182
    Width = 105
    Height = 15
    Caption = 'Data de nascimento'
  end
  object LblGender: TLabel
    Left = 24
    Top = 235
    Width = 25
    Height = 15
    Caption = 'Sexo'
  end
  object LblEmployeeList: TLabel
    Left = 288
    Top = 18
    Width = 109
    Height = 15
    Caption = 'Lista de funcion'#225'rios'
  end
  object EdtId: TEdit
    Left = 24
    Top = 40
    Width = 61
    Height = 23
    NumbersOnly = True
    TabOrder = 0
  end
  object EdtName: TEdit
    Left = 24
    Top = 94
    Width = 249
    Height = 23
    MaxLength = 25
    TabOrder = 1
  end
  object EdtLastName: TEdit
    Left = 24
    Top = 149
    Width = 249
    Height = 23
    MaxLength = 25
    TabOrder = 2
  end
  object DtpBirthDate: TDateTimePicker
    Left = 24
    Top = 206
    Width = 186
    Height = 23
    Date = 45590.000000000000000000
    Time = 0.936418206016242000
    TabOrder = 3
  end
  object RabMale: TRadioButton
    Left = 24
    Top = 256
    Width = 81
    Height = 17
    Caption = 'Masculino'
    TabOrder = 4
  end
  object RabFemale: TRadioButton
    Left = 128
    Top = 256
    Width = 82
    Height = 17
    Caption = 'Feminimo'
    TabOrder = 5
  end
  object CbxState: TComboBox
    Left = 24
    Top = 288
    Width = 186
    Height = 23
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 6
    Text = 'Selecione uma op'#231#227'o'
    Items.Strings = (
      'Selecione uma op'#231#227'o'
      'Casado'
      'Separado'
      'Solteiro'
      'Viuvo')
  end
  object BtnRegister: TButton
    Left = 24
    Top = 344
    Width = 75
    Height = 25
    Caption = 'Cadastrar'
    TabOrder = 7
    OnClick = BtnRegisterClick
  end
  object BtnDelete: TButton
    Left = 198
    Top = 344
    Width = 75
    Height = 25
    Caption = 'Excluir'
    TabOrder = 8
    OnClick = BtnDeleteClick
  end
  object BtnSearch: TButton
    Left = 91
    Top = 39
    Width = 75
    Height = 25
    Caption = 'Pesquisar'
    TabOrder = 9
    OnClick = BtnSearchClick
  end
  object BtnBenchMarking: TButton
    Left = 185
    Top = 39
    Width = 88
    Height = 25
    Caption = 'BenchMarking'
    TabOrder = 10
    OnClick = BtnBenchMarkingClick
  end
  object LbxRegister: TListBox
    Left = 288
    Top = 39
    Width = 289
    Height = 330
    ItemHeight = 15
    TabOrder = 11
  end
end
