# DatePickerGO
Quick pick of a date / date-range from a pup-up GUI. 

![DatePickerGO_anim](https://github.com/bigbadplayer/DatePickerGO/assets/20395062/7c311523-1284-4192-9a9d-0bc574fdc841)



## Features
- Hotkey for pop-up window with DatePicker (Default: Shift+Win+D)
- Quick-insert with the default date-format with [Enter]
- Hotkey for all four pre-configured date format inserts: [Ctrl]+1...4
- Date-format examples:

"yyyy.MM.dd." => 2023.07.22.

"dd/MM/yyyy" => 22/07/2023

"dd. MMMM yyyy." => 22. July 2023.

User can customize the followings within an ini file:
- Number of months visualized at once (max 4 rows and 3 columns).
- Four customizable date formats. Intermittent chars between start-end dates also configurable.
- Customizable Hotkey for the DatePicker GUI (Default: Shift+Win+D).

## Installation
Just download the .exe file and run it. It will create an ini file at first run. Then you can start right away to use the app, with the default hotkey: Shift+Win+D.
The app has a taskbar icon; right click on that to see the [Help] for the navigation infos; or for the [Options]. The latter will open an .ini file. You can find some instructions how to set up the parameters for your taste. The lines started with semicolon (;) are comment lines. Editable parameters like: ParameterName=Value. String ("not numbers") parameters needed to put in quotation marks.

## Intention and Use Cases
I was always bad at months and days. And I need to insert dates regularly into e-mails, documents and spreadsheets during my work. Always need to check the Windows Taskbar's Calendar, then need to remember the date, then type it without any typo. Once, I've seen a VBA add-in for Excel, similar to this aproach. And I liked it very much. I wished to use it _everywhere_. Then I found a little Autohotkey script on a forum. That was the base of this app. I turned it into AHK v2, made possible to select ranges. I'm not a programmer, it was fun to learn Ahk through the process. Then I guessed, it would be helpful to almost anyone who use windows and sometimes need to type some dates. Then I added some 'universal' functions for those users, who don't know how to use Autohotkey. They can configure some basic functions via a simple ini file.
The main use of this tool is the quick-date-insertion, during editing e-mails, documents, spreadsheets, web-forms, etc.

## Limitations
Using beside an Open/Save window is problematic: the DatePicker grabs the focus from the Open/Save Window and when the Window Focus switch back, the whole Editor line (filename) will be overwritten by the date inserted. A possible workaround could be, if the date inserted into a notepad first, then copied into the Open/Save Window.
