Class {
	#name : #FDJPGPreviewer,
	#superclass : #FDAbstractPreviewer,
	#category : #'FileDialog-previewerStrategie'
}

{ #category : #testing }
FDJPGPreviewer class >> canBeUsedOn: aFileReference [
	^ FDDotJPGFilter new filter: aFileReference
]

{ #category : #'as yet unclassified' }
FDJPGPreviewer class >> previewOn: aFileReference [
	^ SpImagePresenter new
		image:
			(aFileReference
				binaryReadStreamDo: [ :stream | PNGReadWriter formFromStream: stream ]);
		yourself
]
