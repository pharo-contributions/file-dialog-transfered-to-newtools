"
I'm using to navigate into file
"
Class {
	#name : #FDFileListPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'table',
		'detail',
		'columns',
		'currentDirectory'
	],
	#classVars : [
		'Columns',
		'Prevewer'
	],
	#category : #'FileDialog-UI'
}

{ #category : #defaults }
FDFileListPresenter class >> defaultColumns [
	^ {
	FDIconFileReferenceTableColumn column width: 20.
	FDbasenameFileReferenceColumn column.
	FDSizeFileReferenceColumn column.
	FDAccessRightFileReferenceColumn column}
]

{ #category : #'class initialization' }
FDFileListPresenter class >> defaultPreviewer [
	^ nil
]

{ #category : #specs }
FDFileListPresenter class >> defaultSpec [

	^ SpPanedLayout newVertical
		position: 30 percent;
		add: #table;
		add: #detail;
		yourself
]

{ #category : #examples }
FDFileListPresenter class >> example [

	^self openOn: FileSystem workingDirectory
]

{ #category : #'class initialization' }
FDFileListPresenter class >> initialize [
	Columns := self defaultColumns.
	Prevewer := self defaultPreviewer
]

{ #category : #'instance creation' }
FDFileListPresenter class >> on: aFileReference [

	^(self new)
		folder: aFileReference;
		yourself
]

{ #category : #show }
FDFileListPresenter class >> openOn: aFileReference [

	(self on: aFileReference) openWithSpec
]

{ #category : #'api-customization' }
FDFileListPresenter >> columns: aCollectionOfColumn [
	columns := aCollectionOfColumn
]

{ #category : #accessing }
FDFileListPresenter >> currentDirectory [ 
	^ currentDirectory 
]

{ #category : #accessing }
FDFileListPresenter >> currentDirectory: aFileReference [
	currentDirectory := aFileReference 
]

{ #category : #accessing }
FDFileListPresenter >> detail [

	^detail 
]

{ #category : #accessing }
FDFileListPresenter >> folder: aFileReference [
	detail showFile: nil.
   self table items: aFileReference children
	
]

{ #category : #initialization }
FDFileListPresenter >> initializePresenter [
	table
		whenActivatedDo: [ :selectedItem | 
			selectedItem selectedItem isDirectory
				ifTrue: [ table items: selectedItem selectedItem children.
					self currentDirectory: selectedItem selectedItem ] ]
]

{ #category : #initialization }
FDFileListPresenter >> initializeWidgets [
	columns := Columns.
	detail := self instantiate: HRBFileDetailPresenter.
	table := self newTable.
	
	table
		columns: columns;
		sortingBlock: [ :a :b | 
			(a isDirectory & b isDirectory not
				or: [ a isDirectory & b isDirectory
						& (a basename asLowercase < b basename asLowercase) ])
				or: [ a isFile & b isFile
						& (a basename asLowercase < b basename asLowercase) ] ]
]

{ #category : #'api-customization' }
FDFileListPresenter >> isolate [
	columns := columns copy
]

{ #category : #'as yet unclassified' }
FDFileListPresenter >> listAction [
	self flag: #warning.
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

{ #category : #accessing }
FDFileListPresenter >> table [
	
	^table 
]

{ #category : #'api-events' }
FDFileListPresenter >> whenItemsChangedDo: aBlock [
	
	table whenSelectionChangedDo: [:sel | 
		|items|
		items := sel selectedItems.
		aBlock cull: items.
			detail showFile: (items ifEmpty: [ nil ] ifNotEmpty: [ items last ])
	] 
]
