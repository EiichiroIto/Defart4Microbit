Class {
	#name : #DefartSettings,
	#superclass : #ScratchSettings,
	#category : #'Defart-Spec2'
}

{ #category : #settings }
DefartSettings >> defaultModules [

	^ dictionary at: #defaultModules ifAbsentPut: [ '' ]
]

{ #category : #settings }
DefartSettings >> defaultModules: aString [

	dictionary at: #defaultModules put: aString
]

{ #category : #initialization }
DefartSettings >> initialize [

	super initialize.
	self inputFlowControlType: 0.
	self outputFlowControlType: 0.
	self defaultModules: ''
]

{ #category : #settings }
DefartSettings >> inputFlowControlType [

	^ dictionary at: #inputFlowControlType ifAbsentPut: [ 0 ]
]

{ #category : #settings }
DefartSettings >> inputFlowControlType: aNumber [

	dictionary at: #inputFlowControlType put: aNumber
]

{ #category : #settings }
DefartSettings >> optionsFor: aSymbol [

	aSymbol = #inputFlowControlType ifTrue: [ ^ #( 0 1 2 ) ].
	aSymbol = #outputFlowControlType ifTrue: [ ^ #( 0 1 2 ) ].
	aSymbol = #defaultModules ifTrue: [ ^ #string ].
	aSymbol = #unusedPortNames ifTrue: [ ^ #string ].
	^ super optionsFor: aSymbol
]

{ #category : #settings }
DefartSettings >> outputFlowControlType [

	^ dictionary at: #outputFlowControlType ifAbsentPut: [ 0 ]
]

{ #category : #settings }
DefartSettings >> outputFlowControlType: aNumber [

	dictionary at: #outputFlowControlType put: aNumber
]

{ #category : #settings }
DefartSettings >> unusedPortNames [

	^ dictionary at: #unusedPortNames ifAbsentPut: [ '' ]
]

{ #category : #settings }
DefartSettings >> unusedPortNames: aString [

	dictionary at: #unusedPortNames put: aString
]
