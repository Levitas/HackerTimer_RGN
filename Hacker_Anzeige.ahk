#IfWinActive, GTA:SA:MP
#SingleInstance force
SendMode Input

#include udf.ahk


SetTimer, chatlog, 250
SetTimer, HackTimer, 1000

Hack_Time := 0
Hack_CompleteTime := 0
Hack_Name := "Unbekannt"
Hack_Cooldown := 0

+T::
~t::
	Suspend On
	KeyWait t
return
~esc::
~enter::
~numpadenter::
	Suspend Off
return



chatlog:
FileGetSize CHATLOG_size, %A_MyDocuments%\GTA San Andreas User Files\SAMP\chatlog.txt
If (!CHATLOG_oldsize) {
	CHATLOG_oldsize := CHATLOG_size
	Loop, read, %A_MyDocuments%\GTA San Andreas User Files\SAMP\chatlog.txt
	{
		CHATLOG_zeile := A_Index
	}
}
If (CHATLOG_size != CHATLOG_oldsize) 
{
	Loop, read, %A_MyDocuments%\GTA San Andreas User Files\SAMP\chatlog.txt
	{
		chat := substr(A_LoopReadLine, 12)
		if (CHATLOG_zeile >= A_Index) {
			Continue 
		}
		If InStr(chat, "Du versuchst, die Akte von")
		{
			RegExMatch(chat, "Du versuchst, die Akte von (.*) zu hacken. ", var)
			RegExMatch(chat, "tens (.*) Wanteds entfernen." ,varr)
			
			Hack_Count := varr1
			Hack_Time := varr1 * 30
			Hack_CompleteTime := Hack_Time
			Hack_Name := var1
			price := varr1*300000
			
			sendChatMessage("/g [HACKER] Starte Hack von " Hack_Name ". Anzahl: " varr1)
			sendChatMessage("/g [HACKER] Dauer: " Hack_Time " Sekunden | Preis bei Erfolg: " price " $")
			
		}
		else if instr(chat, "Du hast dich in die Polizeiakte von " Hack_Name " gehackt und")
		{
			price := Hack_Count * 300000
			time := Hack_Count * 30
			sendChatMessage("/g [HACKER] Hack " Hack_Name " erfolgreich durchgeführt.")
			sendChatMessage("/g Anzahl: " Hack_Count " | Dauer: " time " Sekunden | Preis: " price "$")
			
			Hack_Time := 0
			Hack_Name = Unbekannt
			Hack_Count := 0
			Hack_Cooldown := 60*10
		}
		else if ( instr(chat, "Hackversuch fehlgeschlagen") )
		{
			Hack_Time := 0
			Hack_Name = Unbekannt
			Hack_Count := 0
			Hack_Cooldown := 60*10
			sendChatMessage("/g MIST! Hack an " Hack_Name "  ist fehlgeschlagen. Tut mir Leid =(")
			sendChatMessage("/g Zeit durchgehalten: " Hack_CompleteTime-(Hack_CompleteTime-Hack_Time) " Sekunden")
		}
		CHATLOG_zeile := A_Index
	}
}
return

HackTimer:
if ( Hack_Time > 0 )
{
	Hack_Time--
	send := 0
	if ( Hack_Time > 120 )
	{
		if ( mod(Hack_Time, 30) == 0 )
		{
			send := 1
		}
	}
	else if ( Hack_Time > 30 )
	{
		if (  mod(Hack_Time, 20) == 0 )
		{
			send := 1
		}
	}
	else if ( mod(Hack_Time, 10) == 0 )
	{
		send := 1
	}
	
	if ( send == 1 )
	{
		sendChatMessage("/g [HACKER] Hack von " Hack_Name " dauert noch [>" Hack_Time " Sekunden<]")
	}
}
if ( Hack_Cooldown > 0 )
{
	Hack_Cooldown--
	if ( Hack_Cooldown == 0 )
	{
		sendChatMessage("/g [Hack] Hack Cooldown ist abgelaufen. Bereit zum hacken!")
	}
}
return