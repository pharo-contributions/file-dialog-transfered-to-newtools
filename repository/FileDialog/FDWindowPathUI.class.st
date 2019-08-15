Class {
	#name : #FDWindowPathUI,
	#superclass : #SpPresenter,
	#instVars : [
		'textInput',
		'edditButton',
		'currentDirectory',
		'pathButtons',
		'presenterUI',
		'isTextInput'
	],
	#category : #'FileDialog-UI'
}

{ #category : #specs }
FDWindowPathUI class >> defaultSpec [
	^ SpBoxLayout newHorizontal
		add: #pathButtons;
		add: #edditButton withConstraints: [:contraint |contraint width: 30];
		yourself
]

{ #category : #examples }
FDWindowPathUI class >> example [
	<example>
	^ self new
		currentDirectory: FileLocator imageDirectory;
		openWithSpec
]

{ #category : #specs }
FDWindowPathUI class >> otherlayout [
	^ SpBoxLayout newHorizontal
		add: #textInput withConstraints: [:contraint | contraint spec: #fDLayoutFileDialog]; 
		add: #edditButton withConstraints: [:contraint |contraint width: 30 ];
		yourself
]

{ #category : #factory }
FDWindowPathUI >> creatButtonWith: aFileReference [
	^ SpButtonPresenter new
		label: aFileReference basename;
		action: [ 
			1halt.
			currentDirectory :=  aFileReference .
			textInput entityText text: currentDirectory fullName.
			presenterUI openOn: currentDirectory
			 ];
		yourself
]

{ #category : #api }
FDWindowPathUI >> currentDirectory: aFileReference [
	currentDirectory := aFileReference.
	textInput
		placeholder: 'give/me/a/path';
		possibleEntities: currentDirectory children.
	textInput entityText text: currentDirectory fullName.
	pathButtons initialize.
	currentDirectory fullPath withParents
		do:
			[ :eachAbsolutePath | pathButtons add: (self creatButtonWith: eachAbsolutePath) ]
]

{ #category : #accessing }
FDWindowPathUI >> entityText [
	^ textInput entityText
]

{ #category : #initialization }
FDWindowPathUI >> initializeWidgets [
	isTextInput := false.
	textInput := self instantiate: SpSelectEntity.
	pathButtons := self newActionBar.
	edditButton := self newButton.
	textInput entityText autoAccept: false.
	edditButton
		icon: (self iconNamed: #edit);
		action: [ self window
				rebuildWithSpecLayout:
					(isTextInput
						ifTrue: [ self class defaultSpec ]
						ifFalse: [ self class otherlayout ]).
			isTextInput := isTextInput not ]
]

{ #category : #accessing }
FDWindowPathUI >> pathButtons [
	^ pathButtons
]
