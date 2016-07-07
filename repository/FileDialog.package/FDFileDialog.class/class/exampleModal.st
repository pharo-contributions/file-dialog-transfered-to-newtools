example
exampleModal
	"modal returns the selected value"

	(FDOpenDirectoryDialog new
		defaultFolder: FileLocator imageDirectory asFileReference;
		openModal) inspect