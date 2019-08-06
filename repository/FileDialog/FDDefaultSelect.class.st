"
I'm selecting all
"
Class {
	#name : #FDDefaultSelect,
	#superclass : #FDAbstractSimpleSelect,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #applying }
FDDefaultSelect >> applyOn: aCollectionOfFileReference [
	^ aCollectionOfFileReference
]

{ #category : #accessing }
FDDefaultSelect >> name [
	^ 'no filter'
]

{ #category : #accessing }
FDDefaultSelect >> predicate: aFileReference [
	^ true
]
