Class {
	#name : #FDJPGPreviewer,
	#superclass : #FDAbstractPreviewer,
	#category : #'FileDialog-previewerStrategie'
}

{ #category : #testing }
FDJPGPreviewer >> canBeUsedOn: aFileReference [
	^ FDDotJPGFilter new filter: aFileReference
]

{ #category : #'as yet unclassified' }
FDJPGPreviewer >> previewOn: aFileReference [
	^ SpImagePresenter new
		image:
			(aFileReference
				binaryReadStreamDo: [ :stream | PNGReadWriter formFromStream: stream ]);
		yourself
]
