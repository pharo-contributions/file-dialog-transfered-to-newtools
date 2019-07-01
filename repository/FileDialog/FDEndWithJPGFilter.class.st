Class {
	#name : #FDEndWithJPGFilter,
	#superclass : #FDAbstractSimpleFilter,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDEndWithJPGFilter >> filter: aFileReference [
	^ aFileReference basename
		regex: '.*\.jpg'
		matchesDo: [ :item | ^ true ]
]

{ #category : #accessing }
FDEndWithJPGFilter >> name [
	^ 'end with jpg'
]
