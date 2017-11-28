icons
allIcons
	<script: 'self allIcons inspect'>
	^ (Pragma allNamed: 'icons' in: FDFileDialog class)
		flatCollect: [ :pragma | pragma methodClass theNonMetaClass perform: pragma methodSelector ]