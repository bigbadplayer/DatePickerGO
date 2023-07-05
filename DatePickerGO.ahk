#Requires AutoHotkey v2.0

#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance Force	; Automatically kill older Instance, and replace it!
Persistent	; Run continously
SendMode "Input"  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.
TraySetIcon(A_ScriptDir . "\DatePickerGO.ico")

iniFile := "DatePickerGO.ini"

A_IconTip := "DatePickerGO  // Right click for Menu"
A_TrayMenu.Add("[Help]", ShowHelp)
A_TrayMenu.Add("[Options]", ShowOptions)

If not FileExist(iniFile)
{
    CreateIni
    Loop {
        sleep 500
    } until FileExist(iniFile)
}

	rowCount := IniRead(iniFile,"Options","RowCount",1)
    if (rowCount < 1 or rowCount > 4) 
        rowCount := 1
	colCount := IniRead(iniFile,"Options","ColumnCount",2)
    if (colCount < 1 or colCount > 3) 
        colCount := 2
    UserHotkey := IniRead(iniFile,"Options","Hotkey","+#d")
    DateFormat1 := IniRead(iniFile,"Options","DateFormat1","yyyy.MM.dd.")
    DateFormat2 := IniRead(iniFile,"Options","DateFormat2","dd.MM.yyyy.")
    DateFormat3 := IniRead(iniFile,"Options","DateFormat3","MM.dd.yyyy.")
    DateFormatCWsplitChar :=  IniRead(iniFile,"Options","DateFormatCWsplitChar","/CW")
    SplitChar := IniRead(iniFile,"Options","SplitChar","-")

Hotkey UserHotkey, DateTimePicker

DateTimePicker(*)
{

    DatePicker := Gui(, "DatePickerGO",)
    DatePicker.Opt("+AlwaysOnTop +ToolWindow -Resize")
    DateSelect := DatePicker.AddMonthCal("vMyCal 4 R" . rowCount . " W-" . colCount . " Multi")
    
	InsertBtn1 := DatePicker.AddButton("x+5 h35 Default", DateFormat1 . "   [Ctrl+1]")
    InsertBtn1.OnEvent("Click", DateRoutine1)

	InsertBtn2 := DatePicker.AddButton("h35", DateFormat2 . "   [Ctrl+2]")
	InsertBtn2.OnEvent("Click", DateRoutine2)

	InsertBtn3 := DatePicker.AddButton("h35", DateFormat3 . "   [Ctrl+3]")
	InsertBtn3.OnEvent("Click", DateRoutine3)

    InsertBtn4 := DatePicker.AddButton("h35", "yyyy" . DateFormatCWsplitChar . "week" . "   [Ctrl+4]")
	InsertBtn4.OnEvent("Click", DateRoutine4)

    DatePicker.OnEvent("Close", DatePicker_Close)
    DatePicker.OnEvent("Escape", DatePicker_Close)
    DatePicker.Show()

     ;Context-sensitive Hotkeys
    HotIfWinactive "DatePickerGO"
    Hotkey "^1", DateRoutine1
    Hotkey "^2", DateRoutine2
    Hotkey "^3", DateRoutine3
    Hotkey "^4", DateRoutine4

        DatePicker_Close(*)
            {
                DatePicker.Destroy()
            }

		DateRoutine1(*){
			DateRoutine(DateFormat1)
		}

		DateRoutine2(*){
			DateRoutine(DateFormat2)
		}

		DateRoutine3(*){
			DateRoutine(DateFormat3)
		}

        DateRoutine4(*){
			DateRoutineCW(DateFormatCWsplitChar)
		}

        DateRoutine(dateFormat)
            {
             DateInsert := ""
                myDate := StrSplit(DateSelect.Value, "-")
             if myDate[1] = myDate[2] {
                DateInsert := FormatTime(myDate[1], dateFormat)
             } else {
                myDate[1] := FormatTime(myDate[1], dateFormat)
                myDate[2] := FormatTime(myDate[2], dateFormat)
                DateInsert := myDate[1] . SplitChar . myDate[2]
            }
             DatePicker.Destroy()
             SendInput(DateInsert)
            }

        ;Special Case with week numbers
        DateRoutineCW(CWsplitChar)
            {
             DateInsert := ""
                myDate := StrSplit(DateSelect.Value, "-")
             if myDate[1] = myDate[2] {
                DateInsert := FormatTime(myDate[1], "YWeek") ;Result like: 200543
                DateInsert := SubStr(DateInsert,1,4) . CWsplitChar . SubStr(DateInsert,5,2)
             } else {
                myDate[1] := FormatTime(myDate[1], "YWeek")
                myDate[1] := SubStr(myDate[1],1,4) . CWsplitChar . SubStr(myDate[1],5,2)
                myDate[2] := FormatTime(myDate[2], "YWeek")
                myDate[2] := SubStr(myDate[2],1,4) . CWsplitChar . SubStr(myDate[2],5,2)
                DateInsert := myDate[1] . SplitChar . myDate[2]
            }
             DatePicker.Destroy()
             SendInput(DateInsert)
            }
}

ShowHelp(*){
    helpMsg1 := "Current Hotkey = " . UserHotkey . "`n`n+ = Shift`n# = Win`n^ = Ctrl`n! = Alt`n`n"
    helpMsg2 := "
    (
        Keyboard navigation:

        Use the ↑ / ↓ and ← / → arrow keys, to move from field to field inside the control.
        Use PgUp/PgDn to move backward/forward by one month.
        Use Home/End to select the first/last day of the month.
        Calendar allows the user to shift-click or click-drag to select a range of adjacent dates.
        [Enter] Inserts the selected date(s) with the default date format.
        [Ctrl] + 1 ... 4 Hotkeys inserts the pre-defined formats.
    )"
        MsgBox helpMsg1 . helpMsg2
    }

ShowOptions(*) {
    run iniFile
}

CreateIni() {
    iniContent := "
    (
    [Options]

    ;Number of Rows of Months. Possible values = 1...4. Default =1.
    RowCount=1

    ;Number of Columns of Months. Possible values = 1...3. Default =2.
    ColumnCount=2

    ;Hotkey for launch DatePickerGO. Default is Shift+Win+D ="+#d"
    ;+ = Shift
    ;# = Win
    ;^ = Ctrl
    ;! = Alt
    Hotkey="+#d"

    ;You can set 4 pre-defined date formats. The first one is the default. 
    ;The fourth one is special: year with ISO 8601 week number plus a split char. Typical values = "/CW", " / CW ", "/week"
    ;Format of the date inserted (further info below):
    DateFormat1="yyyy.MM.dd."
    DateFormat2="yyyy/MM/dd"
    DateFormat3="LongDate"
    DateFormatCWsplitChar="/CW"

    ;Splitting character in case of date-range (like 2023.07.22.-2024.07.22.)
    ;Typical values = "-", " - ", "/", " / "
    SplitChar="-"

    ; Date Formats (case sensitive)
    ; Format -- Description
    ; d -- Day of the month without leading zero (1 – 31) 
    ; dd -- Day of the month with leading zero (01 – 31) 
    ; ddd -- Abbreviated name for the day of the week (e.g. Mon) in the current user's language 
    ; dddd -- Full name for the day of the week (e.g. Monday) in the current user's language 
    ; M -- Month without leading zero (1 – 12) 
    ; MM -- Month with leading zero (01 – 12) 
    ; MMM -- Abbreviated month name (e.g. Jan) in the current user's language 
    ; MMMM -- Full month name (e.g. January) in the current user's language 
    ; y -- Year without century, without leading zero (0 – 99) 
    ; yy -- Year without century, with leading zero (00 – 99) 
    ; yyyy -- Year with century. For example: 2005 

    ; Examples:
    ; "yyyy.MM.dd." => 2023.07.22.
    ; "dd/MM/yyyy" => 22/07/2023
    ; "dd. MMMM yyyy." => 22. July 2023.

    ; Standalone Formats
    ; The following formats must be used alone; that is, with no other formats or text present in the Format parameter. These formats are not case sensitive.
    ; Format -- Description
    ; ShortDate -- Short date representation for the current user's locale, such as 02/29/04 
    ; LongDate -- Long date representation for the current user's locale, such as Friday, April 23, 2004 
    ; YearMonth -- Year and month format for the current user's locale, such as February, 2004 
    ; YDay -- Day of the year without leading zeros (1 – 366) 
    ; YDay0 -- Day of the year with leading zeros (001 – 366) 

    ;NOTES: 
    ; You need to save the ini file and reload the app to take effect of changes.
    ; If it seems, some values has not changed, may you mistyped something (in case of missing/not valid values, the program loads the default value).
    ; If you 'messed up' the ini, just delete it. The exe will generate a new one with default values.
    )"
    FileAppend(iniContent, "DatePickerGO.ini","UTF-16")
}