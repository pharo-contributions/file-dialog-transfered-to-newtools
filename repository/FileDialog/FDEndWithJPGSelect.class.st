"
I'm selecting file finishing with .jpg
"
Class {
	#name : #FDEndWithJPGSelect,
	#superclass : #FDAbstractSimpleSelect,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDEndWithJPGSelect >> name [
	^ 'end with jpg'
]

{ #category : #accessing }
FDEndWithJPGSelect >> predicate: aFileReference [
	^ aFileReference basename
		regex: '.*\.jpg'
		matchesDo: [ :item | ^ true ]
]
