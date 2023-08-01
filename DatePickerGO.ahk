#Requires AutoHotkey v2.0

;IDEAS
;Option to add to Startup?
;GUI menu
;Option to turn on Notification when CopyOnlyClipboard is on?

#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance Force	; Automatically kill older Instance, and replace it!
Persistent	; Run continously
SendMode "Input"  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.

iniFile := "DatePickerGO.ini"

;CEHECK + SET ICO
If not FileExist("DatePickerGO.ico")
    {
        FileInstall "DatePickerGO.ico", A_ScriptDir . "\DatePickerGO.ico", 1
        Loop {
            sleep 500
        } until FileExist("DatePickerGO.ico")
    }
TraySetIcon(A_ScriptDir . "\DatePickerGO.ico")

A_IconTip := "DatePickerGO  // Right click for Menu"
A_TrayMenu.Add("[Help]", ShowHelp)
A_TrayMenu.Add("[Options]", ShowOptions)
A_TrayMenu.Add("[Open Calendar]", DateTimePicker)
A_TrayMenu.default := "[Open Calendar]"
A_TrayMenu.ClickCount := 1

;INIT
If not FileExist(iniFile)
{
    CreateIni
    Loop {
        sleep 500
    } until FileExist(iniFile)
}
    CopyAlsoToClipboard := IniRead(iniFile, "Options", "CopyAlsoToClipboard", 0)
	rowCount := IniRead(iniFile,"Options","RowCount",1)
    if (rowCount < 1 or rowCount > 4) 
        rowCount := 1
	colCount := IniRead(iniFile,"Options","ColumnCount",2)
    if (colCount < 1 or colCount > 3) 
        colCount := 2
    UserHotkey := IniRead(iniFile,"Options","Hotkey","+#d")
    DateFormat1 := GetDateFormat(IniRead(iniFile,"Options","DateFormat1"))
    DateFormat2 := GetDateFormat(IniRead(iniFile,"Options","DateFormat2"))
    DateFormat3 := GetDateFormat(IniRead(iniFile,"Options","DateFormat3"))
    DateFormatCWsplitChar :=  IniRead(iniFile,"Options","DateFormatCWsplitChar","/CW")
    SplitChar := IniRead(iniFile,"Options","SplitChar"," - ")

Hotkey UserHotkey, DateTimePicker

DateTimePicker(*)
{
    DatePicker := Gui(, "DatePickerGO",)
    DatePicker.Opt("+AlwaysOnTop +ToolWindow -Resize")
    DateSelect := DatePicker.AddMonthCal("vMyCal 4 R" . rowCount . " W-" . colCount . " Multi")
    
	;InsertBtn1 := DatePicker.AddButton("x+5 h30 Default Section", "[&1] " . DateFormat1[1] . DateFormat1[3])
    InsertBtn1 := DatePicker.AddButton("x+5 h30 Default Section", "[ &1 ]")
    InsertBtn1.OnEvent("Click", DateRoutine1)
    Date1 := DatePicker.AddText("x+5 h30 w170 YP+2", GetDate(DateFormat1))

	;InsertBtn2 := DatePicker.AddButton("h30 XS Section", "[&2] " . DateFormat2[1] . DateFormat2[3])
    InsertBtn2 := DatePicker.AddButton("h30 XS Section", "[ &2 ]")
	InsertBtn2.OnEvent("Click", DateRoutine2)
    Date2 := DatePicker.AddText("x+5 h30 w170 YP+2", GetDate(DateFormat2))

	;InsertBtn3 := DatePicker.AddButton("h30 XS Section", "[&3] " . DateFormat3[1] . DateFormat3[3])
    InsertBtn3 := DatePicker.AddButton("h30 XS Section", "[ &3 ]")
	InsertBtn3.OnEvent("Click", DateRoutine3)
    Date3 := DatePicker.AddText("x+5 h30 w170 YP+2", GetDate(DateFormat3))

    ;InsertBtn4 := DatePicker.AddButton("h30 XS Section", "[&4] " . "yyyy" . DateFormatCWsplitChar . "week")
    InsertBtn4 := DatePicker.AddButton("h30 XS Section", "[ &4 ]")
	InsertBtn4.OnEvent("Click", DateRoutine4)
    Date4 := DatePicker.AddText("x+5 h30 w170 YP+2", GetDateCW(DateFormatCWsplitChar))

    CopyOnly := DatePicker.AddCheckbox("vClipboardOnly XS", "&Copy to clipboard only")

    DateSelect.OnEvent("Change", UpdateDates)
    DatePicker.OnEvent("Close", DatePicker_Close)
    DatePicker.OnEvent("Escape", DatePicker_Close)
    DatePicker.Show()

     ;Context-sensitive Hotkeys
    ; HotIfWinactive "DatePickerGO"
    ; Hotkey "^1", DateRoutine1
    ; Hotkey "^2", DateRoutine2
    ; Hotkey "^3", DateRoutine3
    ; Hotkey "^4", DateRoutine4

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

        DateRoutine(dateFormat) {
             DateInsert := GetDate(dateFormat)
             
             if CopyOnly.Value == 1 {
                A_Clipboard := DateInsert
                DatePicker.Destroy()
             } else {
                if CopyAlsoToClipboard == 1 {
                    A_Clipboard := DateInsert
                }
                DatePicker.Destroy()
                SendInput(DateInsert)
             }
        }

        ;Special Case with week numbers
        DateRoutineCW(CWsplitChar) {
             DateInsert := GetDateCW(CWsplitChar)

            if CopyOnly.Value == 1 {
                A_Clipboard := DateInsert
                DatePicker.Destroy()
             }
             else {
                if CopyAlsoToClipboard == 1 {
                    A_Clipboard := DateInsert
                }
                DatePicker.Destroy()
                SendInput(DateInsert)
             }
        }

    GetDate(dateFormat, onlyPreview?) {
        newLine := ""
        if IsSet(onlyPreview)
            newLine := "`n"
        
        myDate := StrSplit(DateSelect.Value, "-")
        if myDate[1] = myDate[2] {
            return FormatTime(myDate[1] . dateFormat[2], dateFormat[1])
        } else {
            myDate[1] := FormatTime(myDate[1] . dateFormat[2], dateFormat[1])
            myDate[2] := FormatTime(myDate[2] . dateFormat[2], dateFormat[1])
            return myDate[1] . SplitChar . newLine . myDate[2]
        }
    }

    GetDateCW(CWsplitChar, onlyPreview?) {
        newLine := ""
        if IsSet(onlyPreview)
            newLine := "`n"
        
        myDate := StrSplit(DateSelect.Value, "-")
        if myDate[1] = myDate[2] {
           DateInsert := FormatTime(myDate[1], "YWeek") ;Result like: 200543
           return SubStr(DateInsert,1,4) . CWsplitChar . SubStr(DateInsert,5,2)
        } else {
           myDate[1] := FormatTime(myDate[1], "YWeek")
           myDate[1] := SubStr(myDate[1],1,4) . CWsplitChar . SubStr(myDate[1],5,2)
           myDate[2] := FormatTime(myDate[2], "YWeek")
           myDate[2] := SubStr(myDate[2],1,4) . CWsplitChar . SubStr(myDate[2],5,2)
           
           if myDate[1] = myDate[2] { ; Dates are on the same week
                return myDate[1]
           } else {
                return myDate[1] . SplitChar . newLine . myDate[2]
           }
           
           
       }
    }

    UpdateDates(*) {
        Date1.Value := GetDate(DateFormat1,"onlyPreview") ; . DateFormat1[3]
        Date2.Value := GetDate(DateFormat2,"onlyPreview") ; . DateFormat2[3]
        Date3.Value := GetDate(DateFormat3,"onlyPreview") ; . DateFormat3[3]
        Date4.Value := GetDateCW(DateFormatCWsplitChar,"onlyPreview")
    }

}



GetDateFormat(iniFormat) {
    DF := StrSplit(iniFormat,"|")
    ;DF[1] = Format for FormatTime function
    ;DF[2] = LCID
    ;DF[3] = language note
    switch DF.Length {
        case 1:
            DF.Push " LSys"         ;Formatting to defualt LCID
            DF.Push ""              ;Empty language note
        case 2:                     
            DF[2] := " L" . DF[2]   ;Formatting to custom LCID
            DF.Push ""              ;Empty language note
        case 3:
        DF[2] := " L" . DF[2]       ;Formatting to custom LCID    
        DF[3] := " [" . DF[3] . "]" ;Formatting to proper language note
    }
    return DF
}

ShowHelp(*){
    helpMsg1 := "Version: v1.0.3.`nCurrent Hotkey = " . formatHotkeyToHumanReadable(UserHotkey) . "`n`n"
    helpMsg2 := "
    (
        Keyboard navigation:

        Use the ↑ / ↓ and ← / → arrow keys, to move from field to field inside the control.
        Use PgUp/PgDn to move backward/forward by one month.
        Use Home/End to select the first/last day of the month.
        Calendar allows the user to shift-click or click-drag to select a range of adjacent dates.

        [Enter] Inserts the selected date(s) with the default date format.
        [1] ... [4] Hotkeys inserts the pre-defined formats.
        [C] Turns on/off the 'Copy to clipboard only' function.
    )"
        MsgBox helpMsg1 . helpMsg2, "DatePickerGO - Help"
    }

ShowOptions(*) {
    run iniFile
}

CreateIni() {
    iniContent := "
    (
    [Options]
    ;Optionally copy the inserted date(s)to the Clipboard also. Possible values = 1 (true) / 0 (false)
    CopyAlsoToClipboard=0

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
    ;DateFormat of the date inserted: "Format|LCID|language note"
    ;'Format' is the order and representation of years/months/days. Further info about letter-codes below.
    ;'LCID' means 'Language Code Identifier'. With this option, you can change the language of months and days. You can find a list of LCID references here: https://learn.microsoft.com/en-us/openspecs/office_standards/ms-oe376/6c085406-a698-4e12-9d4d-c3b0ee3dbc4a?utm_source=pocket_reader
    ;'language note' is just a hint for the user of the LCID code. This hint is displayed on the GUI button also. Like 'IT' (Italy) is more meningful, than '1040'.
    ;If you omit the LCID and language note items, the name of months and days will be presented based on the system localization setting.
    DateFormat1="yyyy.MM.dd."
    DateFormat2="yyyy.MM.dd., dddd"
    DateFormat3="LongDate|1033|EN"
    DateFormatCWsplitChar=".CW"

    ;Splitting character in case of date-range (like 2023.07.22. - 2024.07.22.)
    ;Typical values = "-", " - ", "/", " / "
    SplitChar=" - "

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
    ; "LongDate|1031|DE" => Donnerstag, 20. Juli 2023
    ; "LongDate|1038|HU" => 2023. július 20., csütörtök
    ; "yyyy.MMMM.dd. (dddd)|1040|IT" => 2023.luglio.20. (giovedì)

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

formatHotkeyToHumanReadable(hotkeyCode) {
    hotkeyCode := StrReplace(hotkeyCode, "+", "Shift+")
    hotkeyCode := StrReplace(hotkeyCode, "#", "Win+")
    hotkeyCode := StrReplace(hotkeyCode, "^", "Ctrl+")
    hotkeyCode := StrReplace(hotkeyCode, "!", "Alt+")
    return hotkeyCode
}