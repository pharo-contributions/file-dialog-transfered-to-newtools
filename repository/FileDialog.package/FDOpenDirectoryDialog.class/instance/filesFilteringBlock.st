accessing
filesFilteringBlock
	^ [ :entries | 
	| e |
	e := filter directoriesOnly: entries.
	showHiddenFiles
		ifFalse: [ e := filter noHiddenFiles: e ].
	e ]