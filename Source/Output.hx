package ;
import flash.events.Event;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.Lib;
import Type;
/**
 * ...
 * @author Thomas B
 */
class Output extends Sprite
{
	
	public var type : ValueType;
	public var value : Dynamic;
	public var node : Node;
	
	var _line : Connection;
	var _pressed : Bool;
	
	var _connections : Array<Connection>;

	public function new(name : String, type : ValueType) 
	{
		super();
		this.name = name;
		this.type = type;
		
		graphics.beginFill(0xffcc33);
		graphics.drawCircle(0, 0, 5);
		graphics.endFill();
		
		buttonMode = true;
		useHandCursor = true;
		
		_connections = new Array<Connection>();
		
		addEventListener(MouseEvent.MOUSE_DOWN, onPress);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, onRelease);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		
		this.mouseChildren = false;
	}
	
	public function updateConnections() {
		for (connection in _connections)
			connection.update();
	}
	
	private function onMouseMove(e:MouseEvent):Void 
	{
		if(_pressed){
			_line.grab(cast e.stageX,cast e.stageY);
		}
	}
	
	private function onRelease(e:MouseEvent):Void 
	{
		if (_pressed) {
			var target : Dynamic = e.target;
			if (Std.is(target, Input)) {
				var input : Input = target;
				if (input.type == type){
					input.connect(this, _line);
					_connections.push(_line);
					_line.setInput(input);
				}
				else{
					node.graph.removeConnection(_line);
					_line = null;
				}
			}else {
				node.graph.removeConnection(_line);
				_line = null;
			}
		}
		_pressed = false;
	}
	
	private function onPress(e:MouseEvent):Void 
	{
		_line = node.graph.addConnection(this, null);
		_pressed = true;
	}
	
	public function set(value : Dynamic) {
		this.value = value;
	}
	
}