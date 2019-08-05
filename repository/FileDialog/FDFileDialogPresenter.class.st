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
		'okActionBlock',
		'bookmarksTreeTable',
		'bookmarks'
	],
	#classVars : [
		'Bookmarks',
		'Directory',
		'FilterSet',
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
			((CmCommandGroup named: 'interact with bookmark') asSpecGroup
				register: (FDAddBookmarkCommand  forSpec context: presenter )
				yourself);
			register: ((CmCommandGroup named: 'bookmarkCommand') asSpecGroup
				register: (FDRemoveBookmarkCommand forSpec context: presenter);
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
		withIconName: '')} asOrderedCollection
]

{ #category : #defaultClassVariable }
FDFileDialogPresenter class >> defaultOkActionBlock [
	^ [ :fileReference | self inform: 'you select the file' , fileReference basename ]
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

{ #category : #example }
FDFileDialogPresenter class >> examplePreviewer [
	| presenter |
	self flag: 'its dont work i think it''s because adapter are not rebuild see issue https://github.com/pharo-spec/Spec/issues/635'.
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
	
	presenter previewer: FDPNGPreviewer new.	
	self flag: 'its dont work i think it''s because adapter are not rebuild see issue https://github.com/pharo-spec/Spec/issues/635'.
	"with this when you select a png file it will display it"
	
	presenter filtersCustomization: {FDJPGAndPNGPredicate new}.
	"with you add filter and there always the 'no filter'"
	
	presenter defaultFolder: FileLocator home asFileReference.
	"it's open the FileDialog on this file"
	
	presenter okActionBlock: [ :selectedFileReference | selectedFileReference inspect ].
	"you will define the action of the OK button "
	
	presenter
		bookmarks:
			{(FDGroupBookMark
				CreatWithname: 'exampleGroup'
				WithContent:
					{FDBookmark image.
					FDBookmark home}
				withIconName: 'group')}.
	"you define the bookmarks have to be instance of FDAbstractBookMark"
	
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
	"filesList table
		whenModelChangedDo: [ :selectedFileReference | 1halt.
			nameText
				text:
					(selectedFileReference selectedItem
						ifNotNil: [ selectedFileReference selectedItem basename ]
						ifNil: [ 'noFileSelected' ]) ]."
	"filesList
		whenSelectionChangedDo: [ :selectedFileReference | 
			previewer
				ifNotNil: [ (previewer canBeUsedOn: selectedFileReference selectedItem)
						ifTrue: [ previewContentPresenter := previewer
								previewOn: selectedFileReference selectedItem.
							self needRebuild: false.
							self buildWithSpecLayout: self class layoutPreviewer ]
						ifFalse: [ previewContentPresenter := nil.
							self needRebuild: false.
							self buildWithSpec ] ] ]"
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
	okActionBlock := OkActionBlock.
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
				ifFalse: [ {} ] ];
			contextMenu: [ (self rootCommandsGroup / 'bookmarkCommand') beRoot
				asMenuPresenter ]
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
	filesList table
		contextMenu: [ (self rootCommandsGroup / 'interact with file') beRoot
				asMenuPresenter ]
]

{ #category : #initialization }
FDFileDialogPresenter >> initializePresenter [
	self bookmarksTreeTableAction.
	self filesListAction.
	"self filtersDropListAction".
	self currentPathTextInputAction.
	self lastDirectoryVisitiBeforeButtonAction.
	self lastDirectoryVisitiAfterButtonAction
]

{ #category : #initialization }
FDFileDialogPresenter >> initializeWidgets [
	bookmarks := Bookmarks.
	
	bookmarksTreeTable := self newTreeTable.
	filesList := self instantiate: FDFileNaviagationSystemPresenter.
	nameText := self newTextInput.
	nameText autoAccept: true.
	
	self initializeBookmarksTreeTable.
	self initializeFilesList.
	self focusOrder
		add: bookmarksTreeTable;
		add: filesList;
		add: nameText
]

{ #category : #accessing }
FDFileDialogPresenter >> isRootDirectory: aDirectory [
	^ aDirectory isRoot or: [ OSPlatform current isWindows and: [ aDirectory parent isRoot ] ]
]

{ #category : #initialization }
FDFileDialogPresenter >> isolate [
	bookmarks := bookmarks copy.
	
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
