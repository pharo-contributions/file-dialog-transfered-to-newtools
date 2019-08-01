Class {
	#name : #FDJPGPreviewer,
	#superclass : #FDAbstractPreviewer,
	#category : #'FileDialog-previewerStrategie'
}

{ #category : #testing }
FDJPGPreviewer >> matchingMimeType: aZnMimeType [
	"return a Boolean to indicate if element matches"

	^ aZnMimeType matches: ZnMimeType imageJpeg
]

{ #category : #'as yet unclassified' }
FDJPGPreviewer >> previewOn: aFileReference [
SpImagePresenter new
		image:
			(aFileReference
				binaryReadStreamDo: [ :stream | PNGReadWriter formFromStream: stream ]);
		yourself
]
