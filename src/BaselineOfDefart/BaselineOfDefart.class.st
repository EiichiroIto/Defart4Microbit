Class {
	#name : #BaselineOfDefart,
	#superclass : #BaselineOf,
	#category : #BaselineOfDefart
}

{ #category : #baselines }
BaselineOfDefart >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec
			package: 'FromScratch';
			package: 'FromScratch-Tests'
			with: [ spec requires: #( 'FromScratch' ) ];
			package: 'MicroPythonProxy';
			package: 'MicroPythonBlocks'
			with: [ spec requires: #( 'FromScratch' 'MicroPythonProxy' ) ];
			package: 'Defart' with: [ 
				spec requires:
						#( 'FromScratch' 'MicroPythonProxy' 'MicroPythonBlocks' ) ];
			package: 'Defart-Tests' with: [ 
				spec requires:
						#( 'FromScratch' 'Defart' 'MicroPythonProxy' 'MicroPythonBlocks' ) ] ]
]
