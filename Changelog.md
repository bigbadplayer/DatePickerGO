# Changelog - DatePickerGO

## v1.0.3 **Working on progress**
- New: Preview of the selected date / range with the favourite date formats. The user don't need to remember the date format codes. Instead, he got a direct feedback of the result (before insertion).
- Fix: CW formatting inserted the week number twice, even when the selected days were on the same week.

## v1.0.2
- Mod: Change hotkey modifier key for favourites from Ctrl+Numbers to only Numbers (1 for first, 2 for second, and so on).
- Mod: Change default SplitChar from "-" to " - " .
- Mod: Change default DateFormatCWsplitChar from "/CW" to ".CW" .
- New: Added option for the user to use LCID codes to insert name of months/days with different languages. 
- New: Added option of _CopyAlsoToClipboard_. If it's value is 1 (true), the selected date(s) will be copied to clipboard also.
- New: Added _Copy to clipboard only_ option on GUI as a Checkbox. Hotkey: 'C'. (This could be a workaround for File Save dialogues)
In this case, the selected date(s) will be copied ONLY to the clipboard (regardless the state of CopyAlsoToClipboard option).
- New: 1x left mouse click on Tray icon opens calendar GUI.
- Fix: Further TrayIcon error debugging

## v1.0.1
- Fix: TrayIcon error