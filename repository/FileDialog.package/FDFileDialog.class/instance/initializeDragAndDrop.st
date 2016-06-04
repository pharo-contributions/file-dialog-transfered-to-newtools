initialization
initializeDragAndDrop
	filesList dragEnabled: true.
	bookmarksList
		dropEnabled: true;
		wantDropBlock: [ :item :event :source | 
			item isTransferable
				and: [ item source = filesList
						and: [ item passenger first originalObject isDirectory
								and: [ (item passenger first originalObject basename = '..') not ] ] ] ];
		acceptDropBlock: [ :transfer :event :source :receiver | self addBookmark: transfer passenger first originalObject ]