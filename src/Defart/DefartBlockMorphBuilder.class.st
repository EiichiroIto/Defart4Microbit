Class {
	#name : #DefartBlockMorphBuilder,
	#superclass : #BlockMorphBuilder,
	#category : #'Defart-Project'
}

{ #category : #adding }
DefartBlockMorphBuilder >> addCond: aString selector: aSymbol [

	| blockSpec |
	blockSpec := ScratchBlockSpec new
		             label: aString;
		             type: #isCond;
		             selector: aSymbol;
		             arguments: #(  );
		             yourself.
	self registerBlockSpec: blockSpec asCategory: lastCategory
]

{ #category : #adding }
DefartBlockMorphBuilder >> addNode: aString selector: aSymbol named: aString2 [

	| blockSpec |
	blockSpec := ScratchBlockSpec new
		             label: aString;
		             type: #isNode;
		             selector: aSymbol;
		             arguments: { aString2. nil };
		             yourself.
	self registerBlockSpec: blockSpec asCategory: lastCategory
]

{ #category : #adding }
DefartBlockMorphBuilder >> addStartNode: aString selector: aSymbol [

	| blockSpec |
	blockSpec := ScratchBlockSpec new
		             label: aString;
		             type: #isStartNode;
		             selector: aSymbol;
		             arguments: #(  );
		             yourself.
	self registerBlockSpec: blockSpec asCategory: lastCategory
]

{ #category : #'block building' }
DefartBlockMorphBuilder >> blockFromTuple: anArray [

	anArray first = #edge:priority:from:to: ifTrue: [ 
		^ self edgeMorphFromTuple: anArray ].
	"anArray first = #node:id: ifTrue: [ 
		^ self nodeMorphFromTuple: anArray ]."
	^ super blockFromTuple: anArray
]

{ #category : #private }
DefartBlockMorphBuilder >> blockMorphFromSpec: aBlockSpec [

	aBlockSpec type = #isStartNode ifTrue: [ 
		^ StartNodeMorph new ].
	aBlockSpec type = #isNode ifTrue: [ 
		^ DefartNodeMorph new ].
	aBlockSpec type = #isCond ifTrue: [ 
		^ DefartCondMorph new ].
	^ super blockMorphFromSpec: aBlockSpec
]

{ #category : #'block building' }
DefartBlockMorphBuilder >> edgeMorphFromTuple: anArray [

	| fromNode toNode |
	fromNode := script nodeMorphWithId: anArray fourth.
	toNode := script nodeMorphWithId: anArray fifth.
	^ DefartEdgeMorph new
		  receiver: script;
		  id: anArray second;
		  priority: anArray third;
		  fromNode: fromNode;
		  toNode: toNode;
		  yourself
]
