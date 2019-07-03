Class {
	#name : #FDEndWithPNGFilter,
	#superclass : #FDAbstractSimpleFilter,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDEndWithPNGFilter >> filter: aFileReference [
	^ aFileReference basename
		regex: '.*\.png'
		matchesDo: [ :item | ^ true ]
]

{ #category : #accessing }
FDEndWithPNGFilter >> name [
	^ 'end with png'
]
