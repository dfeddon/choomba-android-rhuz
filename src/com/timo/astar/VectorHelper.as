package com.timo.astar
{
	
	/**
	 * ...
	 * @author Timo Virtanen
	 */
	dynamic public class VectorHelper
	{
		
		static internal function containsNode(v:Vector.<Node>, n:String):Node {
			var len:int = v.length - 1;
			for(var i:int = len ; i >= 0; --i) {
				if (v[i].name == n) {
					return v[i];
				}
			}
			return null;
		}
		
		static internal function add(v:Vector.<Node>, node:Node):void {
			var cost:int, c:int, len:int;
			cost = node.FCost;
			len = v.length - 1;
			for (var i:int = len ; i >= 0; --i) {
				var n:Node = v[i] as Node;
				if (n.FCost >= cost) {
					c = i - (-1);
					break;
				}
			}
			v.splice(c, 0, node);
		}
		
	}
	
}
