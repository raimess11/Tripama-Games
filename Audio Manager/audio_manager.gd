@tool
extends Node

@onready var male_voice = $MaleVoice
@onready var female_voice = $FemaleVoice
@onready var oompa_loompa_voice = $OompaLoompaVoice

@onready var sword_hit = $SwordHit
@onready var unsheated = $Unsheated
@onready var parry = $Parry

@onready var win_lose = $WinLose

#SFX for voices
func playRandomMaleVoice():
	male_voice.PlayRandomSound(false)

func playIndexMaleVoice(index: int):
	male_voice.PlayIndexSound(index)

func playRandomFemaleVoice():
	female_voice.PlayRandomSound(false)

func playIndexFemaleVoice(index: int):
	female_voice.PlayIndexSound(index)

func playOompaLoompaVoice():
	oompa_loompa_voice.PlayIndexSound(0)

#SFX for battle
func playRandomSwordHit():
	sword_hit.PlayRandomSound(false)

func playIndexSwordHit(index: int):
	sword_hit.PlayIndexSound(index)

func playRandomUnsheate():
	unsheated.PlayRandomSound(false)

func playIndexUnsheate(index: int):
	unsheated.PlayIndexSound(index)

func playRandomParry():
	parry.PlayRandomSound(false)

func playIndexParry(index: int):
	parry.PlayIndexSound(index)

func playWin():
	win_lose.PlayIndexSound(0)

func playLose():
	win_lose.PlayIndexSound(1)
