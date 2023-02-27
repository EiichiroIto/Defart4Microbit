Trait {
	#name : #TGraphObject,
	#category : #'Defart-Blocks'
}

{ #category : #'dropping/grabbing' }
TGraphObject >> justDroppedInto: newOwner event: evt [

	super justDroppedInto: newOwner event: evt.
	newOwner isScriptEditor ifFalse: [ ^ self ].
	self traceCr: self.

]
