Class {
	#name : #DefartEdgeIdArgMorph,
	#superclass : #ArgMorph,
	#category : #'Defart-Blocks'
}

{ #category : #accessing }
DefartEdgeIdArgMorph >> defaultValue: anInteger [

	owner ifNil: [ ^ self ].
	owner setEdgeWithId: anInteger
]

{ #category : #evaluation }
DefartEdgeIdArgMorph >> evaluate [

	^ self id
]

{ #category : #private }
DefartEdgeIdArgMorph >> fixArgLayout [

	self extent: 5 @ 5
]

{ #category : #accessing }
DefartEdgeIdArgMorph >> id [

	owner ifNil: [ ^ 0 ].
	^ owner id
]

{ #category : #initialization }
DefartEdgeIdArgMorph >> initialize [

	super initialize.
	self color: Color transparent.
	self borderWidth: 0
]

{ #category : #accessing }
DefartEdgeIdArgMorph >> labelMorph [

	^ 0
]
