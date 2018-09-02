unit win1251decoder;
//
// wofs(c)2017 [wofssirius@yandex.ru]
// GNU LESSER GENERAL PUBLIC LICENSE v.2.1
//
{$mode objfpc}{$H+}

interface

implementation

uses
  SysUtils, xmlread;

const
  // based on https://ru.wikipedia.org/wiki/Windows-1251
  win1251table: array[#128..#255] of WideChar=(
          #$0402,#$0403,#$201A,#$0453,#$201E,#$2026,#$2020,#$2021,
          #$20AC,#$2030,#$0409,#$2039,#$040A,#$040C,#$040B,#$040F,
          #$0452,#$2018,#$2019,#$201C,#$201D,#$2022,#$2013,#$2014,
          #$0000,#$2122,#$0459,#$203A,#$045A,#$045C,#$045B,#$045F,
          #$00A0,#$040E,#$045E,#$0408,#$00A4,#$0490,#$00A6,#$00A7,
          #$0401,#$00A9,#$0404,#$00AB,#$00AC,#$00AD,#$00AE,#$0407,
          #$00B0,#$00B1,#$0406,#$0456,#$0491,#$00B5,#$00B6,#$00B7,
          #$0451,#$2116,#$0454,#$00BB,#$0458,#$0405,#$0455,#$0457,
          #$0410,#$0411,#$0412,#$0413,#$0414,#$0415,#$0416,#$0417,
          #$0418,#$0419,#$041A,#$041B,#$041C,#$041D,#$041E,#$041F,
          #$0420,#$0421,#$0422,#$0423,#$0424,#$0425,#$0426,#$0427,
          #$0428,#$0429,#$042A,#$042B,#$042C,#$042D,#$042E,#$042F,
          #$0430,#$0431,#$0432,#$0433,#$0434,#$0435,#$0436,#$0437,
          #$0438,#$0439,#$043A,#$043B,#$043C,#$043D,#$043E,#$043F,
          #$0440,#$0441,#$0442,#$0443,#$0444,#$0445,#$0446,#$0447,
          #$0448,#$0449,#$044A,#$044B,#$044C,#$044D,#$044E,#$044F);

function Win1251_Decode(Context: Pointer; InBuf: PChar; var InCnt: Cardinal; OutBuf: PWideChar; var OutCnt: Cardinal): Integer; stdcall;
var
  I: Integer;
  cnt: Cardinal;
begin
  cnt := OutCnt;
  if cnt > InCnt then
    cnt := InCnt;
  for I := 0 to cnt-1 do
  begin
    if InBuf[I] < #128 then
      OutBuf[I] := WideChar(ord(InBuf[I]))
    else
      OutBuf[I] := win1251table[InBuf[I]];
  end;
  Dec(InCnt, cnt);
  Dec(OutCnt, cnt);
  Result := cnt;
end;

function GetWin1251Decoder(const AEncoding: string; out Decoder: TDecoder): Boolean; stdcall;
begin
  if SameText(AEncoding, 'Windows-1251') then  // add variants
  begin
    Decoder.Decode := @Win1251_Decode;
    Result := True;
  end
  else
    Result := False;
end;

initialization
  RegisterDecoder(@GetWin1251Decoder);

end.

