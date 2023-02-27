Class {
	#name : #DefartArgMorphBuilder,
	#superclass : #ArgMorphBuilder,
	#category : #'Defart-Project'
}

{ #category : #adding }
DefartArgMorphBuilder >> addEdgeIdArg: aCharacter [

	self
		add: aCharacter
		builder: [ DefartEdgeIdArgMorph new ]
]

{ #category : #adding }
DefartArgMorphBuilder >> addNodeHandleArg: aCharacter [

	self
		add: aCharacter
		builder: [ DefartNodeHandleArgMorph new ]
]

{ #category : #adding }
DefartArgMorphBuilder >> addNodeNameArg: aCharacter [

	self
		add: aCharacter
		builder: [ DefartNodeNameArgMorph new ]
]
