actions
confirm
	self selectedEntry
		ifNotNil: [ :entry | 
			onConfirmBlock value: entry.
			self delete ]