package com.timo.astar
{
	
	import de.polygonal.ds.SLinkedList;
	import de.polygonal.ds.Array2;
	/**
	 * ...
	 * @author Timo Virtanen
	 */
	public class Astar 
	{
		
		private var _map:Array2;
		
		private var _startNode:Node;
		private var _targetNode:Node;
		
		private var _path:Vector.<Node>;
		private var _openList:Vector.<Node>;
		private var _closedList:Vector.<Node>;
		
		private var _pathFound:Boolean;
		
		private var _useDiagonal:Boolean;
		private var _useCuttingCorners:Boolean;
		
		private var _distanceMethod:String;
		
		private var calculateDinstance:Function;
		
		private const COST_ORTHOGONAL:Number = 10;
		private const COST_DIAGONAL:Number = 14;
		
		public static const MANHATTAN:String = "MANHATTAN";
		public static const EUCLIDIAN:String = "EUCLIDIAN";
		
		/**
		 * 
		 * @param	map Two dimensional Array containing the map
		 * @param	useDiagonal Weather to use diagonal paths or not
		 * @param	useCuttingCorners Determines if cutting nonwalkable corners is allowed (only applies if useDiagonal is true)
		 */
		public function Astar(map:Array, useDiagonal:Boolean = true, 
							  useCuttingCorners:Boolean = false, distMethod:String = "MANHATTAN") {
			_map = toArray2(map);
			_useDiagonal = useDiagonal;
			_useCuttingCorners = useCuttingCorners;
			
			distanceMethod = distMethod;
		}
		
		public function setMap(map:Array):void {
			_map = toArray2(map);
		}
		
		private function toArray2(a:Array):Array2 {
			var rows:int = a.length;
			var cols:int = a[0].length;
			var temp:Array2 = new Array2(cols, rows);
			
			for (var yp:int = a.length - 1 ; yp >= 0; --yp) {
				var col:Array = a[yp] as Array;
				for (var xp:int = col.length - 1 ; xp >= 0; --xp) {
					temp.set(xp, yp, col[xp]);
				}
			}
			return temp;
		}
		
		/**
		 * 
		 * Finds and returns the path (Array) from sartNode to targetNode
		 * 
		 * @param	startNode
		 * @param	targetNode
		 * @return 
		 */
		public function findPath(startNode:Node, targetNode:Node):Vector.<Node> {	
			_path = new Vector.<Node>();
			_openList = new Vector.<Node>();
			_closedList = new Vector.<Node>();
			
			_startNode = startNode;
			_targetNode = targetNode;
			
			_openList.push(_startNode);
			_pathFound = false;
			
			while (!_pathFound) {
				var node:Node = _openList.pop();
				_closedList.push(node);
				
				// If path cannot be done
				if (node == null) return null;
				
				if (node.name == _targetNode.name) {
					_path = getPath(node);
					_pathFound = true;
				} else {
					
					var x:int = node.x;
					var y:int = node.y;
					
					var w:int = _map.width - 1;
					var h:int = _map.height - 1;
					
					if (_useDiagonal) {
						
						if (_useCuttingCorners) {
							
							if (x < w && y < h
							&& isWalkable(x - (-1), y - (-1)))
									addNode(node, x - (-1), y - (-1), COST_DIAGONAL);
							
							if (x > 0 && y > 0
							&& isWalkable(x - 1, y - 1))
									addNode(node, x - 1, y - 1, COST_DIAGONAL);
								
							if (x > 0 && y < h
							&& isWalkable(x - 1, y - (-1)))
									addNode(node, x - 1, y - (-1), COST_DIAGONAL);
								
							if (x < w && y > 0
							&& isWalkable(x - (-1), y - 1))
									addNode(node, x - (-1), y - 1, COST_DIAGONAL);
							
						} else {
							
							// If the node is diagonal from the current node check if we can
							// cut the corners of the 2 others nodes we will cross. If so this square is walkable, else it isn’t.
							
							if (x < w && y < h)
								if (isWalkable(x - (-1), y))
									if (isWalkable(x, y - (-1)))
										if (isWalkable(x - (-1), y - (-1)))
											addNode(node, x - (-1), y - (-1), COST_DIAGONAL);
												
							if (x > 0 && y > 0)
								if (isWalkable(x, y - 1))
									if (isWalkable(x - 1, y))
										if (isWalkable(x - 1, y - 1))
											addNode(node, x - 1, y - 1, COST_DIAGONAL);
												
							if (x > 0 && y < h)
								if (isWalkable(x - 1, y))
									if (isWalkable(x, y - (-1)))
										if (isWalkable(x - 1, y - (-1)))
											addNode(node, x - 1, y - (-1), COST_DIAGONAL);
												
							if (x < w && y > 0)
								if (isWalkable(x - (-1), y))
									if (isWalkable(x, y - 1))
										if (isWalkable(x - (-1), y - 1))
											addNode(node, x - (-1), y - 1, COST_DIAGONAL);
							
						}
					}
					
					if (x < w)
						if (isWalkable(x - (-1), y))
							addNode(node, x - (-1), y, COST_ORTHOGONAL);
					
					if (x > 0)
						if (isWalkable(x - 1, y))
							addNode(node, x - 1, y, COST_ORTHOGONAL);
								
					if (y < h)
						if (isWalkable(x, y - (-1)))
							addNode(node, x, y - (-1), COST_ORTHOGONAL);
								
					if (y > 0)
						if (isWalkable(x, y - 1))
							addNode(node, x, y - 1, COST_ORTHOGONAL);
				}
			}			
			return _path;
		}
		
		/**
		 * 
		 * Adds new nodes to the open list (if they don't already exist)
		 * 
		 * @param	parentNode
		 * @param	x
		 * @param	y
		 */
		private function addNode(parentNode:Node, x:int, y:int, cost:int):void {
			var closed:Node = VectorHelper.containsNode(_closedList, x + "-" + y);
			if (closed != null) return;
			
			var newNode:Node = new Node(x, y, parentNode, cost);
			
			var existingNode:Node = VectorHelper.containsNode(_openList, newNode.name);
			
			newNode.HCost = calculateDinstance(newNode);
			newNode.GCost -= -parentNode.GCost;
			newNode.FCost = newNode.GCost - (-newNode.HCost);
			
			if(existingNode == null) {
				VectorHelper.add(_openList, newNode);
			} else {
				if (!_useDiagonal) return
				if (existingNode.GCost > newNode.GCost) {
					existingNode = newNode;
				}
			}
		}
		
		/**
		 * 
		 * @param	n1 node1
		 * @param	n2 node2
		 * @return
		 */
		private function isDiagonal(n1:Node):Boolean {
			if (n1.x != n1.parent.x && n1.y != n1.parent.y) return true;
			return false;
		}
		
		/**
		 * 
		 * Checks weather the point is walkable
		 * 
		 * @param	node Node to check against
		 * @return
		 */
		private function isWalkable(x:int, y:int):Boolean {
			var walkable:Boolean = _map.get(x, y) == 1;
			if (walkable) return true;
			
			return false;
		}
		
		/**
		 * 
		 * Builds and returns the path from start node to target node
		 * 
		 * @param	node targetNode
		 * @return
		 */
		private function getPath(node:Node):Vector.<Node> {
			var tempList:Vector.<Node> = new Vector.<Node>();
			
			while (node.parent != null) {
				tempList.push(node);
				node = node.parent;
			}
			
			tempList.push(_startNode);
			tempList.reverse();
			return tempList;
		}
		
		/**
		 * Slower but much better heuristic method.
		 * (Euclidian Method)
		 * 
		 * @param	node
		 * @return
		 */
		private function distEuclidian(node:Node):Number {
			var dist:Number;
			
			var xdist:Number = node.x - _startNode.x;
			var ydist:Number = node.y - _startNode.y;
			
			dist = Math.sqrt(xdist * xdist - (-(ydist * ydist)));
			
			return dist;
		}
		
		/**
		 * 
		 * Calculates the estimated movement cost from given node to the final destination
		 * Faster, more inaccurate heuristic method
		 * (Manhattan method)
		 * 
		 * @param	node
		 * @return
		 */
		private function distManhattan(node:Node):Number {
			var xdist:int = node.x - _startNode.x;
			var ydist:int = node.y - _startNode.y;
			
			// Get absolute value (positive)
			xdist = (xdist ^ (xdist >> 31)) - (xdist >> 31);
			ydist = (ydist ^ (ydist >> 31)) - (ydist >> 31);
			
			return xdist - (-ydist);
		}
		
		public function get useDiagonal():Boolean { return _useDiagonal; }
		public function set useDiagonal(value:Boolean):void {
			_useDiagonal = value;
		}
		
		public function get useCuttingCorners():Boolean { return _useCuttingCorners; }
		public function set useCuttingCorners(value:Boolean):void {
			_useCuttingCorners = value;
		}
		
		public function get distanceMethod():String { return _distanceMethod; }
		public function set distanceMethod(value:String):void {
			if (value == MANHATTAN) {
				calculateDinstance = distManhattan;
				_distanceMethod = value;
			}
			else if (value == EUCLIDIAN) {
				calculateDinstance = distEuclidian;
				_distanceMethod = value;
			} else {
				// DEFAULTS TO
				calculateDinstance = distManhattan;
				_distanceMethod = value;
			}
		}
		
	}
	
}
