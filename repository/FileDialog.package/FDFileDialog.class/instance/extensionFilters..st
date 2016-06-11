public
extensionFilters: anArray
	self
		fileFilters:
			(anArray
				collect: [ :each | 
					| exts |
					exts := each value collect: [ :ext | '*.' , ext ].
					(each key
						, (each value ifEmpty: [ '' ] ifNotEmpty: [ ' (' , (exts joinUsing: ', ') , ')' ]))
						-> exts ])