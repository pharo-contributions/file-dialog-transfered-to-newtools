example
example
	^ FDSaveFileDialog new
		whenSelected: [ :file | file inspect ];
		filteredExtensions:
			{'All images' -> #(jpg png gif svg).
			'All files' -> #()};
		defaultFolder: FileLocator imageDirectory asFileReference;
		defaultName: 'hello.png';
		open