example
example
	^ FDOpenFileDialog new
		whenSelected: [ :file | file inspect ];
		extensionFilters:
			{'All Images' -> #(jpg png gif svg).
			'All Files' -> #()};
		defaultFolder: FileLocator imageDirectory asFileReference;
		defaultName: 'hello.png';
		open