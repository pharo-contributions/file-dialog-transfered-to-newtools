"
I override methods related to opening a file dialog to use my own file dialog instead of the system's one.

To use me by default, see class-side.
"
Class {
	#name : #FDMorphicUIManager,
	#superclass : #MorphicUIManager,
	#category : 'FileDialog'
}

{ #category : #public }
FDMorphicUIManager class >> beDefault [
	<script>
	self new beDefault
]

{ #category : #'ui requests' }
FDMorphicUIManager >> chooseDirectory: label from: dir [
	^ FDOpenDirectoryDialog new
		defaultFolder: dir;
		title: (label ifNil: [ 'Choose Directory' translated ]);
		openModal
]

{ #category : #'ui requests' }
FDMorphicUIManager >> chooseDirectory: label path: path [
	^ FDOpenDirectoryDialog new
		defaultFolder: path;
		title: (label ifNil: [ 'Choose Directory' translated ]);
		openModal
]

{ #category : #'ui requests' }
FDMorphicUIManager >> chooseFileMatching: patterns label: label [
	^ FDOpenFileDialog new
		title: (label ifNil: [ 'Choose File' translated ]);
		fileFilters: patterns;
		openModal
]

{ #category : #'ui requests' }
FDMorphicUIManager >> chooseFileName: title extensions: exts path: path preview: preview [
	^ (FDOpenFileDialog new
		title: (title ifNil: [ 'Choose File' translated ]);
		fileFilters: (exts ifNil: [ #() ] ifNotNil: [ :e | e collect: [ :each | '*.' , each ] ]);
		defaultFolder: path;
		openModal) ifNotNil: #basename
]

{ #category : #'ui requests' }
FDMorphicUIManager >> chooseFullFileName: title extensions: exts path: path preview: preview [
	^ (FDOpenFileDialog new
		title: (title ifNil: [ 'Choose File' translated ]);
		fileFilters: (exts ifNil: [ #() ] ifNotNil: [ :e | e collect: [ :each | '*.' , each ] ]);
		defaultFolder: path;
		openModal) ifNotNil: #fullName
]

{ #category : #'ui requests' }
FDMorphicUIManager >> chooseFullFileNameMatching: patterns label: title [
	^ (FDOpenFileDialog new
		title: (title ifNil: [ 'Choose File' translated ]);
		fileFilters: (patterns ifNil: [ #() ] ifNotNil: [ :e | e collect: [ :each | '*.' , each ] ]);
		openModal)
]

{ #category : #'ui requests' }
FDMorphicUIManager >> fileOpen: title extensions: exts path: path preview: preview [
	^ (FDOpenFileDialog new
		title: (title ifNil: [ 'Choose File' translated ]);
		fileFilters: (exts ifNil: [ #() ] ifNotNil: [ :e | e collect: [ :each | '*.' , each ] ]);
		defaultFolder: path;
		openModal) ifNotNil: #readStream
]

{ #category : #'ui requests' }
FDMorphicUIManager >> fileSave: title extensions: exts path: path [
	^ (FDSaveFileDialog new
		title: (title ifNil: [ 'Choose File' translated ]);
		fileFilters: (exts ifNil: [ #() ] ifNotNil: [ :e | e collect: [ :each | '*.' , each ] ]);
		defaultFolder: path;
		openModal)
]
