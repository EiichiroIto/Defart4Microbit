Class {
	#name : #DefartNodeHandleArgMorph,
	#superclass : #ArgMorph,
	#category : #'Defart-Blocks'
}

{ #category : #accessing }
DefartNodeHandleArgMorph >> defaultValue: anObject [

	self id: anObject
]

{ #category : #evaluation }
DefartNodeHandleArgMorph >> evaluate [

	^ self id
]

{ #category : #'event handling' }
DefartNodeHandleArgMorph >> handlesMouseDown: evt [

	^ true
]

{ #category : #accessing }
DefartNodeHandleArgMorph >> id [

	^ labelMorph contents asNumberNoError
]

{ #category : #accessing }
DefartNodeHandleArgMorph >> id: anObject [

	| block |
	labelMorph
		contents: anObject asString;
		position: self position + borderWidth + (3 @ -1).
	self extent: labelMorph extent + (16 @ 2) + borderWidth.
	(block := self meOrOwnerThatIsA: HatBlockMorph) ifNotNil: [ 
		block fixBlockLayout ]
]

{ #category : #initialization }
DefartNodeHandleArgMorph >> initialize [

	super initialize.
	self
		useRoundedCorners;
		color: ScratchTheme variableBlockColor darker;
		borderWidth: 0;
		extent: 13 @ 13.
	labelMorph := StringMorph new
		              font: ScratchTranslator argFont;
		              color: Color white.
	self addMorph: labelMorph.
	self id: 0
]

{ #category : #'event handling' }
DefartNodeHandleArgMorph >> mouseDown: evt [

	| edge morph |
	morph := self scriptEditorIfNil: [ ^ self ].
	edge := owner newEdge.
	edge
		setup;
		receiver: owner receiver;
		verticesAt: 2 put: evt cursorPoint;
		fromNode: owner;
		updatePosition.
	edge center: self center.
	morph addMorphFront: edge.
	evt hand newMouseFocus: edge lastHandleMorph
]

{ #category : #private }
DefartNodeHandleArgMorph >> scriptEditorIfNil: aBlock [

	| morph |
	owner ifNil: aBlock.
	morph := owner scriptEditor.
	morph ifNil: aBlock.
	^ morph
]
