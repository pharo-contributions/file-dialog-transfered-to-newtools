"
I am a baseline for https://github.com/peteruhnak/file-dialog
"
Class {
	#name : #BaselineOfFileDialog,
	#superclass : #BaselineOf,
	#category : 'BaselineOfFileDialog'
}

{ #category : #baseline }
BaselineOfFileDialog >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec package: 'FileDialog'.
			spec package: 'FileDialog-Tests' with: [ spec requires: 'FileDialog' ].
			spec group: 'Core' with: #('FileDialog').
			spec group: 'All' with: #('FileDialog' 'FileDialog-Tests').
			spec group: 'default' with: #('All') ]
]
