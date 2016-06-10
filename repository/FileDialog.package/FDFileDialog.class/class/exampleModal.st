example
exampleModal
	"return the selected value"
	(FDSaveFileDialog new
		filteredExtensions:
			{'All images' -> #(jpg png gif svg).
			'All files' -> #()};
		defaultFolder: FileLocator imageDirectory asFileReference;
		defaultName: 'hello.png';
		openModal) inspect