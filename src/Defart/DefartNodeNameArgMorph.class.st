Class {
	#name : #DefartNodeNameArgMorph,
	#superclass : #ArgMorph,
	#category : #'Defart-Blocks'
}

{ #category : #accessing }
DefartNodeNameArgMorph >> defaultValue: anObject [

	self nodeName: anObject
]

{ #category : #accessing }
DefartNodeNameArgMorph >> evaluate [

	^ labelMorph savedContents
]

{ #category : #accessing }
DefartNodeNameArgMorph >> fixArgLayout [

	self extent: labelMorph extent + (2 @ 0).
	labelMorph position: self left + 3 @ self top
]

{ #category : #initialization }
DefartNodeNameArgMorph >> initialize [

	super initialize.
	self borderWidth: 1.
	self borderInset.
	self color: ScratchTheme blockArgColor.
	self extent: 25 @ 12.
	labelMorph := StringFieldMorph new
		              font: ScratchTranslator argFont;
		              color: Color transparent.
	self addMorph: labelMorph.
	self nodeName: ''
]

{ #category : #accessing }
DefartNodeNameArgMorph >> loseKeyboardFocus [

	labelMorph keyboardFocusChange: false
]

{ #category : #accessing }
DefartNodeNameArgMorph >> nodeName [

	^ labelMorph contents
]

{ #category : #accessing }
DefartNodeNameArgMorph >> nodeName: aString [

	labelMorph isNumeric: false.
	labelMorph contents: aString.
	self fixArgLayout
]
