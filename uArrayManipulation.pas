unit uArrayManipulation;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Math,
  System.Classes, Vcl.Graphics, System.DateUtils, System.StrUtils, System.JSON,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TEmployee = class
  private
    FId: Integer;
    FName: String;
    FLastName: String;
    FBirthDate: TDate;
    FGender: Integer;
    FStatus: Integer;
  public
    function FullName: String;
  published
    property Id: Integer read FId write FId;
    property Name: String read FName write FName;
    property LastName: String read FLastName write FLastName;
    property BirthDate: TDate read FBirthDate write FBirthDate;
    property Gender: Integer read FGender write FGender;
    property Status: Integer read FStatus write FStatus;
  end;

type
  TfrmEmployeeRegister = class(TForm)
    EdtId: TEdit;
    LblId: TLabel;
    LblName: TLabel;
    EdtName: TEdit;
    LblLastName: TLabel;
    EdtLastName: TEdit;
    DtpBirthDate: TDateTimePicker;
    LblBirthDate: TLabel;
    LblGender: TLabel;
    RabMale: TRadioButton;
    RabFemale: TRadioButton;
    CbxState: TComboBox;
    BtnRegister: TButton;
    BtnDelete: TButton;
    BtnSearch: TButton;
    BtnBenchMarking: TButton;
    LbxRegister: TListBox;
    LblEmployeeList: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnRegisterClick(Sender: TObject);
    procedure BtnSearchClick(Sender: TObject);
    procedure BtnBenchMarkingClick(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
  private
    FEmployees: TList;
    FLast: Integer;
    procedure ClearFields;
    procedure Validate;
    procedure UpdateListEmployees;
    function Registered: Boolean;
    procedure SearchBenchMarking(AId, AStart, AEnd: Integer);
    procedure PopulateList;
  public
    { Public declarations }
  end;

const
  MALE = 0;
  FEMALE = 1;

var
  frmEmployeeRegister: TfrmEmployeeRegister;

implementation

{$R *.dfm}

procedure TfrmEmployeeRegister.BtnBenchMarkingClick(Sender: TObject);
var
  StartTime, EndTime: TDateTime;
begin
  PopulateList;
  StartTime := Now;
  SearchBenchMarking(RandomRange(1, 100000), 0, FEmployees.Count);
  EndTime := Now;
  ShowMessage(Format('A execução da pesquisa levou  %s milesegundos',
    [MilliSecondsBetween(StartTime, EndTime).ToString]));
end;

procedure TfrmEmployeeRegister.BtnDeleteClick(Sender: TObject);
begin
  if MessageDlg(Format('Deseja excluir o funcionário %s',
    [LbxRegister.Items[LbxRegister.ItemIndex]]), mtCustom, [mbYes, mbNo], 0) = mrYes
  then
    LbxRegister.DeleteSelected;
end;

procedure TfrmEmployeeRegister.BtnRegisterClick(Sender: TObject);
var
  ANewEmployee, AAux: TEmployee;
  I: Integer;
begin
  Validate;

  ANewEmployee := TEmployee.Create;
  try

    with ANewEmployee do
    begin
      FId := StrToInt(EdtId.Text);
      FName := EdtName.Text;
      FLastName := EdtLastName.Text;
      FBirthDate := DtpBirthDate.Date;

      if RabMale.Checked then
        FGender := MALE
      else
        FGender := FEMALE;

      Status := CbxState.ItemIndex;
    end;

    if FEmployees.Count > 0 then
    begin
      AAux := FEmployees.Items[FLast];

      if AAux.Name > ANewEmployee.Name then
      begin
        FEmployees.Delete(FLast);
        FEmployees.Add(ANewEmployee);
        FEmployees.Add(AAux);
      end
      else
        FEmployees.Add(ANewEmployee);
    end
    else
      FEmployees.Add(ANewEmployee);

    Inc(FLast);
  finally
    UpdateListEmployees;
    ClearFields;
  end;
end;

procedure TfrmEmployeeRegister.BtnSearchClick(Sender: TObject);
var
  AEmployee: TEmployee;
begin
  for AEmployee in FEmployees do
  begin
    if AEmployee.Id = StrToInt(EdtId.Text) then
    begin
      EdtName.Text := AEmployee.Name;
      EdtLastName.Text := AEmployee.LastName;
      DtpBirthDate.Date := AEmployee.BirthDate;
      if AEmployee.Gender = 0 then
        RabMale.Checked := True
      else
        RabFemale.Checked := True;
      CbxState.ItemIndex := AEmployee.Status;
      Exit;
    end;
  end;
  raise Exception.Create('Funcionário não cadastrado');
end;

procedure TfrmEmployeeRegister.ClearFields;
begin
  EdtId.Clear;
  EdtName.Clear;
  EdtLastName.Clear;
  RabMale.Checked := False;
  RabFemale.Checked := False;
  CbxState.ItemIndex := 0;
end;

procedure TfrmEmployeeRegister.FormCreate(Sender: TObject);
begin
  FEmployees := TList.Create;
  FLast := -1;
end;

procedure TfrmEmployeeRegister.FormDestroy(Sender: TObject);
begin
  FEmployees.Free;
end;

procedure TfrmEmployeeRegister.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
    SelectNext(ActiveControl, True, True);
end;

procedure TfrmEmployeeRegister.PopulateList;
var
  AFile: TStringList;
  AEmployee: TEmployee;
  I: Integer;
  AJSONArray: TJSONArray;
  AJSON: TJSONValue;
begin
  AFile := TStringList.Create;
  AFile.LoadFromFile('fakers.json');
  AJSONArray := TJSONObject.ParseJSONValue(AFile.Text) as TJSONArray;
  try
    for AJSON in AJSONArray do
    begin
      AEmployee := TEmployee.Create;
      AEmployee.Id := AJSON.GetValue<Integer>('id');
      AEmployee.Name := AJSON.GetValue<String>('name');
      AEmployee.LastName := AJSON.GetValue<String>('lastName');
      AEmployee.BirthDate := StrToDate(AJSON.GetValue<String>('birthDate'));
      AEmployee.Gender := AJSON.GetValue<Integer>('gender');
      AEmployee.Status := AJSON.GetValue<Integer>('status');
      FEmployees.Add(AEmployee);
      LbxRegister.Items.Add(AEmployee.FullName);
    end;
  finally
    AJSONArray.Free;
    AFile.Free;
  end;
end;

function TfrmEmployeeRegister.Registered: Boolean;
var
  AEmployee: TEmployee;
begin
  Result := False;
  for AEmployee in FEmployees do
  begin
    if AEmployee.Id = StrToInt(EdtId.Text) then
    begin
      EdtId.SetFocus;
      Result := True;
      Exit;
    end;
  end;
end;

procedure TfrmEmployeeRegister.SearchBenchMarking(AId, AStart, AEnd: Integer);
var
  AMiddle: Integer;
  AEmployee: TEmployee;
begin


  if AStart > AEnd then
    Exit;

  AMiddle := AStart + (AEnd - AStart) div 2;
  AEmployee := FEmployees.Items[AMiddle];

  if AEmployee.Id = AId then
  begin
    ShowMessage('Elemento encontrado na lista');
    Exit;  
  end
  else if AId > AEmployee.Id then
    SearchBenchMarking(AId, AMiddle + 1, AEnd)
  else
    SearchBenchMarking(AId, AStart, AMiddle);

end;

procedure TfrmEmployeeRegister.UpdateListEmployees;
var
  I: Integer;
  AEmployee: TEmployee;
begin
  LbxRegister.Items.Clear;
  for I := 0 to Pred(FEmployees.Count) do
  begin
    AEmployee := FEmployees.Items[I];
    LbxRegister.Items.Add(AEmployee.FullName)
  end;
end;

procedure TfrmEmployeeRegister.Validate;
var
  AError: Boolean;
  AField: String;
begin
  AError := False;

  if Registered then
    raise Exception.Create('Funcionário já cadastrado!');

  if String.IsNullOrWhiteSpace(EdtId.Text) then
  begin
    EdtId.SetFocus;
    AError := True;
    AField := 'Código';
  end;

  if String.IsNullOrWhiteSpace(EdtName.Text) and not AError then
  begin
    EdtName.SetFocus;
    AError := True;
    AField := 'Nome';
  end;

  if String.IsNullOrWhiteSpace(EdtLastName.Text) and not AError then
  begin
    EdtLastName.SetFocus;
    AError := True;
    AField := 'Sobrenome';
  end;

  if String.IsNullOrWhiteSpace(DtpBirthDate.ToString) and not AError or
    (DtpBirthDate.Date >= DateOf(Date)) then
  begin
    DtpBirthDate.SetFocus;
    AError := True;
    AField := 'Data de nascimento';
  end;

  if not RabMale.Checked and not RabFemale.Checked and not AError then
  begin
    RabMale.SetFocus;
    AError := True;
    AField := 'Sexo';
  end;

  if (CbxState.ItemIndex <= 0) and (not AError) then
  begin
    CbxState.SetFocus;
    AError := True;
    AField := 'Estado civil';
  end;

  if AError then
    raise Exception.Create(Format('Campo ''%s'' obrigatório ou inválido',
      [AField]));
end;

{ TEmployee }

function TEmployee.FullName: String;
begin
  Result := Format('%s %s', [FName, FLastName]);
end;

end.
