baseline
baseline: spec
	<baseline>
	spec
		for: #common
		do: [ spec package: 'FileDialog'.
			spec group: 'default' with: #('FileDialog') ]