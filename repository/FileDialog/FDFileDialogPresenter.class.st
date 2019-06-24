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

		'nameText',
		'filesList',
		'currentDirectory',
		'nameLabel',

		'showHiddenFiles',
		'filter',
		'filtersDropList',
		'fileFilters',
		'currentFolderLabel',
		'filesListContent',

		'hiddenFilter',
		'okActionBlock',
		'fixedBookMarks',
		'customBookMarks',
		'bookmarksTreeTable'
	],
	#classVars : [
		'CustomBookmarks',
		'Directory',
		'FixedBookMark',
		'OkActionBlock'
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
				register: (FDAddBookMarkCommand forSpec context: presenter);

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
	self assert: [ aCollection allSatisfy: [ :each | each isKindOf: FDAbstractBookMark ] ].
	CustomBookmarks := aCollection
]

{ #category : #bookmarks }
FDFileDialogPresenter class >> defaultFixedBookmarks [
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

{ #category : #specs }
FDFileDialogPresenter class >> defaultSpec [
	^ SpecBoxLayout newVertical
		add:
			(SpecBoxLayout newHorizontal
				add: #bookmarksTreeTable
					withConstraints: [ :contraint | contraint width: 200 ];
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
	^ FDOpenFileDialog open extent: 600@500 ; yourself
]

{ #category : #example }
FDFileDialogPresenter class >> exampleModal [
	"modal returns the selected value"

	OkActionBlock := [ :fileRefence | fileRefence inspect ].
	^ (FDOpenDirectoryDialog new
		defaultFolder: FileLocator imageDirectory asFileReference;
		openDialogWithSpec) inspect
]

{ #category : #'instance creation' }
FDFileDialogPresenter class >> open [
	OkActionBlock := [:fileReference |self inform: 'you select the file' ,  fileReference basename   ].
	Directory := FileLocator imageDirectory asFileReference.
	FixedBookMark := self defaultFixedBookmarks.
	CustomBookmarks := {} asOrderedCollection .
	^ self new openDialogWithSpec
]

{ #category : #'instance creation' }
FDFileDialogPresenter class >> openOn: aCollectionOfFDBookMark [
	self flag: #customize 
]

{ #category : #'instance creation' }
FDFileDialogPresenter class >> openOn: aDirectory WithAcceptAction: acceptBlock WithThisBookMark: aCollectionOfFileReference [
	self flag: #customize.
	OkActionBlock := acceptBlock.
	Directory := aDirectory.
	CustomBookmarks := aCollectionOfFileReference.
	^ self new
		openDialogWithSpec;
		yourself
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
	^ fixedBookMarks , self customBookmarks
]

{ #category : #'accessing - spec fields' }
FDFileDialogPresenter >> bookmarksTreeTable [
	^ bookmarksTreeTable
]

{ #category : #'initialize-actions' }
FDFileDialogPresenter >> bookmarksTreeTableAction [
	bookmarksTreeTable
		whenSelectionChangedDo: [ :selection | 
			selection selectedItem
				ifNotNil: [ :selectedItem | 
					selectedItem isComposite
						ifFalse: [ self openFolder: selectedItem location ] ] ]

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
			okActionBlock value: entry.
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

{ #category : #accessing }
FDFileDialogPresenter >> currentDirectory [
	^ currentDirectory ifNil: [ currentDirectory := self defaultFolder ]
]

{ #category : #accessing }
FDFileDialogPresenter >> currentDirectory: anObject [
	currentDirectory := anObject
]

{ #category : #accessing }
FDFileDialogPresenter >> currentFiles [
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
	^ customBookMarks
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

{ #category : #accessing }
FDFileDialogPresenter >> delimiter [
	^ FileSystem disk delimiter asString
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

		whenSelectionChangedDo: [ :selectedFileReference | 
			nameText
				text:
					(selectedFileReference selectedItem
						ifNotNil: [ selectedFileReference selectedItem basename ]
						ifNil: [ 'noFileSelected' ]) ].
	filesList
		whenActivatedDo: [ :selectedItem | 
			selectedItem selectedItem isDirectory
				ifTrue: [ self openFolder: selectedItem selectedItem ] ]
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
	^ collection]

{ #category : #'accessing - spec fields' }
FDFileDialogPresenter >> filtersDropList [
	^ filtersDropList
]

{ #category : #accessing }
FDFileDialogPresenter >> iconFor: anEntry [
	| ext |
	anEntry isDirectory
		ifTrue: [ ^ self iconNamed: #open ].
	ext := anEntry extension.
	^ self class allIcons asDictionary
		at: ext
		ifPresent: [ :icon | icon ]
		ifAbsent: [ self iconNamed: #page ]
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
	super initialize.
	showHiddenFiles := false.
	okActionBlock := OkActionBlock.
	hiddenFilter := FDHidenFileFilter new.
	"self defaultFolder: Directory"
]

{ #category : #'initialize-widgets' }
FDFileDialogPresenter >> initializeBookmarksTreeTable [
	bookmarksTreeTable
		addColumn:
			((ImageTableColumn evaluated: [ :each | each icon ])
				width: 50;
				yourself);
		addColumn:
			(StringTableColumn
				evaluated: [ :fdGroupBookMark | fdGroupBookMark name ]).
	bookmarksTreeTable
		roots: self upadateBookmarksTreeTable;
		children: [ :child | 
			child isComposite
				ifTrue: [ child collection ]
				ifFalse: [ {} ] ].
	"self selectBookmarkFor: self currentDirectory."
	bookmarksTreeTable
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
	self bookmarksTreeTableAction.
	self filesListAction.
	filtersDropList
		transmitTo: filesList
		transform:
			[ :filterBis | filesListContent select: [ :item | filterBis filter: item ] ].
]

{ #category : #initialization }
FDFileDialogPresenter >> initializeWidgets [
	fixedBookMarks := FDGroupBookMark
		CreatWithname: 'fixeBookMark'
		WithContent: FixedBookMark copy
		withIconName: ''.
	customBookMarks := FDGroupBookMark
		CreatWithname: 'customBookMark'
		WithContent: CustomBookmarks copy
		withIconName: ''.
	currentDirectory := Directory.
	bookmarksTreeTable := self newTreeTable.
	currentFolderLabel := self newLabel.
	filesList := self newList.
	(nameLabel := self newLabel) label: 'Name:'.
	(nameText := self newTextInput) autoAccept: true.
	filtersDropList := self newDropList.
	self initializeBookmarksTreeTable.
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
	^ fixedBookMarks
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
	"self selectBookmarkFor: currentDirectory"
]

{ #category : #'instance creation' }
FDFileDialogPresenter >> openModal [
	| result |
	self flag: #toRemove.
	self whenSelected: [ :file | result := file ].
	self openWithSpec modalRelativeTo: self currentWorld.
	^ result
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

	bookmarksTreeTable
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
	^ bookmarksTreeTable selection selectedItem
]

{ #category : #accessing }
FDFileDialogPresenter >> selectedEntry [
	^ self subclassResponsibility
]

{ #category : #accessing }
FDFileDialogPresenter >> showHiddenFiles [
	^ showHiddenFiles
]

{ #category : #'initialize-actions' }
FDFileDialogPresenter >> toggleHiddenFiles [
	showHiddenFiles := showHiddenFiles not.
	filesList items: (self filterACollection: self currentFiles) 
]

{ #category : #'initialize-widgets' }
FDFileDialogPresenter >> upadateBookmarksTreeTable [
	^ {fixedBookMarks.
	customBookMarks}
]

{ #category : #public }
FDFileDialogPresenter >> whenSelected: aOneArgBlock [
	okActionBlock := aOneArgBlock
]
