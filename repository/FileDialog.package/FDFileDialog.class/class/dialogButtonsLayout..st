specs
dialogButtonsLayout: aRow
	OSPlatform current isWindows
		ifTrue: [ ^ aRow
				add: #confirmButton width: 60;
				add: #cancelButton width: 60 ]
		ifFalse: [ ^ aRow
				add: #cancelButton width: 60;
				add: #confirmButton width: 60 ]