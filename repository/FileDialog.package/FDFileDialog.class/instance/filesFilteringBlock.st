accessing
filesFilteringBlock
	^ [ :entries | 
	| e |
	e := entries.
	showHiddenFiles
		ifFalse: [ e := filter noHiddenFiles: entries ].
	filtersDropList selectedItem value
		ifNotEmpty: [ :patterns | e := filter files: e matching: patterns ].
	e ]