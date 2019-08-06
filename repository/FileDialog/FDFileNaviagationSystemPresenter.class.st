"
I'm use by thez fileDialog

my job is to navigate across file 

I provide:
* an history of visited folder
* a textInput use to jump to the write path
* a dropList use to filter the content of the fileReferenceTable
* a TextPresenter to show the selectedFile 

CUSTOMIZATION
-------------

look at the protocol 'api-customization'

column: aCollectionOfColumn
===========================

	to use it you have to give a collection of son of FDAbstractFileReferenceColumn for more information on how to create see documentation of FDAbstractFileReferenceColumn

defaultFoler: aFileReference
============================

	nothing to say 

filtersCustomization: aCollectionOfFilter
=========================================

	more documentation see FDAbstractPredicate documentation

previewer: aPreviewer
=====================

	more documentation see FDAbstractPreviewer documentation
	
IV
--

currentPathTextInputPresenter : <SpTextInputFieldPresenter> It's use to display the current path and there are same feature like in window 
nameLabel : <SpLabelPresenter>
nameText: <SpTextInputFieldPresenter> , use to show the name of the selected item of fileReferenceTable
filtersDropList <SpDropList> , use to display all the filter
readPointerHistoryParcour <DoubleLink> , use for the navigationSystem
currentDirectory , <FileReference> into there is the currentDirectory 
hiddenFilter <FDAbstractPredicate> there is a NullFilter or an hiddenFilter
columns <FDAbstractFileReferenceColumn> it's a collection of Column use by FileReferenceTable
previewer <FDAbstractPreviewer> 
nextButton <SpButton> use for the navigationSystem 
previousButton <SpButton> use for the navigationSystem
notebookPreviewer <SpNoteBook> use by the preview system
fileReferenceTable <SpTablePresenter> it's display children of the current directory
"
Class {
	#name : #FDFileNaviagationSystemPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'currentPathTextInputPresenter',
		'nameLabel',
		'nameText',
		'filtersDropList',
		'readPointerHistoryParcour',
		'currentDirectory',
		'hiddenFilter',
		'columns',
		'previewer',
		'nextButton',
		'previousButton',
		'notebookPreviewer',
		'fileReferenceTable'
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
	^ FDAbstractSelect actions
]

{ #category : #defaults }
FDFileNaviagationSystemPresenter class >> defaultPreviewer [
	^ FDNullPreviewer new
]

{ #category : #specs }
FDFileNaviagationSystemPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add:
			(SpBoxLayout newHorizontal
				add: #previousButton
					withConstraints: [ :contraint | contraint width: 30 ];
				add: #nextButton
					withConstraints: [ :contraint | contraint width: 30 ];
				add: #currentPathTextInputPresenter;
				yourself)
			withConstraints: [ :contraint | contraint height: self toolbarHeight ];
		add: (SpPanedLayout newVertical 
				add: #fileReferenceTable;
				add: #notebookPreviewer;
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
	"presenter defaultFolder: FileLocator documents."
	presenter previewer: FDPNGPreviewer new.
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

{ #category : #'api-customization' }
FDFileNaviagationSystemPresenter >> column: aCollectionOfColumns [
	fileReferenceTable column: aCollectionOfColumns
	
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

{ #category : #accessing }
FDFileNaviagationSystemPresenter >> currentDirectory [ 
	^ currentDirectory
]

{ #category : #'initialize-actions' }
FDFileNaviagationSystemPresenter >> currentPathTextInputAction [
	currentPathTextInputPresenter
		whenTextIsAcceptedDo: [ :text | 
			text asFileReference exists
				ifFalse: [ self
						inform: 'you have to write an absolute path and an existing one' ]
				ifTrue: [ self openFolder: text asFileReference ] ]
]

{ #category : #accessing }
FDFileNaviagationSystemPresenter >> currentPathTextInputPresenter [
	^ currentPathTextInputPresenter
]

{ #category : #'api-customization' }
FDFileNaviagationSystemPresenter >> defaultFolder: aFileReference [
	self updateWidgetWithFileReference: aFileReference.
	readPointerHistoryParcour value: aFileReference
]

{ #category : #accessing }
FDFileNaviagationSystemPresenter >> fileReferenceTable [
	^ fileReferenceTable
]

{ #category : #'initialize-actions' }
FDFileNaviagationSystemPresenter >> filesListAction [
	fileReferenceTable
		transmitTo: nameText
		transform: [ :selectedItem | selectedItem basename ].
	fileReferenceTable
		whenActivatedDo: [ :selectedItem | 
			selectedItem selectedItem isDirectory
				ifTrue: [ self openFolder: selectedItem selectedItem ] ].
	fileReferenceTable
		whenSelectionChangedDo:
			[ :aFileReference | notebookPreviewer page: (previewer previewOn: aFileReference selectedItem) ]
]

{ #category : #'api-customization' }
FDFileNaviagationSystemPresenter >> filtersCustomization: aCollectionOfFilter [
	"i always add the filter 'no filter'"

	filtersDropList
		items:
			(aCollectionOfFilter asOrderedCollection
				add: FDDefaultSelect new;
				yourself) asSet asOrderedCollection.
	filtersDropList
		selectedIndex:
			((filtersDropList listItems collect: #name)
				indexOf: FDDefaultSelect new name)
]

{ #category : #accessing }
FDFileNaviagationSystemPresenter >> filtersDropList [
	^ filtersDropList
]

{ #category : #'initialize-actions' }
FDFileNaviagationSystemPresenter >> filtersDropListAction [
	filtersDropList
		whenSelectionChangedDo: [ self updateWidgetWithFileReference: currentDirectory ]
]

{ #category : #'initialize-widgets' }
FDFileNaviagationSystemPresenter >> initializeFilesList [
	fileReferenceTable
		contextMenu: [ (self rootCommandsGroup / 'interact with file') beRoot
				asMenuPresenter ]
]

{ #category : #'initialize-widgets' }
FDFileNaviagationSystemPresenter >> initializeFiltersDropList [
	| filterItems |
	filterItems := FilterSet copy.
	filterItems asOrderedCollection add: FDDefaultSelect new.
	filterItems := filterItems asSet.
	filtersDropList
		items: filterItems asOrderedCollection;
		displayBlock: [ :item | item name ];
		selectedIndex:
			((filtersDropList listItems collect: #name)
				indexOf: FDDefaultSelect new name)
]

{ #category : #initialization }
FDFileNaviagationSystemPresenter >> initializePresenter [
	self filesListAction.
	self filtersDropListAction.
	self currentPathTextInputAction.
	self previousBeforeButtonAction.
	self nextButtonAction
]

{ #category : #initialization }
FDFileNaviagationSystemPresenter >> initializeWidgets [
	currentDirectory := Directory copy.
	columns := Columns.
	hiddenFilter := FDHidenSelect new.
	previewer := Previewer.
	notebookPreviewer := self instantiate: FDNoteBookPreviewerPresenter.
	fileReferenceTable := self newTable.
	currentPathTextInputPresenter := self newTextInput.
	nameLabel := self newLabel.
	nameText := self newTextInput.
	filtersDropList := self newDropList.
	previousButton := self newButton.
	nextButton := self newButton.
	readPointerHistoryParcour := DoubleLink value: currentDirectory.
	currentPathTextInputPresenter text: currentDirectory fullName.
	nextButton icon: (self iconNamed: #glamorousDiveRight).
	previousButton icon: (self iconNamed: #back).
	nameLabel label: 'Name:'.
	nameText autoAccept: true.
	fileReferenceTable
		columns: columns;
		sortingBlock: [ :a :b | 
			(a isDirectory & b isDirectory not
				or: [ a isDirectory & b isDirectory
						& (a basename asLowercase < b basename asLowercase) ])
				or: [ a isFile & b isFile
						& (a basename asLowercase < b basename asLowercase) ] ].
	self initializeFilesList.
	self initializeFiltersDropList.
	self updateWidgetWithFileReference: currentDirectory.
	self focusOrder
		add: previousButton;
		add: nextButton;
		add: currentPathTextInputPresenter;
		add: fileReferenceTable;
		add: nameText;
		add: filtersDropList
]

{ #category : #accessing }
FDFileNaviagationSystemPresenter >> nameLabel [
	^ nameLabel
]

{ #category : #accessing }
FDFileNaviagationSystemPresenter >> nextButton [
	^ nextButton
]

{ #category : #accessing }
FDFileNaviagationSystemPresenter >> nextButtonAction [
	nextButton
		action: [ readPointerHistoryParcour hasSuccessor
				ifFalse: [ self
						inform:
							'this button is use to go after clicking on <- button to return on the last directory' ]
				ifTrue: [ readPointerHistoryParcour := readPointerHistoryParcour nextLink.
					self
						updateWidgetWithFileReference: readPointerHistoryParcour value ] ]
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> openFolder: aFileReference [
	self updateWidgetWithFileReference: aFileReference.
	readPointerHistoryParcour
		nextLink:
			((DoubleLink value: currentDirectory)
				previousLink: readPointerHistoryParcour;
				yourself).
	readPointerHistoryParcour := readPointerHistoryParcour nextLink
]

{ #category : #acccessing }
FDFileNaviagationSystemPresenter >> previewer [
	^ previewer
]

{ #category : #'api-customization' }
FDFileNaviagationSystemPresenter >> previewer: aPreviewer [ 
	previewer := aPreviewer 
]

{ #category : #'initialize-actions' }
FDFileNaviagationSystemPresenter >> previousBeforeButtonAction [
	previousButton
		action: [ readPointerHistoryParcour hasPredecessor
				ifFalse: [ self inform: 'this button is used to go to the last directory ' ]
				ifTrue:
					[ readPointerHistoryParcour := readPointerHistoryParcour previousLink.
					self updateWidgetWithFileReference: readPointerHistoryParcour value  ] ]
]

{ #category : #accessing }
FDFileNaviagationSystemPresenter >> previousButton [
	^ previousButton
]

{ #category : #accessing }
FDFileNaviagationSystemPresenter >> readPointerHistoryParcour [
	^ readPointerHistoryParcour
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> toggleHiddenFiles [
	(hiddenFilter equals: FDDefaultSelect new)
		ifTrue: [ hiddenFilter := FDHidenSelect new ]
		ifFalse: [ hiddenFilter := FDDefaultSelect new ].
	self updateTableContent
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> updateTableContent [
	fileReferenceTable
		items:
			(hiddenFilter
				applyOn: (filtersDropList selectedItem applyOn: currentDirectory children))
]

{ #category : #utility }
FDFileNaviagationSystemPresenter >> updateWidgetWithFileReference: aFileReference [
	currentDirectory := aFileReference.
	self updateTableContent.
	currentPathTextInputPresenter text: currentDirectory fullName
]
