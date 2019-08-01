Class {
	#name : #HRBFolderContentPresenter2,
	#superclass : #SpPresenter,
	#instVars : [
		'table',
		'folder',
		'detail',
		'columns'
	],
	#classVars : [
		'Columns'
	],
	#category : #FileDialog
}

{ #category : #'as yet unclassified' }
HRBFolderContentPresenter2 class >> defaultColumns [
	^ {
	FDIconFileReferenceTableColumn column width: 20.
	FDbasenameFileReferenceColumn column.
	FDSizeFileReferenceColumn column.
	FDAccessRightFileReferenceColumn column}
]

{ #category : #specs }
HRBFolderContentPresenter2 class >> defaultSpec [

	^ SpPanedLayout newVertical
		position: 30 percent;
		add: #table;
		add: #detail;
		yourself
]

{ #category : #examples }
HRBFolderContentPresenter2 class >> example [

	^self openOn: FileSystem workingDirectory
]

{ #category : #'class initialization' }
HRBFolderContentPresenter2 class >> initialize [
	Columns := self defaultColumns
]

{ #category : #'instance creation' }
HRBFolderContentPresenter2 class >> on: aFileReference [

	^(self new)
		folder: aFileReference;
		yourself
]

{ #category : #show }
HRBFolderContentPresenter2 class >> openOn: aFileReference [

	(self on: aFileReference) openWithSpec
]

{ #category : #'api-customization' }
HRBFolderContentPresenter2 >> columns: aCollectionOfColumn [
	columns := aCollectionOfColumn.
	folder roots: columns
]

{ #category : #accessing }
HRBFolderContentPresenter2 >> detail [

	^detail ifNil: [ detail := (self instantiate: HRBFileDetailPresenter) ]
]

{ #category : #accessing }
HRBFolderContentPresenter2 >> folder [
	^ folder
]

{ #category : #accessing }
HRBFolderContentPresenter2 >> folder: aFileReference [
	detail showFile: nil.
   self table items: aFileReference children
	
]

{ #category : #initialization }
HRBFolderContentPresenter2 >> initializePresenter [
	table
		whenActivatedDo: [ :selectedItem | 
			selectedItem selectedItem isDirectory
				ifTrue: [ 1halt.table items: selectedItem selectedItem children ] ]
]

{ #category : #initialization }
HRBFolderContentPresenter2 >> initializeWidgets [
	columns := Columns.
	self detail.
	self table
		beMultipleSelection;
		columns: columns;
		sortingBlock: [ :a :b | 
			(a isDirectory & b isDirectory not
				or: [ a isDirectory & b isDirectory
						& (a basename asLowercase < b basename asLowercase) ])
				or: [ a isFile & b isFile
						& (a basename asLowercase < b basename asLowercase) ] ]
]

{ #category : #initialization }
HRBFolderContentPresenter2 >> isolate [
	columns := columns copy
]

{ #category : #accessing }
HRBFolderContentPresenter2 >> table [

	^table ifNil: [ table := self newTable ]
]

{ #category : #'api-events' }
HRBFolderContentPresenter2 >> whenItemsChangedDo: aBlock [
	
	table whenSelectionChangedDo: [:sel | 
		|items|
		items := sel selectedItems.
		aBlock cull: items.
			detail showFile: (items ifEmpty: [ nil ] ifNotEmpty: [ items last ])
	] 
]
