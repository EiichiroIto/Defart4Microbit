Class {
	#name : #DefartBlockParser,
	#superclass : #ScratchBlockParser,
	#category : #'Defart-Process'
}

{ #category : #'code generator' }
DefartBlockParser >> emitCond: aDefartCondMorph indent: anInteger [

	^ aDefartCondMorph reporterMorph ifNotNil: [ :morph | 
		morph parseUsing: self ]
]

{ #category : #'code generator' }
DefartBlockParser >> emitNodeBlock: aMorph indent: indent [

	((generator isKindOf: ScratchSexpGenerator) or: [ generator withDef ])
		ifTrue: [ 
			generator generateNodeBegin: aMorph.
			aMorph nestedBlock
				ifNil: [ self emitPassIndent: indent + 1 ]
				ifNotNil: [ self emitCode: aMorph nestedBlock indent: indent + 1 ].
			generator generateNodeEnd: aMorph ]
		ifFalse: [ 
			aMorph nestedBlock ifNotNil: [ 
				self emitCode: aMorph nestedBlock indent: indent ] ]
]

{ #category : #'code generator' }
DefartBlockParser >> emitStartNodeBlock: aStartNodeMorph indent: anInteger [

	aStartNodeMorph nextBlock ifNotNil: [ 
		self emitCode: aStartNodeMorph nextBlock indent: anInteger ]
]
