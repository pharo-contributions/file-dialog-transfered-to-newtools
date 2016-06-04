accessing
selectedEntry
	| entry proceed |
	entry := self currentDirectory / nameText text.
	proceed := entry exists not.
	entry exists
		ifTrue: [ proceed := UIManager default
				proceed:
					('File named "{1}" already exists. Do you want to overwrite it?'
						format: {entry printString}) ].
	^ proceed
		ifTrue: [ entry ]
		ifFalse: [ nil ]