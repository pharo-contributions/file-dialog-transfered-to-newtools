"
I am an abstract base class for different styles of opening/saving.




## author 

main Author : peteruhnak
Migrator Spec 1 to Spec 2 : CafeKrem (github pseudo)
if you have question please send me a mail : dutriezcle@gmail.com

## Examples

|------------------------------------------|
				look at this method 
|---> FDFileDialogPresenter fullExample <--|
|------------------------------------------|

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
	this method is use to define a set of Filter (choose one or more among FDAbstractPredicate son or creat a new  predicate)
	THERE IS ALWAYS THE DEFAULT FILTER (this filter filterNothing)
	example: 
		
		(FDOpenFileDialog new filtersCustomization: { FDJPGAndPNGPredicate new }) openDialogWithSpec
		
bookmarks: aCollection Of FDAbstractBookMark
	this method will set bookmarks use the class FDAbstractBookMark
		you can create group with FDGroupBookMark or use FDBookMark to create bookmark
		example : 
		
			class side method defaultBookmarks
	  
defaultFolder: aPath
	this method will open tou fileDialog on a aPath , this path must exist and be a directory
	example
		
		(FDOpenFileDialog new defaultFolder: '/home/cdutriez/' asFileReference) openDialogWithSpec 
	
icons
-----
	if you want to add icons you just have to create a method with pragma <icons> and this method have to return an array of association 
	example:
		
		see FDFileDialogPresenter textIcons method 

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
		'filtersDropList',
		'filesListContent',
		'hiddenFilter',
		'okActionBlock',
		'bookmarksTreeTable',
		'previewContentPresenter',
		'previewer',
		'currentPathTextInputPresenter',
		'lastDirectoryVisitBeforeButton',
		'lastDirectoryVisitAfterButton',
		'readPointerHistoryParcour',
		'bookmarks'
	],
	#classVars : [
		'Bookmarks',
		'CustomBookmarks',
		'Directory',
		'FilterSet',
		'FixedBookMark',
		'OkActionBlock',
		'Previewer'
	],
	#category : #'FileDialog-UI'
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
				yourself)
]

{ #category : #defaultClassVariable }
FDFileDialogPresenter class >> defaultBookmarks [
	| presets |
	presets := OrderedCollection new.
	presets add: FDBookmark image.
	presets add: FDBookmark home.
	OSPlatform current isUnix
		ifTrue: [ presets add: FDBookmark root.
			presets add: FDBookmark tmp ].
	OSPlatform current isWindows
		ifTrue: [ presets addAll: FDBookmark windowsDrives ].
	^ {(FDGroupBookMark
		CreatWithname: 'fixed bookmarks'
		WithContent: presets
		withIconName: '')}
]

{ #category : #defaultClassVariable }
FDFileDialogPresenter class >> defaultDirectory [
	^ FileLocator imageDirectory asFileReference
]

{ #category : #defaultClassVariable }
FDFileDialogPresenter class >> defaultFilterSet [
	^ FDAbstractPredicate actions
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
			(SpPanedLayout newHorizontal
				position: 200;
				add: #bookmarksTreeTable;
				add:
					(SpBoxLayout newVertical
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
			withConstraints: [ :contraint | contraint height: self toolbarHeight ] yourself
]

{ #category : #'as yet unclassified' }
FDFileDialogPresenter class >> examplePreviewer [
	| presenter |
	presenter := FDOpenFileDialog new.
	presenter previewer: FDPNGPreviewer new.
	presenter openDialogWithSpec
]

{ #category : #example }
FDFileDialogPresenter class >> exampleSaveDialog [
	<example>
		^ FDSaveFileDialog new openDialogWithSpec 
]

{ #category : #example }
FDFileDialogPresenter class >> exampleSaveFileDialog [
	^ FDSaveFileDialog new openDialogWithSpec
]

{ #category : #example }
FDFileDialogPresenter class >> fullExample [
	<example>
	| presenter |
	presenter := FDOpenFileDialog new.
	presenter previewer: FDPNGPreviewer new. "with this when you select a png file it will display it"
	presenter filtersCustomization: { FDJPGAndPNGPredicate new }."with you add filter"
	presenter defaultFolder: FileLocator home asFileReference.
	presenter okActionBlock: [:selectedFileReference |selectedFileReference inspect  ]."you will define the action of the OK button"
	presenter bookmarks: { FDGroupBookMark CreatWithname: 'exampleGroup' WithContent:  { FDBookmark image . FDBookmark home }  withIconName:  'group'}.
	presenter openDialogWithSpec.
	presenter inspect.
	^ presenter
]

{ #category : #icons }
FDFileDialogPresenter class >> imageIcons [
	<icons>
	^ {(#png -> (self iconNamed: #komitter)).
	(#jpg -> (self iconNamed: #komitter)).
	(#gif -> (self iconNamed: #komitter)).
	(#svg -> (self iconNamed: #komitter))}
]

{ #category : #'class initialization' }
FDFileDialogPresenter class >> initialize [
	OkActionBlock := self defaultOkActionBlock.
	Directory := self defaultDirectory.
	FilterSet := self defaultFilterSet.
	Previewer := self defaultPreviewer.
	Bookmarks := self defaultBookmarks.
]

{ #category : #specs }
FDFileDialogPresenter class >> layoutPreviewer [
	^ SpPanedLayout newHorizontal
		add:
			(SpBoxLayout newVertical
				add:
					(SpPanedLayout newHorizontal
						position: 200;
						add: #bookmarksTreeTable;
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
					withConstraints: [ :contraint | contraint height: self toolbarHeight ];
				yourself);
		add: #previewContentPresenter;
		yourself
]

{ #category : #'instance creation' }
FDFileDialogPresenter class >> open [
	^ self new
		openDialogWithSpec;
		yourself
]

{ #category : #icons }
FDFileDialogPresenter class >> textIcons [
	<icons>
	^ {(#st -> (self iconNamed: #smallLeftFlush)).
	(#txt -> (self iconNamed: #smallLeftFlush))}
]

{ #category : #utility }
FDFileDialogPresenter >> ChangeDirectoryApplyToPresenter: aFolder [
	self flag: 'I have to rename it but I have no idea'.
	currentDirectory := aFolder canonicalize.
	currentPathTextInputPresenter text: currentDirectory fullName.
	filesList items: (self filterACollection: self currentFiles).
	filesListContent := filesList items.
	filesList unselectAll
]

{ #category : #utility }
FDFileDialogPresenter >> bookmarks [
	^ bookmarks
]

{ #category : #'api-customization' }
FDFileDialogPresenter >> bookmarks: aCollectionOfFDGroupBookMark [
	bookmarks := aCollectionOfFDGroupBookMark.
	bookmarksTreeTable roots: aCollectionOfFDGroupBookMark
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
FDFileDialogPresenter >> confirm [
	self flag: #changeIt.
	"it's horrible when we select a the bad selection (we select e file instead a directory) it's close it"
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
							self needRebuild: false.
							self buildWithSpecLayout: self class layoutPreviewer ]
						ifFalse: [ previewContentPresenter := nil.
							self needRebuild: false.
							self buildWithSpec ] ] ]
]

{ #category : #utility }
FDFileDialogPresenter >> filterACollection: aCollectionOfFileReference [
	| collection |
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

{ #category : #'api-customization' }
FDFileDialogPresenter >> filtersCustomization: aCollectionOfFilter [
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

{ #category : #accessing }
FDFileDialogPresenter >> filtersDropList [
	^ filtersDropList
]

{ #category : #initialization }
FDFileDialogPresenter >> filtersDropListAction [
	filtersDropList
		transmitTo: filesList
		transform:
			[ :filterBis | filesListContent select: [ :item | filterBis predicate: item ] ]
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
	super initialize.
	showHiddenFiles := false.
	okActionBlock := OkActionBlock.
	hiddenFilter := FDHidenFilePredicate new.
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
		roots: bookmarks;
		children: [ :child | 
			child isComposite
				ifTrue: [ child collection ]
				ifFalse: [ {} ] ]
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
FDFileDialogPresenter >> initializePresenter [
	self bookmarksTreeTableAction.
	self filesListAction.
	self filtersDropListAction.
	self currentPathTextInputAction.
	self lastDirectoryVisitiBeforeButtonAction.
	self lastDirectoryVisitiAfterButtonAction
]

{ #category : #initialization }
FDFileDialogPresenter >> initializeWidgets [
	currentDirectory := Directory copy.
	bookmarks := Bookmarks copy.
	
	bookmarksTreeTable := self newTreeTable.
	filesList := self newList.
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
	self initializeBookmarksTreeTable.
	self initializeFilesList.
	self initializeFiltersDropList.
	self focusOrder
		add: bookmarksTreeTable;
		add: lastDirectoryVisitBeforeButton;
		add: lastDirectoryVisitAfterButton ;
		add: currentPathTextInputPresenter;
		add: filesList;
		add: nameText;	
		add: filtersDropList
]

{ #category : #accessing }
FDFileDialogPresenter >> isRootDirectory: aDirectory [
	^ aDirectory isRoot or: [ OSPlatform current isWindows and: [ aDirectory parent isRoot ] ]
]

{ #category : #accessing }
FDFileDialogPresenter >> lastDirectoryVisitAfterButton [
	^ lastDirectoryVisitAfterButton
]

{ #category : #accessing }
FDFileDialogPresenter >> lastDirectoryVisitBeforeButton [
	^ lastDirectoryVisitBeforeButton
]

{ #category : #'initialize-actions' }
FDFileDialogPresenter >> lastDirectoryVisitiAfterButtonAction [
	lastDirectoryVisitAfterButton
		action: [ readPointerHistoryParcour hasSuccessor
				ifFalse: [ self
						inform:
							'this button is use to go after clicking on <- button to return on the last directory' ]
				ifTrue: [ self
						ChangeDirectoryApplyToPresenter: readPointerHistoryParcour nextLink value.
					readPointerHistoryParcour := readPointerHistoryParcour nextLink ] ]
]

{ #category : #'initialize-actions' }
FDFileDialogPresenter >> lastDirectoryVisitiBeforeButtonAction [
	lastDirectoryVisitBeforeButton
		action: [ readPointerHistoryParcour hasPredecessor
				ifFalse: [ self inform: 'this button is used to go to the last directory ' ]
				ifTrue: [ self
						ChangeDirectoryApplyToPresenter: readPointerHistoryParcour previousLink value.
					readPointerHistoryParcour := readPointerHistoryParcour
						previousLink ] ]
]

{ #category : #accessing }
FDFileDialogPresenter >> nameLabel [
	^ nameLabel
]

{ #category : #accessing }
FDFileDialogPresenter >> nameText [
	^ nameText
]

{ #category : #'api-customization' }
FDFileDialogPresenter >> okActionBlock: aOneArgBlock [
	okActionBlock := aOneArgBlock
]

{ #category : #utility }
FDFileDialogPresenter >> openFolder: aFolder [
	self ChangeDirectoryApplyToPresenter: aFolder.
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

{ #category : #accessing }
FDFileDialogPresenter >> readPointerHistoryParcour [
	^ readPointerHistoryParcour
]

{ #category : #utility }
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
