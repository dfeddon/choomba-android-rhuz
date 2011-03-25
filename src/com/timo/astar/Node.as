package com.timo.astar
{
	
	/**
	 * ...
	 * @author Timo Virtanen
	 */
	public class Node 
	{
		
		public var x:int, y:int, name:String;
		internal var FCost:int, GCost:int, HCost:Number, parent:Node;
		
		public function Node(x:int = 0, y:int = 0, parent:Node = null, GCost:int = 0) {
			this.x = x; this.y = y;
			this.name = x + "-" + y;
			this.parent = parent
			this.GCost = GCost;
		}
		
	}
	
}
