accessing
selectedEntry
	| entry proceed |
	entry := self currentDirectory / nameText text.
	filtersDropList selectedItem value
		ifNotEmpty: [ :extensions | 
			(nameText text includes: $.)
				ifFalse: [ entry := entry
						, ((extensions first copyReplaceAll: '*' with: '') withoutPrefix: '.') ] ].
	proceed := entry exists not.
	entry exists
		ifTrue: [ proceed := UIManager default
				proceed:
					('File named "{1}" already exists. Do you want to overwrite it?'
						format: {entry printString}) ].
	^ proceed
		ifTrue: [ entry ]
		ifFalse: [ nil ]