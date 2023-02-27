Class {
	#name : #StartNodeMorph,
	#superclass : #StartHatMorph,
	#traits : 'TEdgeHandle + TGraphObject',
	#classTraits : 'TEdgeHandle classTrait + TGraphObject classTrait',
	#category : #'Defart-Blocks'
}

{ #category : #converting }
StartNodeMorph >> asBlockTuple [

	^ Array with: selector with: self id
]

{ #category : #accessing }
StartNodeMorph >> defaultArgs: defaultValues [

	defaultValues isEmpty ifTrue: [ ^ self ].
	self id: defaultValues first
]

{ #category : #'code generation' }
StartNodeMorph >> emitCode: aGenerator indent: indent [

	aGenerator emitStartNodeBlock: self indent: indent
]

{ #category : #initialization }
StartNodeMorph >> initialize [

	super initialize.
	self addEdgeHandle
]

{ #category : #testing }
StartNodeMorph >> isNodeMorph [

	^ true
]

{ #category : #testing }
StartNodeMorph >> isStartNodeMorph [

	^ true
]
