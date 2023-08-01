# DatePickerGO
Quick pick a date / date-range easily with this pup-up Calendar. 

![DatePickerGO_anim](https://github.com/bigbadplayer/DatePickerGO/assets/20395062/7c311523-1284-4192-9a9d-0bc574fdc841)

## Introduction
Have you ever needed to type in calendar dates? If the answer is yes, may you will be interested in trying this calendar app for easy select + insert dates / date-ranges.
No need to search for the taskbar's calendar; because this configurable DatePicker is just a Keyboard Shortcut away from you. Past or Future? E-mail or document? No matter, just pick-and-insert.

## Features
- Hotkey for pop-up window with DatePicker (Default: Shift+Win+D)
- Instant preview of formatted date
- Select Date/DateRanges with mouse click or with navigation keys on keyboard
- Quick-insert with the default date-format with [Enter]
- Hotkey for all four pre-configured date formats: [1]...[4]
- Date-format examples (detailes in the ini file):

"yyyy.MM.dd." => 2023.07.22.

"dd/MM/yyyy" => 22/07/2023

"dd. MMMM yyyy." => 22. July 2023.

Usage of LCID option:

"LongDate|1031|DE" => Donnerstag, 20. Juli 2023

"LongDate|1038|HU" => 2023. július 20., csütörtök
    
"yyyy.MMMM.dd. (dddd)|1040|IT" => 2023.luglio.20. (giovedì)

### User can customize the followings within an ini file:
- Number of months visualized at once (max 4 rows and 3 columns).
- Four customizable date formats. Intermittent chars between start-end dates also configurable.
- Customizable Hotkey for the DatePicker GUI (Default: Shift+Win+D).

![DatePickerGO_DateFormatsHelp](https://github.com/bigbadplayer/DatePickerGO/assets/20395062/b03b0ada-d832-4fa6-9c5e-9f6db4e1f327)

#### v.1.0.2 screenshot:
![DatePickerGO 1.0.2 screenshot](https://user-images.githubusercontent.com/20395062/254746801-2b7067e0-146b-4865-997a-0f1ee815a4f7.png)

## Download
[Latest release](https://github.com/bigbadplayer/DatePickerGO/releases/download/v1.0.3/DatePickerGO-v1.0.3.zip)


## Installation
Just download the .exe file and run it. It will create an ini file at first run with Options. Then you can start right away to use the app, with the default hotkey: Shift+Win+D.
The app has a taskbar icon; right click on that to see the [Help] for the navigation infos; or for the [Options]. The latter will open an .ini file. You can find some instructions how to set up the parameters for your taste. The lines started with semicolon (;) are comment lines. Editable parameters like: ParameterName=Value. String ("not numbers") parameters needed to put in quotation marks: ParameterName="StringValue"

## Intention and Use Cases
I was always bad at months and days. And I need to insert dates regularly into e-mails, documents and spreadsheets during my work. Always need to check the Windows Taskbar's Calendar, then need to remember the date, then type it without any typo. Once, I've seen a VBA add-in for Excel, similar to this DatePicker approach. And I liked it very much. I wished to use it _everywhere_. Then I found a little Autohotkey script on [Thierry Dalon's Blog](https://tdalon.blogspot.com/2020/09/autohotkey-insert-date.html). That was the base of this app. I turned it into AHK v2, made possible to select ranges. I'm not a programmer, it was fun to learn Ahk through the process. Then I guessed, it would be helpful to almost anyone who use windows and sometimes need to type some dates. Then I added some 'universal' functions for those users, who don't know how to use Autohotkey. They can configure some basic functions via a simple ini file.
The main use of this tool is the quick-date-insertion, during editing e-mails, documents, spreadsheets, web-forms, etc.

I was trying to keep in mind that, there are plenty of date formats. If you are in a multi-national environment/company, you may use multiple formats simultaneously. That's why I added more than one date-format options. The fourth one is specially for managers, who thinking in week numbers.

## Limitations
Using beside an Open/Save window is a bit problematic: the DatePicker grabs the focus from the Open/Save Window and when the Window Focus switches back, the whole Editor line (filename) will be overwritten by the date inserted. 
A possible workaround could be, if you check the "Copy to clipboard only" (v1.0.2) option on the calendar GUI, then paste it into the Open/Save Window.

## Technical information
Code written in Autohorkey v2. Source .ahk file (with Autohotkey v2 installed) and compiled .exe binary work on Windows. The app was tested only on Windows 10.

## Inspirations
The basic idea, and the core of the app comes from [tdalon](https://github.com/tdalon/ahk)'s ahk script collection.
The LCID option and CopyOnlyToClipboard idea comes from [lintalist](https://github.com/lintalist/lintalist). Check them too :)
