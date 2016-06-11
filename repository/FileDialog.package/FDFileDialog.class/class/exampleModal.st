example
exampleModal
	"return the selected value"

	(FDSaveFileDialog new
		fileFilters:
			{'STON files' -> #('*.ston').
			'All files' -> #()};
		defaultFolder: FileLocator imageDirectory asFileReference;
		defaultName: 'hello.png';
		openModal) inspect