"
I am an abstract base class for different styles of opening/saving.

Don't use me directly -- instead use one of my children.

## Examples

see class-side

## Website

https://github.com/peteruhnak/file-dialog
"
Class {
	#name : #FDFileDialogPresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'bookmarksList',
		'createFolderButton',
		'nameText',
		'filesList',
		'currentDirectory',
		'nameLabel',
		'onConfirmBlock',
		'showHiddenFiles',
		'filter',
		'filtersDropList',
		'fileFilters',
		'currentFolderLabel',
		'filesListContent',
		'noRemovableBookmarks',
		'hiddenFilter'
	],
	#classVars : [
		'CustomBookmarks'
	],
	#classInstVars : [
		'customShortcut'
	],
	#category : #FileDialog
}

{ #category : #adding }
FDFileDialogPresenter class >> addBookmark: aFolder [
	self customBookmarks detect: [ :each | each location = aFolder ] ifFound: [ ^ self ].
	self customBookmarks
		add: (FDBookmark name: aFolder basename location: aFolder icon: (self iconNamed: #open))
]

{ #category : #icons }
FDFileDialogPresenter class >> allIcons [
	<script: 'self allIcons inspect'>
	^ (Pragma allNamed: 'icons' in: FDFileDialogPresenter class)
		flatCollect:
			[ :pragma | pragma methodClass instanceSide perform: pragma methodSelector ]
]

{ #category : #commander2 }
FDFileDialogPresenter class >> buildCommandsGroupWith: presenter forRoot: rootCommandGroup [
	rootCommandGroup
		register:
			((CmCommandGroup named: 'interact with file') asSpecGroup
				register: (FDCreatDirectoryCommand forSpec context: presenter);
				register: (FDToggleHiddenFilesCommand forSpec context: presenter);
				yourself);
		register:
			((CmCommandGroup named: 'bookmark menu') asSpecGroup
				register: (FDRemoveBookMarkCommand forSpec context: presenter);
				yourself)
]

{ #category : #adding }
FDFileDialogPresenter class >> convertBookmarks: aDictionary [
	"convert bookmarks from old OrderedDictionary of location->#(name icon) to FDBookmark instances"

	^ aDictionary associations asOrderedCollection
		collect: [ :pair | FDBookmark name: pair value first location: pair key icon: pair value second ]
]

{ #category : #adding }
FDFileDialogPresenter class >> customBookmarks [
	CustomBookmarks isDictionary
		ifTrue: [ CustomBookmarks := self convertBookmarks: CustomBookmarks ].
	^ CustomBookmarks ifNil: [ CustomBookmarks := OrderedCollection new ]
]

{ #category : #adding }
FDFileDialogPresenter class >> customBookmarks: aCollection [
	self assert: [ aCollection isKindOf: OrderedCollection ].
	self assert: [ aCollection allSatisfy: [ :each | each isKindOf: FDBookmark ] ].
	CustomBookmarks := aCollection
]

{ #category : #specs }
FDFileDialogPresenter class >> defaultSpec [
	^ SpecBoxLayout newVertical
		add:
			(SpecBoxLayout newHorizontal
				add: #bookmarksList
					withConstraints: [ :contraint | contraint width: 150 ];
				add:
					(SpecBoxLayout newVertical
						add: #currentFolderLabel
							withConstraints: [ :contraint | contraint height: self toolbarHeight ];
						add: #filesList;
						yourself);
				yourself);
		add:
			(SpecBoxLayout newHorizontal 
				add: #nameLabel
					withConstraints: [ :contraint | contraint width: 50 ];
				add: #nameText;
				add: #filtersDropList
					withConstraints: [ :contraint | contraint width: 200 ];
				yourself)withConstraints: [ :contraint | contraint height: self toolbarHeight]
			yourself
]

{ #category : #example }
FDFileDialogPresenter class >> example [
	^ FDOpenFileDialog new
		whenSelected: [ :file | file inspect ];
		defaultFolder: FileLocator imageDirectory asFileReference;
		defaultName: 'hello.png';
		openDialogWithSpec
]

{ #category : #example }
FDFileDialogPresenter class >> exampleModal [
	"modal returns the selected value"

	(FDOpenDirectoryDialog new
		defaultFolder: FileLocator imageDirectory asFileReference;
		openModal) inspect
]

{ #category : #'instance creation' }
FDFileDialogPresenter class >> open [
	^ self new openDialogWithSpec
]

{ #category : #'instance creation' }
FDFileDialogPresenter class >> openOn: aCollectionOfFDBookMark [
]

{ #category : #adding }
FDFileDialogPresenter class >> removeBookmark: aFolder [
	self customBookmarks removeAllSuchThat: [ :each | each location = aFolder ]
]

{ #category : #icons }
FDFileDialogPresenter class >> textIcons [
	<icons>
	^ {(#st -> (self iconNamed: #smallLeftFlush)).
		(#txt -> (self iconNamed: #smallLeftFlush))}
]

{ #category : #bookmarks }
FDFileDialogPresenter >> addBookmark: aFolder [
	self class addBookmark: aFolder.
	self refreshBookmarks
]

{ #category : #bookmarks }
FDFileDialogPresenter >> bookmarks [
	^ noRemovableBookmarks , self customBookmarks
]

{ #category : #'accessing - spec fields' }
FDFileDialogPresenter >> bookmarksList [
	^ bookmarksList
]

{ #category : #'initialize-actions' }
FDFileDialogPresenter >> bookmarksListAction [
	bookmarksList
		whenSelectionChangedDo: [ :selection | 
			selection selectedItem
				ifNotNil: [ self openFolder: selection selectedItem location ] ]
]

{ #category : #utility }
FDFileDialogPresenter >> canonicalize: aFileReference [
	^ (aFileReference respondsTo: #canonicalize)
		ifTrue: [ ">= P7" aFileReference canonicalize ]
		ifFalse: [ "<= P6" aFileReference pathString asFileReference ]
]

{ #category : #actions }
FDFileDialogPresenter >> confirm [
	nameText text isNotEmpty
		ifFalse: [ ^ self inform: 'you have to select a file' ].
	self selectedEntry
		ifNotNil: [ :entry | 
			onConfirmBlock value: entry.
			self delete ]
]

{ #category : #actions }
FDFileDialogPresenter >> createDirectory [
	^ self createDirectory: 'new-folder'
]

{ #category : #actions }
FDFileDialogPresenter >> createDirectory: initialName [
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

{ #category : #'accessing - spec fields' }
FDFileDialogPresenter >> createFolderButton [
	^ createFolderButton
]

{ #category : #accessing }
FDFileDialogPresenter >> currentDirectory [
	^ currentDirectory ifNil: [ currentDirectory := self defaultFolder ]
]

{ #category : #accessing }
FDFileDialogPresenter >> currentFiles [
	^ (((self isRootDirectory: currentDirectory)
		ifTrue: [ {} ]
		ifFalse: [ {(self currentDirectory / '..')} ])
		, self currentDirectory children) asOrderedCollection
		sort: [ :a :b | 
			(a isDirectory & b isDirectory not
				or: [ a isDirectory & b isDirectory
						& (a basename asLowercase < b basename asLowercase) ])
				or: [ a isFile & b isFile
						& (a basename asLowercase < b basename asLowercase) ] ]
]

{ #category : #'accessing - spec fields' }
FDFileDialogPresenter >> currentFolderLabel [
	^ currentFolderLabel
]

{ #category : #utility }
FDFileDialogPresenter >> currentFolderTitleFor: aString [
	| e optimal max leftBarWidth |
	e := self window ifNil: [ self initialExtent ] ifNotNil: [ self window window extent ].
	leftBarWidth := 200.
	optimal := (LabelMorph contents: aString) optimalExtent x.
	max := e x - leftBarWidth.
	optimal < max
		ifTrue: [ ^ aString , self delimiter ].
	^ '... ' , (aString last: (aString size * (max / optimal)) rounded) , self delimiter
]

{ #category : #bookmarks }
FDFileDialogPresenter >> customBookmarks [
	^ self class customBookmarks
]

{ #category : #bookmarks }
FDFileDialogPresenter >> defaultBookmarks [
	| presets |
	presets := OrderedCollection new.
	presets add: FDBookmark image.
	presets add: FDBookmark home.
	OSPlatform current isUnix
		ifTrue: [ presets add: FDBookmark root.
			presets add: FDBookmark tmp ].
	OSPlatform current isWindows
		ifTrue: [ presets addAll: FDBookmark windowsDrives ].
	^ presets
]

{ #category : #accessing }
FDFileDialogPresenter >> defaultFolder [
	^ FileLocator imageDirectory asFileReference
]

{ #category : #public }
FDFileDialogPresenter >> defaultFolder: aPath [
	(aPath isNotNil and: [ aPath asFileReference exists ])
		ifTrue: [ self openFolder: aPath asFileReference ]
		ifFalse: [ self openFolder: self defaultFolder ]
]

{ #category : #public }
FDFileDialogPresenter >> defaultName: aString [
	nameText text: aString
]

{ #category : #accessing }
FDFileDialogPresenter >> delimiter [
	^ FileSystem disk delimiter asString
]

{ #category : #public }
FDFileDialogPresenter >> extensionFilters: anArray [
	self
		fileFilters:
			(anArray
				collect: [ :each | 
					| exts |
					exts := each value collect: [ :ext | '*.' , ext ].
					(each key
						, (each value ifEmpty: [ '' ] ifNotEmpty: [ ' (' , (exts joinUsing: ', ') , ')' ]))
						-> exts ])
]

{ #category : #accessing }
FDFileDialogPresenter >> fileFilters [
	^ fileFilters ifNil: [ fileFilters := self class filterAllFiles ]
]

{ #category : #public }
FDFileDialogPresenter >> fileFilters: anArray [
	anArray ifEmpty: [ ^ self ].
	anArray anyOne isString
		ifTrue: [ fileFilters := {(anArray joinUsing: ', ') -> anArray} ]
		ifFalse: [ fileFilters := anArray ].
	filtersDropList items: fileFilters
]

{ #category : #'accessing - spec fields' }
FDFileDialogPresenter >> filesList [
	^ filesList
]

{ #category : #'initialize-actions' }
FDFileDialogPresenter >> filesListAction [
	filesList
		whenSelectionChangedDo: [ :selection | 
			[ :entry | 
			entry
				ifNotNil: [ entry isDirectory
						ifTrue: [ self openFolder: entry ]
						ifFalse: [ self selectFile: entry ] ] ]
				cull: selection selectedItem ]
]

{ #category : #'initialize-actions' }
FDFileDialogPresenter >> filterACollection: aCollectionOfFileReference [
	| collection |
	collection := aCollectionOfFileReference
		select:
			[ :fileReference | filtersDropList selectedItem filter: fileReference ].
	showHiddenFiles
		ifFalse: [ collection
				removeAll:
					(collection
						select: [ :aFileReference | hiddenFilter filter: aFileReference ]) ].
	^ collection
]

{ #category : #'accessing - spec fields' }
FDFileDialogPresenter >> filtersDropList [
	^ filtersDropList
]

{ #category : #accessing }
FDFileDialogPresenter >> iconFor: anEntry [
	| icons ext |
	icons := self icons.
	anEntry isDirectory
		ifTrue: [ ^ self iconNamed: #open ].
	ext := anEntry extension.
	^ self class allIcons asDictionary
		at: ext
		ifPresent: [ :icon | icon ]
		ifAbsent: [ self iconNamed: #page ]
]

{ #category : #accessing }
FDFileDialogPresenter >> icons [
	^ Smalltalk ui icons
]

{ #category : #api }
FDFileDialogPresenter >> initialExtent [
	^ 550 @ 550
]

{ #category : #api }
FDFileDialogPresenter >> initialTitle [
	^ self subclassResponsibility
]

{ #category : #initialization }
FDFileDialogPresenter >> initialize [
	showHiddenFiles := false.
	onConfirmBlock := [ :selection |  ].
	super initialize.
	hiddenFilter := FDHidenFileFilter new.
	self defaultFolder: self defaultFolder
]

{ #category : #'initialize-widgets' }
FDFileDialogPresenter >> initializeBookmarksList [
	noRemovableBookmarks  := self defaultBookmarks.
	bookmarksList items: self bookmarks.
	bookmarksList displayBlock: [ :each | each name ].
	bookmarksList icons: [ :each | each icon ].
	self selectBookmarkFor: self currentDirectory.
	bookmarksList
		contextMenu: [ (self rootCommandsGroup / 'bookmark menu') beRoot asMenuPresenter ]
]

{ #category : #initialization }
FDFileDialogPresenter >> initializeDialogWindow: aDialogWindowPresenter [
	super initializeDialogWindow: aDialogWindowPresenter.
	aDialogWindowPresenter title: self initialTitle.
	aDialogWindowPresenter
		okAction: [ self confirm ];
		cancelAction: [ self delete ]
]

{ #category : #'initialize-widgets' }
FDFileDialogPresenter >> initializeDragAndDrop [
	filesList dragEnabled: true.
	bookmarksList
		dropEnabled: true;
		wantDropBlock: [ :item :event :source | 
			item isTransferable
				and: [ item source = filesList
						and: [ item passenger first originalObject isDirectory
								and: [ (item passenger first originalObject basename = '..') not ] ] ] ];
		acceptDropBlock:
				[ :transfer :event :source :receiver | self addBookmark: transfer passenger first originalObject ]
]

{ #category : #'initialize-widgets' }
FDFileDialogPresenter >> initializeFilesList [
	filesList
		items: self currentFiles;
		displayBlock: [ :entry | entry basename ];
		icons: [ :entry | self iconFor: entry ].
	filesListContent := filesList items.
	filesList
		contextMenu: [ (self rootCommandsGroup / 'interact with file') beRoot
				asMenuPresenter ]
]

{ #category : #'initialize-widgets' }
FDFileDialogPresenter >> initializeFiltersDropList [
	filtersDropList
		items: FDAbstractFilter actions;
		displayBlock: [ :item | item name ];
		selectedIndex:
			((filtersDropList listItems collect: #name)
				indexOf: FDDefaultFilter new name)
]

{ #category : #initialization }
FDFileDialogPresenter >> initializePresenter [
	self bookmarksListAction.
	self filesListAction.
	filtersDropList
		transmitTo: filesList
		transform:
			[ :filterBis | filesListContent select: [ :item | filterBis filter: item ] ].
	self initializeDragAndDrop
]

{ #category : #initialization }
FDFileDialogPresenter >> initializeWidgets [
	bookmarksList := self newList.
	currentFolderLabel := self newLabel.
	filesList := self newList.
	createFolderButton := self newButton.
	(nameLabel := self newLabel) label: 'Name:'.
	(nameText := self newTextInput) autoAccept: true.
	filtersDropList := self newDropList.
	self initializeBookmarksList.
	self initializeFilesList.
	self initializeFiltersDropList.
	self focusOrder
		add: nameText;
		add: filtersDropList
]

{ #category : #accessing }
FDFileDialogPresenter >> isRootDirectory: aDirectory [
	^ aDirectory isRoot or: [ OSPlatform current isWindows and: [ aDirectory parent isRoot ] ]
]

{ #category : #'accessing - spec fields' }
FDFileDialogPresenter >> nameLabel [
	^ nameLabel
]

{ #category : #'accessing - spec fields' }
FDFileDialogPresenter >> nameText [
	^ nameText
]

{ #category : #accessing }
FDFileDialogPresenter >> noRemovableBookmarks [
	^ noRemovableBookmarks
]

{ #category : #'instance creation' }
FDFileDialogPresenter >> open [
	^ self openDialogWithSpec
]

{ #category : #actions }
FDFileDialogPresenter >> openFolder: aFolder [
	currentDirectory := self canonicalize: aFolder.
	currentFolderLabel
		label: (self currentFolderTitleFor: currentDirectory pathString);
		help: currentDirectory pathString , self delimiter.
	filesList items: (self filterACollection: self currentFiles).
	filesListContent := filesList items.
	filesList unselectAll.
	self selectBookmarkFor: currentDirectory
]

{ #category : #'instance creation' }
FDFileDialogPresenter >> openModal [
	| result |
	self whenSelected: [ :file | result := file ].
	self openWithSpec modalRelativeTo: self currentWorld.
	^ result
]

{ #category : #bookmarks }
FDFileDialogPresenter >> refreshBookmarks [
	bookmarksList items: self bookmarks
]

{ #category : #bookmarks }
FDFileDialogPresenter >> removeBookmark: aBookmark [
	self class removeBookmark: aBookmark location.
	self refreshBookmarks
]

{ #category : #utility }
FDFileDialogPresenter >> selectBookmarkFor: aDirectory [
	"bookmarksList' ListModel uses identity based comparison, so I need to select index instead"

	"is there withIndexDetect: ?"

	bookmarksList
		selectIndex: ((self bookmarks collect: #location) indexOf: aDirectory)
]

{ #category : #actions }
FDFileDialogPresenter >> selectFile: aFile [
	filesList selection selectedItem = aFile
		ifFalse: [ filesList selectIndex: (filesList model items indexOf: aFile) ].
	nameText text: aFile basename
]

{ #category : #accessing }
FDFileDialogPresenter >> selectedBookMark [
	^ bookmarksList selection selectedItem
]

{ #category : #accessing }
FDFileDialogPresenter >> selectedEntry [
	^ self subclassResponsibility
]

{ #category : #'initialize-actions' }
FDFileDialogPresenter >> toggleHiddenFiles [
	showHiddenFiles := showHiddenFiles not.
	self needRebuild: false.
	self buildWithSpec
]

{ #category : #public }
FDFileDialogPresenter >> whenSelected: aOneArgBlock [
	onConfirmBlock := aOneArgBlock
]
