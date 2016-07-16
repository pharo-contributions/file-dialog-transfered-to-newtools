initialization
initializePresenter
	| ec |
	super initializePresenter.
	(ec := EntryCompletion new)
		dataSourceBlock: [ :text | currentDirectory children collect: #basename ];
		filterBlock: [ :opt :text | opt beginsWith: text ].
	nameText entryCompletion: ec