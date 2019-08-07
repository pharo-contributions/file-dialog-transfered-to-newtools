"
I'm selecting file finishing with .png
"
Class {
	#name : #FDEndWithPNGSelect,
	#superclass : #FDAbstractSimpleSelect,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDEndWithPNGSelect >> name [
	^ 'end with png'
]

{ #category : #accessing }
FDEndWithPNGSelect >> predicate: aFileReference [
	^ aFileReference basename
		regex: '.*\.png'
		matchesDo: [ :item | ^ true ]
]
