"
i'm use to dispay group of bookmark
"
Class {
	#name : #FDGroupBookMark,
	#superclass : #FDAbstractBookMark,
	#instVars : [
		'collection'
	],
	#category : #'FileDialog-bookMark'
}

{ #category : #'as yet unclassified' }
FDGroupBookMark class >> CreatWithname: aName WithContent: aCollection withIconName: icon [
	^ self new
		name: aName;
		collection: aCollection;
		iconNamed: icon;
		yourself
]

{ #category : #accessing }
FDGroupBookMark >> collection [
	^ collection
]

{ #category : #accessing }
FDGroupBookMark >> collection: anObject [
	collection := anObject
]

{ #category : #testing }
FDGroupBookMark >> isComposite [
	^ true
]
