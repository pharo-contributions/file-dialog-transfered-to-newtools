initialization
initializeExtensionDropList
	extensionDropList
		items: self filteredExtensions;
		displayBlock: [ :item | 
			item key
				,
					(item value
						ifEmpty: [ '' ]
						ifNotEmpty: [ ' (' , ((item value collect: [ :each | '*.' , each ]) joinUsing: ', ') , ')' ]) ];
		whenSelectedItemChanged: [ :item | self filterExtensions: item value ];
		setSelectedIndex: 1