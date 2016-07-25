initialization
initializeFilesList
	filesList
		items: self currentFiles;
		autoDeselect: true;
		displayBlock: [ :entry | entry basename ];
		icons: [ :entry | self iconFor: entry ];
		filteringBlock: self filesFilteringBlock;
		sortingBlock: [ :a :b | 
			(a isDirectory & b isDirectory not
				or: [ a isDirectory & b isDirectory & (a basename asLowercase < b basename asLowercase) ])
				or: [ a isFile & b isFile & (a basename asLowercase < b basename asLowercase) ] ].
	filesList
		whenSelectedItemChanged: [ :entry | 
			entry
				ifNotNil: [ entry isDirectory
						ifTrue: [ self openFolder: entry ]
						ifFalse: [ self selectFile: entry ] ] ].
	filesList
		menu: [ :aMenu :shifterd | 
			aMenu
				add: 'Create directory' target: self selector: #createDirectory;
				add: 'Toggle hidden files' target: self selector: #toggleHiddenFiles;
				yourself ]