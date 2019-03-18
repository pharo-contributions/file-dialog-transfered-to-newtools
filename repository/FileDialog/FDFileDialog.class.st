"
I am an abstract base class for different styles of opening/saving.

Don't use me directly -- instead use one of my children.

## Examples

see class-side

## Website

https://github.com/peteruhnak/file-dialog
"
Class {
	#name : #FDFileDialog,
	#superclass : #ComposablePresenter,
	#instVars : [
		'bookmarksList',
		'createFolderButton',
		'nameText',
		'filesList',
		'currentDirectory',
		'nameLabel',
		'cancelButton',
		'confirmButton',
		'onConfirmBlock',
		'showHiddenFiles',
		'filter',
		'filtersDropList',
		'fileFilters',
		'currentFolderLabel'
	],
	#classVars : [
		'CustomBookmarks'
	],
	#category : #FileDialog
}

{ #category : #adding }
FDFileDialog class >> addBookmark: aFolder [
	self customBookmarks detect: [ :each | each location = aFolder ] ifFound: [ ^ self ].
	self customBookmarks
		add: (FDBookmark name: aFolder basename location: aFolder icon: (self iconNamed: #open))
]

{ #category : #icons }
FDFileDialog class >> allIcons [
	<script: 'self allIcons inspect'>
	^ (Pragma allNamed: 'icons' in: FDFileDialog class)
		flatCollect:
			[ :pragma | pragma methodClass instanceSide perform: pragma methodSelector ]
]

{ #category : #icons }
FDFileDialog class >> basicIcons [
"	<icons>
	^ {#zip -> ''}"
]

{ #category : #adding }
FDFileDialog class >> convertBookmarks: aDictionary [
	"convert bookmarks from old OrderedDictionary of location->#(name icon) to FDBookmark instances"

	^ aDictionary associations asOrderedCollection
		collect: [ :pair | FDBookmark name: pair value first location: pair key icon: pair value second ]
]

{ #category : #adding }
FDFileDialog class >> customBookmarks [
	CustomBookmarks isDictionary
		ifTrue: [ CustomBookmarks := self convertBookmarks: CustomBookmarks ].
	^ CustomBookmarks ifNil: [ CustomBookmarks := OrderedCollection new ]
]

{ #category : #adding }
FDFileDialog class >> customBookmarks: aCollection [
	self assert: [ aCollection isKindOf: OrderedCollection ].
	self assert: [ aCollection allSatisfy: [ :each | each isKindOf: FDBookmark ] ].
	CustomBookmarks := aCollection
]

{ #category : #specs }
FDFileDialog class >> defaultSpec [
	^ SpecColumnLayout composed
		newRow: [ :r | 
			r
				newColumn: [ :c | c add: #bookmarksList ] width: 150;
				newColumn: [ :c | 
					c add: #currentFolderLabel height: self toolbarHeight.
					c add: #filesList ] ];
		newRow: [ :r | 
			r
				add: #nameLabel width: 50;
				add: #nameText;
				add: #filtersDropList width: 200 ]
			height: self toolbarHeight;
		newRow: [ :r | 
			r newColumn: [ :c |  ].
			self dialogButtonsLayout: r ]
			height: self toolbarHeight;
		yourself
]

{ #category : #specs }
FDFileDialog class >> dialogButtonsLayout: aRow [
	^ OSPlatform current isWindows
		ifTrue: [ aRow
						add: #confirmButton width: 60;
						add: #cancelButton width: 60 ]
		ifFalse: [ aRow
						add: #cancelButton width: 60;
						add: #confirmButton width: 60 ]
]

{ #category : #example }
FDFileDialog class >> example [
	^ FDOpenFileDialog new
		whenSelected: [ :file | file inspect ];
		extensionFilters:
			{'All Images' -> #(jpg png gif svg).
			'All Files' -> #()};
		defaultFolder: FileLocator imageDirectory asFileReference;
		defaultName: 'hello.png';
		open
]

{ #category : #example }
FDFileDialog class >> exampleModal [
	"modal returns the selected value"

	(FDOpenDirectoryDialog new
		defaultFolder: FileLocator imageDirectory asFileReference;
		openModal) inspect
]

{ #category : #'filtering - convenience' }
FDFileDialog class >> filterAllFiles [
	^ {'All Files' -> #()}
]

{ #category : #'filtering - convenience' }
FDFileDialog class >> filterAllImages [
	^ {'All Images' -> #(jpg png gif svg)}
]

{ #category : #example }
FDFileDialog class >> forImages [
	^ self new
		extensionFilters:
			{'All Images' -> #(jpg png gif svg).
			'All Files' -> #()}
]

{ #category : #icons }
FDFileDialog class >> imageIcons [
	<icons>
	^ {(#png -> (self iconNamed: #komitter)).
		(#jpg -> (self iconNamed: #komitter)).
		(#gif -> (self iconNamed: #komitter)).
		(#svg -> (self iconNamed: #komitter))}
]

{ #category : #adding }
FDFileDialog class >> removeBookmark: aFolder [
	self customBookmarks removeAllSuchThat: [ :each | each location = aFolder ]
]

{ #category : #icons }
FDFileDialog class >> textIcons [
	<icons>
	^ {(#st -> (self iconNamed: #smallLeftFlush)).
		(#txt -> (self iconNamed: #smallLeftFlush))}
]

{ #category : #bookmarks }
FDFileDialog >> addBookmark: aFolder [
	self class addBookmark: aFolder.
	self refreshBookmarks
]

{ #category : #bookmarks }
FDFileDialog >> bookmarks [
	^ self defaultBookmarks , self customBookmarks
]

{ #category : #'accessing - spec fields' }
FDFileDialog >> bookmarksList [
	^ bookmarksList
]

{ #category : #'accessing - spec fields' }
FDFileDialog >> cancelButton [
	^ cancelButton
]

{ #category : #utility }
FDFileDialog >> canonicalize: aFileReference [
	^ (aFileReference respondsTo: #canonicalize)
		ifTrue: [ ">= P7" aFileReference canonicalize ]
		ifFalse: [ "<= P6" aFileReference pathString asFileReference ]
]

{ #category : #actions }
FDFileDialog >> confirm [
	self selectedEntry
		ifNotNil: [ :entry | 
			onConfirmBlock value: entry.
			self delete ]
]

{ #category : #'accessing - spec fields' }
FDFileDialog >> confirmButton [
	^ confirmButton
]

{ #category : #actions }
FDFileDialog >> createDirectory [
	^ self createDirectory: 'new-folder'
]

{ #category : #actions }
FDFileDialog >> createDirectory: initialName [
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
FDFileDialog >> createFolderButton [
	^ createFolderButton
]

{ #category : #accessing }
FDFileDialog >> currentDirectory [
	^ currentDirectory ifNil: [ currentDirectory := self defaultFolder ]
]

{ #category : #accessing }
FDFileDialog >> currentFiles [
	^ ((self isRootDirectory: currentDirectory)
		ifTrue: [ {} ]
		ifFalse: [ {self currentDirectory / '..'} ]) , self currentDirectory children
]

{ #category : #'accessing - spec fields' }
FDFileDialog >> currentFolderLabel [
	^ currentFolderLabel
]

{ #category : #utility }
FDFileDialog >> currentFolderTitleFor: aString [
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
FDFileDialog >> customBookmarks [
	^ self class customBookmarks
]

{ #category : #bookmarks }
FDFileDialog >> defaultBookmarks [
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
FDFileDialog >> defaultFolder [
	^ FileLocator imageDirectory asFileReference
]

{ #category : #public }
FDFileDialog >> defaultFolder: aPath [
	(aPath isNotNil and: [ aPath asFileReference exists ])
		ifTrue: [ self openFolder: aPath asFileReference ]
		ifFalse: [ self openFolder: self defaultFolder ]
]

{ #category : #public }
FDFileDialog >> defaultName: aString [
	nameText text: aString
]

{ #category : #accessing }
FDFileDialog >> delimiter [
	^ FileSystem disk delimiter asString
]

{ #category : #public }
FDFileDialog >> extensionFilters: anArray [
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
FDFileDialog >> fileFilters [
	^ fileFilters ifNil: [ fileFilters := self class filterAllFiles ]
]

{ #category : #public }
FDFileDialog >> fileFilters: anArray [
	anArray ifEmpty: [ ^ self ].
	anArray anyOne isString
		ifTrue: [ fileFilters := {(anArray joinUsing: ', ') -> anArray} ]
		ifFalse: [ fileFilters := anArray ].
	filtersDropList items: fileFilters
]

{ #category : #accessing }
FDFileDialog >> filesFilteringBlock [
	^ [ :entries | 
	| e |
	e := entries.
	showHiddenFiles
		ifFalse: [ e := filter noHiddenFiles: entries ].
	filtersDropList selectedItem value
		ifNotEmpty: [ :patterns | e := filter files: e matching: patterns ].
	e ]
]

{ #category : #'accessing - spec fields' }
FDFileDialog >> filesList [
	^ filesList
]

{ #category : #public }
FDFileDialog >> filteredExtensions: anArray [
	self deprecated: 'Use extensionFilters: instead'.
	self extensionFilters: anArray
]

{ #category : #'accessing - spec fields' }
FDFileDialog >> filtersDropList [
	^ filtersDropList
]

{ #category : #accessing }
FDFileDialog >> iconFor: anEntry [
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
FDFileDialog >> icons [
	^ Smalltalk ui icons
]

{ #category : #api }
FDFileDialog >> initialExtent [
	^ 550 @ 550
]

{ #category : #api }
FDFileDialog >> initialTitle [
	^ self subclassResponsibility
]

{ #category : #initialization }
FDFileDialog >> initialize [
	showHiddenFiles := false.
	onConfirmBlock := [ :selection |  ].
	filter := FDFileFilter new.
	super initialize.
	self defaultFolder: self defaultFolder
]

{ #category : #initialization }
FDFileDialog >> initializeBookmarksList [
	| nonRemovableBookmarks |
	nonRemovableBookmarks := self defaultBookmarks.
	bookmarksList items: self bookmarks.
	bookmarksList autoDeselect: false.
	bookmarksList displayBlock: [ :each | each name ].
	bookmarksList icons: [ :each | each icon ].
	self selectBookmarkFor: self currentDirectory.
	bookmarksList
		whenSelectedItemChanged: [ :bookmark | bookmark ifNotNil: [ self openFolder: bookmark location ] ].
	bookmarksList
		menu: [ :aMenu :shifterd | 
			bookmarksList selectedItem
				ifNotNil: [ :bookmark | 
					(nonRemovableBookmarks includes: bookmark)
						ifFalse: [ aMenu
								add: 'Remove bookmark'
								target: self
								selector: #removeBookmark:
								argument: bookmark ].
					aMenu ] ]
]

{ #category : #initialization }
FDFileDialog >> initializeDragAndDrop [
	filesList dragEnabled: true.
	bookmarksList
		dropEnabled: true;
		wantDropBlock: [ :item :event :source | 
			item isTransferable
				and: [ item source = filesList
						and: [ item passenger first originalObject isDirectory
								and: [ (item passenger first originalObject basename = '..') not ] ] ] ];
		acceptDropBlock: [ :transfer :event :source :receiver | self addBookmark: transfer passenger first originalObject ]
]

{ #category : #initialization }
FDFileDialog >> initializeFilesList [
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
]

{ #category : #initialization }
FDFileDialog >> initializeFiltersDropList [
	filtersDropList
		items: self fileFilters;
		displayBlock: [ :item | item key ];
		whenSelectedItemChanged: [ :item | filesList refreshListItems ];
		setSelectedIndex: 1
]

{ #category : #initialization }
FDFileDialog >> initializePresenter [
	self initializeBookmarksList.
	self initializeFilesList.
	self initializeFiltersDropList.
	self initializeDragAndDrop.
	cancelButton action: [ self delete ].
	confirmButton action: [ self confirm ].
	nameText whenTextChanged: [ self nameChanged ]
]

{ #category : #initialization }
FDFileDialog >> initializeWidgets [
	bookmarksList := self instantiate: IconListModel.
	(currentFolderLabel := self newLabel)
		color: Smalltalk ui theme textColor.
	filesList := self instantiate: IconListModel.
	createFolderButton := self newButton.
	(nameLabel := self newLabel) label: 'Name:'.
	(nameText := self newTextInput) autoAccept: true.
	(cancelButton := self newButton) label: 'Cancel'.
	(confirmButton := self newButton)
		label: 'Confirm';
		disable.
	filtersDropList := self newDropList.
	self title: self initialTitle.
	self focusOrder
		add: nameText;
		add: filtersDropList;
		add: cancelButton;
		add: confirmButton
]

{ #category : #accessing }
FDFileDialog >> isRootDirectory: aDirectory [
	^ aDirectory isRoot or: [ OSPlatform current isWindows and: [ aDirectory parent isRoot ] ]
]

{ #category : #actions }
FDFileDialog >> nameChanged [
	confirmButton enabled: nameText text isNotEmpty
]

{ #category : #'accessing - spec fields' }
FDFileDialog >> nameLabel [
	^ nameLabel
]

{ #category : #'accessing - spec fields' }
FDFileDialog >> nameText [
	^ nameText
]

{ #category : #'instance creation' }
FDFileDialog >> open [
	^ self openWithSpec
]

{ #category : #actions }
FDFileDialog >> openFolder: aFolder [
	currentDirectory := self canonicalize: aFolder.
	currentFolderLabel
		label: (self currentFolderTitleFor: currentDirectory pathString);
		help: currentDirectory pathString , self delimiter.
	filesList items: self currentFiles.
	filesList resetSelection.
	self selectBookmarkFor: currentDirectory
]

{ #category : #'instance creation' }
FDFileDialog >> openModal [
	| result |
	self whenSelected: [ :file | result := file ].
	self openWithSpec modalRelativeTo: self currentWorld.
	^ result
]

{ #category : #bookmarks }
FDFileDialog >> refreshBookmarks [
	bookmarksList items: self bookmarks
]

{ #category : #bookmarks }
FDFileDialog >> removeBookmark: aBookmark [
	self class removeBookmark: aBookmark location.
	self refreshBookmarks
]

{ #category : #utility }
FDFileDialog >> selectBookmarkFor: aDirectory [
	"bookmarksList' ListModel uses identity based comparison, so I need to select index instead"
	
	"is there withIndexDetect: ?"
	bookmarksList setSelectedIndex: ((self bookmarks collect: #location) indexOf: aDirectory)
]

{ #category : #actions }
FDFileDialog >> selectFile: aFile [
	filesList selectedItem = aFile
		ifFalse: [ filesList setSelectedIndex: (filesList listItems indexOf: aFile) ].
	nameText text: aFile basename
]

{ #category : #accessing }
FDFileDialog >> selectedEntry [
	^ self subclassResponsibility
]

{ #category : #actions }
FDFileDialog >> toggleHiddenFiles [
	showHiddenFiles := showHiddenFiles not.
	filesList items: self currentFiles
]

{ #category : #public }
FDFileDialog >> whenSelected: aOneArgBlock [
	onConfirmBlock := aOneArgBlock
]
