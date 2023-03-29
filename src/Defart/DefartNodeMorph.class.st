Class {
	#name : #DefartNodeMorph,
	#superclass : #CBlockMorph,
	#traits : 'TEdgeHandle + TGraphObject',
	#classTraits : 'TEdgeHandle classTrait + TGraphObject classTrait',
	#category : #'Defart-Blocks'
}

{ #category : #private }
DefartNodeMorph >> blockAttachPoints: aSet [

	nestedBlock
		ifNil: [ 
		aSet add: self topLeft + (12 @ (self topBarHeight + 7)) -> self ]
		ifNotNil: [ nestedBlock blockAttachPoints: aSet ]
]

{ #category : #private }
DefartNodeMorph >> clearMyself [

	owner ifNil: [ ^ self ].
	owner submorphsDo: [ :each | 
		each isEdgeMorph ifTrue: [ 
			each fromNode = self ifTrue: [ each fromNode: nil ].
			each toNode = self ifTrue: [ each toNode: nil ] ] ]
]

{ #category : #'submorphs - add/remove' }
DefartNodeMorph >> delete [

	self clearMyself.
	super delete
]

{ #category : #drawing }
DefartNodeMorph >> drawTopEdgeOn: aCanvas [

	| right |
	right := self width - 1.
	self
		drawHLineFrom: 2
		to: right - 2
		y: 0
		color: highlightColor1
		on: aCanvas.
	self
		drawHLineFrom: 1
		to: right - 1
		y: 1
		color: highlightColor2
		on: aCanvas.
	self
		drawHLineFrom: 0
		to: right
		y: 2
		color: color
		on: aCanvas.
	self
		drawHLineFrom: 0
		to: right
		y: 3
		color: color
		on: aCanvas.
	self
		drawHLineFrom: 0
		to: right
		y: 4
		color: color
		on: aCanvas
]

{ #category : #'code generation' }
DefartNodeMorph >> emitCode: aGenerator indent: indent [

	aGenerator emitNodeBlock: self indent: indent
]

{ #category : #testing }
DefartNodeMorph >> hasEdgeTo: anotherNode [

	^ receiver connectedEdgeMorphs anySatisfy: [ :each | 
		  each fromNode = self and: [ each toNode = anotherNode ] ]
]

{ #category : #testing }
DefartNodeMorph >> isForever [

	^ true
]

{ #category : #testing }
DefartNodeMorph >> isNodeMorph [

	^ true
]

{ #category : #'dropping/grabbing' }
DefartNodeMorph >> justDroppedInto: newOwner event: evt [

	| edges |
	super justDroppedInto: newOwner event: evt.
	newOwner isScriptEditor ifFalse: [ ^ self ].
	receiver assignIds.
	edges := receiver edgeMorphsConnectingWith: self.
	edges do: [ :each | each updatePosition ].
	(receiver multipleEdgesOf: edges) do: [ :each | 
		each updatePositionDelta: 10 ]
]
