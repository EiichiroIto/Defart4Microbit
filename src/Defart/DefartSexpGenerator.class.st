Class {
	#name : #DefartSexpGenerator,
	#superclass : #ScratchSexpGenerator,
	#category : #'Defart-Converter'
}

{ #category : #'as yet unclassified' }
DefartSexpGenerator >> generateNodeBegin: aMorph [

	^ self generateBegin: #state:id: morph: aMorph
]

{ #category : #'as yet unclassified' }
DefartSexpGenerator >> generateNodeEnd: aMorph [

	^ self generateEnd: nil morph: aMorph
]
