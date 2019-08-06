"
My responsibility is to provide dialog for SAVING files.
"
Class {
	#name : #FDSaveFileDialog,
	#superclass : #FDFileDialogPresenter,
	#category : #'FileDialog-UI'
}

{ #category : #api }
FDSaveFileDialog >> initialTitle [
	^ 'Save As'
]

{ #category : #initialization }
FDSaveFileDialog >> initializePresenter [
	| ec |
	self flag: #StrangeItsDontWork.
	super initializePresenter.
	(ec := EntryCompletion new)
		dataSourceBlock: [ :text | filesList currentDirectory children collect: #basename ];
		filterBlock: [ :opt :text |opt beginsWith: text ].
	nameText entryCompletion: ec
]

{ #category : #initialization }
FDSaveFileDialog >> initializeWidgets [
	super initializeWidgets.
	"confirmButton label: 'Save'"
]

{ #category : #accessing }
FDSaveFileDialog >> selectedEntry [
	| entry proceed |
	self flag:#warning.
	entry := filesList currentDirectory / nameText text.
	1halt.
	filesList filtersDropList selectedItem value
		ifNotEmpty: [ :extensions | 
			(nameText text includes: $.)
				ifFalse: [ entry := entry
						, ((extensions first copyReplaceAll: '*' with: '') withoutPrefix: '.') ] ].
	proceed := entry exists not.
	entry exists
		ifTrue: [ proceed := UIManager default
				proceed:
					('File named "{1}" already exists. Do you want to overwrite it?'
						format: {entry printString}) ].
	^ proceed
		ifTrue: [ entry ]
		ifFalse: [ nil ]
]
