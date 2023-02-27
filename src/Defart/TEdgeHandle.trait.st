Trait {
	#name : #TEdgeHandle,
	#category : #'Defart-Blocks'
}

{ #category : #adding }
TEdgeHandle >> addEdgeHandle [

	self addMorphBack: self newIconMorph
]

{ #category : #accessing }
TEdgeHandle >> id [

	^ self nodeHandleArg id
]

{ #category : #accessing }
TEdgeHandle >> id: anObject [

	self nodeHandleArg id: anObject.
	self
		layoutChanged;
		fixBlockLayout
]

{ #category : #'instance creation' }
TEdgeHandle >> newEdge [

	^ DefartEdgeMorph new
]

{ #category : #'instance creation' }
TEdgeHandle >> newIconMorph [

	^ DefartNodeHandleArgMorph new
]

{ #category : #private }
TEdgeHandle >> nodeHandleArg [

	^ self submorphThat: [ :each | each isKindOf: DefartNodeHandleArgMorph ] ifNone: [ nil ]
]
