Class {
	#name : #FDFileNaviagationSystemPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'currentPathTextInputPresenter',
		'nameLabel',
		'nameText',
		'filtersDropList',
		'lastDirectoryVisitBeforeButton',
		'lastDirectoryVisitAfterButton',
		'readPointerHistoryParcour',
		'currentDirectory',
		'filesListContent',
		'hiddenFilter',
		'table',
		'columns',
		'previewer'
	],
	#classVars : [
		'Columns',
		'Directory',
		'FilterSet',
		'Previewer'
	],
	#category : #'FileDialog-UI'
}

{ #category : #commands }
FDFileNaviagationSystemPresenter class >> buildCommandsGroupWith: presenter forRoot: rootCommandGroup [
	rootCommandGroup
		register:
			((CmCommandGroup named: 'interact with file') asSpecGroup
				register: (FDCreatDirectoryCommand forSpec context: presenter);
				register: (FDToggleHiddenFilesCommand forSpec context: presenter);
				yourself)
]

{ #category : #defaults }
FDFileNaviagationSystemPresenter class >> defaultColumns [
	^ {
	FDIconFileReferenceTableColumn column width: 20.
	FDbasenameFileReferenceColumn column.
	FDSizeFileReferenceColumn column.
	FDAccessRightFileReferenceColumn column}
]

{ #category : #defaults }
FDFileNaviagationSystemPresenter class >> defaultDirectory [
	^ FileLocator imageDirectory asFileReference
]

{ #category : #'class initialization' }
FDFileNaviagationSystemPresenter class >> defaultFilterSet [
	^ FDAbstractPredicate actions
]

{ #category : #defaults }
FDFileNaviagationSystemPresenter class >> defaultPreviewer [
	^ nil
]

{ #category : #specs }
FDFileNaviagationSystemPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add:
			(SpBoxLayout newHorizontal
				add: #lastDirectoryVisitBeforeButton
					withConstraints: [ :contraint | contraint width: 30 ];
				add: #lastDirectoryVisitAfterButton
					withConstraints: [ :contraint | contraint width: 30 ];
				add: #currentPathTextInputPresenter;
				yourself)
			withConstraints: [ :contraint | contraint height: self toolbarHeight ];
		add: (SpBoxLayout newVertical 
				add: #table;
				add: #previewer;
				yourself);
		add:
			(SpBoxLayout newHorizontal
				add: #nameLabel
					withConstraints: [ :contraint | contraint width: 35 ];
				add: #nameText;
				add: #filtersDropList
					withConstraints: [ :contraint | contraint width: 140 ];
				yourself)
			withConstraints: [ :contraint | contraint height: self toolbarHeight ];
		yourself
]

{ #category : #examples }
FDFileNaviagationSystemPresenter class >> example [
	<example>
	| presenter |
	presenter := self new.
	presenter defaultFolder: FileLocator documents.
	presenter openWithSpec.
	^ presenter
]

{ #category : #'class initialization' }
FDFileNaviagationSystemPresenter class >> initialize [
	FilterSet := self defaultFilterSet.
	Previewer := self defaultPreviewer.
	Columns := self defaultColumns.
	Directory := self defaultDirectory
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> changeDirectoryApplyToPresenter: aFolder [
	self flag: 'I have to rename it but I have no idea'.
	currentDirectory := aFolder canonicalize.
	currentPathTextInputPresenter text: currentDirectory fullName.
	table table items: (self filterACollection: self currentFiles).
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> createDirectory: initialName [
	| name path |
	name := (UIManager default
		request: 'Folder name'
		initialAnswer: initialName
		title: 'Create New Folder') ifNil: [ ^ self ].
	path := self currentDirectory / name.
	path exists
		ifFalse: [ (self currentDirectory / name) ensureCreateDirectory.
			self openFolder: currentDirectory.
			^ self ].
	path isDirectory
		ifTrue: [ UIManager default alert: 'A folder with that name already exists.' ].
	path isFile
		ifTrue: [ UIManager default alert: 'A file with that name already exists.' ].
	self createDirectory: name
]

{ #category : #accessing }
FDFileNaviagationSystemPresenter >> currentDirectory [ 
	^ currentDirectory
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> currentFiles [
	^ (((self isRootDirectory: currentDirectory)
		ifTrue: [ {} ]
		ifFalse: [ {(self currentDirectory / '..')} ])
		, self currentDirectory children)
		asOrderedCollection
		sort: [ :a :b | 
			(a isDirectory & b isDirectory not
				or: [ a isDirectory & b isDirectory
						& (a basename asLowercase < b basename asLowercase) ])
				or: [ a isFile & b isFile
						& (a basename asLowercase < b basename asLowercase) ] ]
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> currentPathTextInputAction [
	currentPathTextInputPresenter
		whenTextIsAcceptedDo: [ :text | 
			text asFileReference exists
				ifFalse: [ self
						inform: 'you have to write an absolute path and an existing one' ]
				ifTrue: [ self openFolder: text asFileReference ] ]
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> currentPathTextInputPresenter [
	^ currentPathTextInputPresenter
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> defaultFolder: aFileReference [
	currentDirectory:= aFileReference.
	currentPathTextInputPresenter text: aFileReference fullName.
	table items: aFileReference children
]

{ #category : #'initialize-actions' }
FDFileNaviagationSystemPresenter >> filesListAction [
	table
		transmitTo: nameText
		transform: [ :selectedItem | selectedItem basename ].
	table
		whenActivatedDo: [ :selectedItem | 
			selectedItem selectedItem isDirectory
				ifTrue: [ self openFolder: selectedItem selectedItem ] ]
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> filtersCustomization: aCollectionOfFilter [
	"i always add the filter 'no filter'"

	filtersDropList
		items:
			(aCollectionOfFilter asOrderedCollection
				add: FDDefaultPredicate new;
				yourself) asSet asOrderedCollection.
	filtersDropList
		selectedIndex:
			((filtersDropList listItems collect: #name)
				indexOf: FDDefaultPredicate new name)
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> filtersDropList [
	^ filtersDropList
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> filtersDropListAction [
	filtersDropList
		whenSelectionChangedDo: [ self openFolder: currentDirectory ]
]

{ #category : #initialization }
FDFileNaviagationSystemPresenter >> initialize [
	super initialize.
	hiddenFilter := FDDefaultPredicate new.

]

{ #category : #'initialize-widgets' }
FDFileNaviagationSystemPresenter >> initializeFilesList [
	table
		contextMenu: [ (self rootCommandsGroup / 'interact with file') beRoot
				asMenuPresenter ]
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> initializeFiltersDropList [
	| filterItems |
	filterItems := FilterSet copy.
	filterItems asOrderedCollection  add: FDDefaultPredicate new.
	filterItems := filterItems asSet.
	filtersDropList
		items:  filterItems asOrderedCollection ;
		displayBlock: [ :item | item name ];
		selectedIndex:
			((filtersDropList listItems collect: #name)
				indexOf: FDDefaultPredicate new name)
]

{ #category : #initialization }
FDFileNaviagationSystemPresenter >> initializePresenter [
	self filesListAction.
	self filtersDropListAction.
	self currentPathTextInputAction.
	self lastDirectoryVisitiBeforeButtonAction.
	self lastDirectoryVisitiAfterButtonAction
]

{ #category : #initialization }
FDFileNaviagationSystemPresenter >> initializeWidgets [
	currentDirectory := Directory copy.
	columns := Columns.
	
	previewer := self instantiate: FDNoteBookPreviewerPresenter.
	table := self newTable.
	currentPathTextInputPresenter := self newTextInput.
	nameLabel := self newLabel.
	nameText := self newTextInput.
	filtersDropList := self newDropList.
	lastDirectoryVisitBeforeButton := self newButton.
	lastDirectoryVisitAfterButton := self newButton.
	
	readPointerHistoryParcour := DoubleLink value: currentDirectory.
	currentPathTextInputPresenter text: currentDirectory fullName.
	lastDirectoryVisitAfterButton
		icon: (self iconNamed: #glamorousDiveRight).
	lastDirectoryVisitBeforeButton icon: (self iconNamed: #back).
	nameLabel label: 'Name:'.
	nameText autoAccept: true.
	table
		columns: columns;
		sortingBlock: [ :a :b | 
			(a isDirectory & b isDirectory not
				or: [ a isDirectory & b isDirectory
						& (a basename asLowercase < b basename asLowercase) ])
				or: [ a isFile & b isFile
						& (a basename asLowercase < b basename asLowercase) ] ].
	self initializeFilesList.
	self initializeFiltersDropList.
	self focusOrder
		add: lastDirectoryVisitBeforeButton;
		add: lastDirectoryVisitAfterButton ;
		add: currentPathTextInputPresenter;
		add: table;
		add: nameText;	
		add: filtersDropList
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> lastDirectoryVisitAfterButton [
	^ lastDirectoryVisitAfterButton
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> lastDirectoryVisitBeforeButton [
	^ lastDirectoryVisitBeforeButton
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> lastDirectoryVisitiAfterButtonAction [
	lastDirectoryVisitAfterButton
		action: [ readPointerHistoryParcour hasSuccessor
				ifFalse: [ self
						inform:
							'this button is use to go after clicking on <- button to return on the last directory' ]
				ifTrue: [ self
						changeDirectoryApplyToPresenter: readPointerHistoryParcour nextLink value.
					readPointerHistoryParcour := readPointerHistoryParcour nextLink ] ]
]

{ #category : #'initialize-actions' }
FDFileNaviagationSystemPresenter >> lastDirectoryVisitiBeforeButtonAction [
	lastDirectoryVisitBeforeButton
		action: [ readPointerHistoryParcour hasPredecessor
				ifFalse: [ self inform: 'this button is used to go to the last directory ' ]
				ifTrue: [ self
						changeDirectoryApplyToPresenter: readPointerHistoryParcour previousLink value.
					readPointerHistoryParcour := readPointerHistoryParcour
						previousLink ] ]
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> nameLabel [
	^ nameLabel
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> openFolder: aFileReference [
	currentDirectory := aFileReference.
	self updateTableContent.
	currentPathTextInputPresenter text: currentDirectory fullName
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> openFolderBis: aFolder [
	self changeDirectoryApplyToPresenter: aFolder.
	(readPointerHistoryParcour value children includes: currentDirectory)
		ifTrue: [ readPointerHistoryParcour
				nextLink:
					((DoubleLink value: currentDirectory)
						previousLink: readPointerHistoryParcour;
						yourself).
			readPointerHistoryParcour := readPointerHistoryParcour nextLink ]
		ifFalse: [ readPointerHistoryParcour
				value: currentDirectory;
				nextLink: nil;
				previousLink: nil ]
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> readPointerHistoryParcour [
	^ readPointerHistoryParcour
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> toggleHiddenFiles [
	1 halt.
	(hiddenFilter equals: FDDefaultPredicate new)
		ifTrue: [ hiddenFilter := FDHidenFilePredicate new ]
		ifFalse: [ hiddenFilter := FDDefaultPredicate new ].
	self updateTableContent
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> updateTableContent [
	table
		items:
			(hiddenFilter
				applyOn: (filtersDropList selectedItem applyOn: currentDirectory children))
]
