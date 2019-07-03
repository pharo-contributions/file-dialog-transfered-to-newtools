"
I am an abstract base class for different styles of opening/saving.

## author 

main Author : peteruhnak
Migrator Spec 1 to Spec 2 : CafeKrem (github pseudo)
if you have question please send me a mail : dutriezcle@gmail.com

## Examples

see class-side

## Website

https://github.com/peteruhnak/file-dialog

## HOW TO RUN 

FDOpenFileDialog open
open is define in FDFileDialogPresenter class side 
Don't use me directly -- instead use one of my children.

## CUSTOMIZATION 

I define some method to customize your son of FileDialogPresenter

whenSelected: aBlock 
	this method is use to define the action of the accept button
		
filtersCustomization: aCollection 
	this method is use to define a set of Filter (choose one or more among FDAbstractFilter son)
	THERE IS ALWAYS THE DEFAULT FILTER (this filter filterNothing)
	
fillCustomBookmarksWith: aCollectionOfFDBookmark
	this method is use to define a collection of bookmark for the variable 'customBookMarks'
	
defaultFolder: aPath
	this method will open tou fileDialog on a aPath , this path must exist and be a directory
	
	

"
Class {
	#name : #FDFileDialogPresenter,
	#superclass : #SpPresenter,
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
		'bookmarksTreeTable',
		'previewContentPresenter',
		'previewer',
		'currentPathTextInputPresenter'
	],
	#classVars : [
		'CustomBookmarks',
		'Directory',
		'FilterSet',
		'FixedBookMark',
		'OkActionBlock',
		'Previewer'
	],
	#category : #FileDialog
}

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

{ #category : #defaultClassVariable }
FDFileDialogPresenter class >> defaultCustomBookmarks [
	^ {} asOrderedCollection
]

{ #category : #defaultClassVariable }
FDFileDialogPresenter class >> defaultDirectory [
	^ FileLocator imageDirectory asFileReference
]

{ #category : #defaultClassVariable }
FDFileDialogPresenter class >> defaultFilterSet [
	^ FDAbstractFilter actions
]

{ #category : #defaultClassVariable }
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

{ #category : #defaultClassVariable }
FDFileDialogPresenter class >> defaultOkActionBlock [
	^ [ :fileReference | self inform: 'you select the file' , fileReference basename ]
]

{ #category : #defaultClassVariable }
FDFileDialogPresenter class >> defaultPreviewer [
	^ nil
]

{ #category : #specs }
FDFileDialogPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add:
			(SpBoxLayout newHorizontal
				add: #bookmarksTreeTable
					withConstraints: [ :contraint | contraint width: 200 ];
			add:
					(SpBoxLayout newVertical
						add: #currentPathTextInputPresenter
							withConstraints: [ :contraint | contraint height: self toolbarHeight ];
						add: #filesList;
						yourself);
				yourself);
		add:
			(SpBoxLayout newHorizontal 
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
	^ FDOpenFileDialog open extent: 600@500 ; inspect ; yourself
]

{ #category : #example }
FDFileDialogPresenter class >> exampleModal [
	"modal returns the selected value"

	OkActionBlock := [ :fileRefence | fileRefence inspect ].
	^ (FDOpenDirectoryDialog new
		defaultFolder: FileLocator imageDirectory asFileReference;
		openDialogWithSpec) inspect
]

{ #category : #'class initialization' }
FDFileDialogPresenter class >> initialize [
	OkActionBlock := self defaultOkActionBlock.
	Directory := self defaultDirectory.
	FixedBookMark := self defaultFixedBookmarks.
	CustomBookmarks := self defaultCustomBookmarks.
	FilterSet := self defaultFilterSet.
	Previewer := self defaultPreviewer
]

{ #category : #specs }
FDFileDialogPresenter class >> layoutPreviewer [
	^ SpBoxLayout newHorizontal
		add:
			(SpBoxLayout newVertical
				add:
					(SpBoxLayout newHorizontal
						add: #bookmarksTreeTable
							withConstraints: [ :contraint | contraint width: 200 ];
						add:
							(SpBoxLayout newVertical
								add: #currentPathTextInputPresenter
									withConstraints: [ :contraint | contraint height: self toolbarHeight ];
								add: #filesList;
								yourself);
						yourself);
				add:
					(SpBoxLayout newHorizontal
						add: #nameLabel
							withConstraints: [ :contraint | contraint width: 50 ];
						add: #nameText;
						add: #filtersDropList
							withConstraints: [ :contraint | contraint width: 200 ];
						yourself)
					withConstraints: [ :contraint | contraint height: self toolbarHeight ] yourself)withConstraints:  [:contraint |contraint height: 150  ];
		add:  #previewContentPresenter withConstraints:  [:contraint |contraint height: 30 ] ;
		yourself
]

{ #category : #'instance creation' }
FDFileDialogPresenter class >> open [
	^ self new
		openDialogWithSpec;
		yourself
]

{ #category : #'as yet unclassified' }
FDFileDialogPresenter class >> previewExample [
	<example>
	| presenter |
	presenter := FDOpenFileDialog new.
	presenter previewer: FDPNGPreviewer new.
	presenter openDialogWithSpec.
	presenter inspect.
	^ presenter
]

{ #category : #actions }
FDFileDialogPresenter >> addBookmark: aFolder [
	| bookmark |
	bookmark := self creatAnFDBookMark: aFolder.
	(customBookMarks collection includes: bookmark)
		ifTrue: [ ^ self inform: 'you already have this bookmark' ].
	customBookMarks collection add: bookmark.
	bookmarksTreeTable roots: self upadateBookmarksTreeTable
]

{ #category : #accessing }
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

{ #category : #utility }
FDFileDialogPresenter >> confirm [
	nameText text isNotEmpty
		ifFalse: [ ^ self inform: 'you have to select a file' ].
	self selectedEntry
		ifNotNil: [ :entry | 
			okActionBlock value: entry.
			self delete ]
]

{ #category : #utility }
FDFileDialogPresenter >> creatAnFDBookMark: aDirectory [
	^ FDBookmark
		name: aDirectory basename
		location: aDirectory path
		icon: nil
]

{ #category : #utility }
FDFileDialogPresenter >> createDirectory [
	^ self createDirectory: 'new-folder'
]

{ #category : #utility }
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

{ #category : #utility }
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

{ #category : #'initialize-actions' }
FDFileDialogPresenter >> currentPathTextInputAction [
	currentPathTextInputPresenter
		whenTextIsAcceptedDo: [ :text | 
			text asFileReference exists
				ifFalse: [ self
						inform: 'you have to write an absolute path and an existing one' ]
				ifTrue: [ self openFolder: text asFileReference ] ]
]

{ #category : #accessing }
FDFileDialogPresenter >> currentPathTextInputPresenter [
	^ currentPathTextInputPresenter
]

{ #category : #accessing }
FDFileDialogPresenter >> customBookmarks [
	^ customBookMarks
]

{ #category : #utility }
FDFileDialogPresenter >> defaultFolder [
	^ FileLocator imageDirectory asFileReference
]

{ #category : #'api-customization' }
FDFileDialogPresenter >> defaultFolder: aPath [
	(aPath isNotNil and: [ aPath asFileReference exists ])
		ifTrue: [ self openFolder: aPath asFileReference ]
		ifFalse: [ self openFolder: self defaultFolder ]
]

{ #category : #utility }
FDFileDialogPresenter >> delimiter [
	^ FileSystem disk delimiter asString
]

{ #category : #TOREMOVE }
FDFileDialogPresenter >> fileFilters: anArray [
	self flag: 'to remove when migrate FDMorphicUIManager'.
	anArray ifEmpty: [ ^ self ].
	anArray anyOne isString
		ifTrue: [ fileFilters := {(anArray joinUsing: ', ') -> anArray} ]
		ifFalse: [ fileFilters := anArray ].
	filtersDropList items: fileFilters
]

{ #category : #accessing }
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
				ifTrue: [ self openFolder: selectedItem selectedItem ] ].
	filesList
		whenSelectionChangedDo: [ :selectedFileReference | 
			previewer
				ifNotNil: [ (previewer canBeUsedOn: selectedFileReference selectedItem)
						ifTrue: [ previewContentPresenter := previewer
								previewOn: selectedFileReference selectedItem.
							self window rebuildWithSpecLayout: self class layoutPreviewer.
							self window extent: 800@800 ]
						ifFalse: [ previewContentPresenter := nil.
							self window rebuildWithSpecLayout: self class defaultSpec.
							self window extent: 800@800 ] ] ]
]

{ #category : #'api-customization' }
FDFileDialogPresenter >> fillCustomBookmarksWith: aCollectionOFBookmark [
	"you have to give me aCollection of FDBookmark"

	customBookMarks collection: aCollectionOFBookmark.
	bookmarksTreeTable roots: self upadateBookmarksTreeTable
]

{ #category : #utility }
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

{ #category : #'api-customization' }
FDFileDialogPresenter >> filtersCustomization: aCollectionOfFilter [
	"i always add the filter 'no filter'"

	filtersDropList
		items:
			(aCollectionOfFilter asOrderedCollection
				add: FDDefaultFilter new;
				yourself) asSet asOrderedCollection.
	filtersDropList
		selectedIndex:
			((filtersDropList listItems collect: #name)
				indexOf: FDDefaultFilter new name)
]

{ #category : #accessing }
FDFileDialogPresenter >> filtersDropList [
	^ filtersDropList
]

{ #category : #accessing }
FDFileDialogPresenter >> fixedBookmarks [
	^ fixedBookMarks
]

{ #category : #utility }
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

{ #category : #'initialize-value' }
FDFileDialogPresenter >> initialExtent [
	^ 700 @ 700
]

{ #category : #'initialize-value' }
FDFileDialogPresenter >> initialTitle [
	^ self subclassResponsibility
]

{ #category : #initialization }
FDFileDialogPresenter >> initialize [
	self flag: 'add customozation on hiddenFilter'.
	super initialize.
	showHiddenFiles := false.
	okActionBlock := OkActionBlock.
	hiddenFilter := FDHidenFileFilter new.
	previewer := Previewer.
	previewContentPresenter := nil
	
]

{ #category : #'initialize-widgets' }
FDFileDialogPresenter >> initializeBookmarksTreeTable [
	bookmarksTreeTable
		addColumn:
			((SpImageTableColumn evaluated: [ :each | each icon ])
				width: 50;
				yourself);
		addColumn:
			(SpStringTableColumn
				evaluated: [ :fdGroupBookMark | fdGroupBookMark name ]).
	bookmarksTreeTable
		roots: self upadateBookmarksTreeTable;
		children: [ :child | 
			child isComposite
				ifTrue: [ child collection ]
				ifFalse: [ {} ] ].
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
	| filterItems |
	filterItems := FilterSet copy.
	filterItems asOrderedCollection  add: FDDefaultFilter new.
	filterItems := filterItems asSet.
	filtersDropList
		items:  filterItems asOrderedCollection ;
		displayBlock: [ :item | item name ];
		selectedIndex:
			((filtersDropList listItems collect: #name)
				indexOf: FDDefaultFilter new name)
]

{ #category : #'initialize-value' }
FDFileDialogPresenter >> initializeGroupBookmark [
	fixedBookMarks := FDGroupBookMark
		CreatWithname: 'fixeBookMark'
		WithContent: FixedBookMark copy
		withIconName: ''.
	customBookMarks := FDGroupBookMark
		CreatWithname: 'customBookMark'
		WithContent: CustomBookmarks copy
		withIconName: ''
]

{ #category : #initialization }
FDFileDialogPresenter >> initializePresenter [
	self bookmarksTreeTableAction.
	self filesListAction.
	filtersDropList
		transmitTo: filesList
		transform:
			[ :filterBis | filesListContent select: [ :item | filterBis filter: item ] ].
	self currentPathTextInputAction
]

{ #category : #initialization }
FDFileDialogPresenter >> initializeWidgets [
	self initializeGroupBookmark.
	currentDirectory := Directory copy.
	bookmarksTreeTable := self newTreeTable.
	filesList := self newList.
	currentPathTextInputPresenter := self newTextInput.
	(nameLabel := self newLabel) label: 'Name:'.
	(nameText := self newTextInput) autoAccept: true.
	filtersDropList := self newDropList.
	currentPathTextInputPresenter text: currentDirectory fullName.
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

{ #category : #accessing }
FDFileDialogPresenter >> nameLabel [
	^ nameLabel
]

{ #category : #accessing }
FDFileDialogPresenter >> nameText [
	^ nameText
]

{ #category : #actions }
FDFileDialogPresenter >> openFolder: aFolder [
	currentDirectory := self canonicalize: aFolder.
	currentPathTextInputPresenter text: currentDirectory fullName.
	filesList items: (self filterACollection: self currentFiles).
	filesListContent := filesList items.
	filesList unselectAll
]

{ #category : #accessing }
FDFileDialogPresenter >> previewContentPresenter [
	^ previewContentPresenter
]

{ #category : #accessing }
FDFileDialogPresenter >> previewContentPresenter: anObject [
	previewContentPresenter := anObject
]

{ #category : #accessing }
FDFileDialogPresenter >> previewer [
	^ previewer
]

{ #category : #'api-customization' }
FDFileDialogPresenter >> previewer: anObject [
	previewer := anObject
]

{ #category : #actions }
FDFileDialogPresenter >> removeBookmark: aBookmark [
	customBookMarks collection remove: aBookmark.
	bookmarksTreeTable roots: self upadateBookmarksTreeTable
]

{ #category : #utility }
FDFileDialogPresenter >> selectBookmarkFor: aDirectory [
	"bookmarksList' ListModel uses identity based comparison, so I need to select index instead"

	"is there withIndexDetect: ?"

	bookmarksTreeTable
		selectIndex: ((self unionBookmarks collect: #location) indexOf: aDirectory)
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

{ #category : #utility }
FDFileDialogPresenter >> unionBookmarks [
	^ fixedBookMarks , customBookMarks
]

{ #category : #utility }
FDFileDialogPresenter >> upadateBookmarksTreeTable [
	self flag: #renameIt.
	^ {fixedBookMarks.
	customBookMarks}
]

{ #category : #'api-customization' }
FDFileDialogPresenter >> whenSelected: aOneArgBlock [
	okActionBlock := aOneArgBlock
]
