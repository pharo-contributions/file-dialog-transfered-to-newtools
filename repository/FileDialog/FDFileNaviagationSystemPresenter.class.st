Class {
	#name : #FDFileNaviagationSystemPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'filesList',
		'currentPathTextInputPresenter',
		'nameLabel',
		'nameText',
		'filtersDropList',
		'lastDirectoryVisitBeforeButton',
		'lastDirectoryVisitAfterButton',
		'readPointerHistoryParcour',
		'currentDirectory',
		'showHiddenFiles',
		'filesListContent',
		'hiddenFilter'
	],
	#classVars : [
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

{ #category : #'class initialization' }
FDFileNaviagationSystemPresenter class >> defaultDirectory [
	^ FileLocator imageDirectory asFileReference
]

{ #category : #'class initialization' }
FDFileNaviagationSystemPresenter class >> defaultFilterSet [
	^ FDAbstractPredicate actions
]

{ #category : #'class initialization' }
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
		add: #filesList;
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
	Directory := self defaultDirectory.
	FilterSet := self defaultFilterSet.
	Previewer := self defaultPreviewer.
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> changeDirectoryApplyToPresenter: aFolder [
	self flag: 'I have to rename it but I have no idea'.
	currentDirectory := aFolder canonicalize.
	currentPathTextInputPresenter text: currentDirectory fullName.
	filesList table items: (self filterACollection: self currentFiles).
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> createDirectory: initialName [
	| name path |
	name := (UIManager default
		request: 'Folder name'
		initialAnswer: initialName
		title: 'Create New Folder') ifNil: [ ^ self ].
	path := currentDirectory / name.
	path exists
		ifFalse: [ (currentDirectory / name) ensureCreateDirectory.
			self openFolder: currentDirectory.
			^ self ].
	path isDirectory
		ifTrue: [ UIManager default alert: 'A folder with that name already exists.' ].
	path isFile
		ifTrue: [ UIManager default alert: 'A file with that name already exists.' ].
	self createDirectory: name
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> currentDirectory [
	^ currentDirectory ifNil: [ currentDirectory := self defaultFolder ]
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
	currentDirectory := aFileReference.
	currentPathTextInputPresenter text: aFileReference fullName.
	filesList table items: aFileReference children
]

{ #category : #'initialize-actions' }
FDFileNaviagationSystemPresenter >> filesListAction [
	filesList table
		whenModelChangedDo: [ :selectedFileReference | 
			nameText
				text:
					(selectedFileReference selectedItem
						ifNotNil: [ selectedFileReference selectedItem basename ]
						ifNil: [ 'noFileSelected' ]) ].
	
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> filterACollection: aCollectionOfFileReference [
	| collection hiddenFilter |
	collection := aCollectionOfFileReference
		select:
			[ :fileReference | filtersDropList selectedItem predicate: fileReference ].
	showHiddenFiles
		ifFalse: [ collection
				removeAll:
					(collection
						select: [ :aFileReference | hiddenFilter predicate: aFileReference ]) ].
	^ collection
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
		transmitTo: filesList
		transform:
			[ :filterBis | filesListContent select: [ :item | filterBis predicate: item ] ]
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> initialize [
	super initialize.
	showHiddenFiles := false.
	hiddenFilter := FDHidenFilePredicate new.

]

{ #category : #'initialize-widgets' }
FDFileNaviagationSystemPresenter >> initializeFilesList [
	filesList table
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
	"self filtersDropListAction".
	self currentPathTextInputAction.
	self lastDirectoryVisitiBeforeButtonAction.
	self lastDirectoryVisitiAfterButtonAction
]

{ #category : #initialization }
FDFileNaviagationSystemPresenter >> initializeWidgets [
	currentDirectory := Directory copy.
	
	filesList := self instantiate: FDFileListPresenter.
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
	self initializeFilesList.
	self initializeFiltersDropList.
	self focusOrder
		add: lastDirectoryVisitBeforeButton;
		add: lastDirectoryVisitAfterButton ;
		add: currentPathTextInputPresenter;
		add: filesList;
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
FDFileNaviagationSystemPresenter >> openFolder: aFolder [
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
FDFileNaviagationSystemPresenter >> showHiddenFiles [
	^ showHiddenFiles
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> toggleHiddenFiles [
	showHiddenFiles := showHiddenFiles not.
	filesList items: (self filterACollection: self currentFiles) 
]
