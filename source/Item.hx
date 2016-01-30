// An Item
// The item has a click handler. On the main PlayState thing, we have a 
// function that moves the item and adds the item to the altar
package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flash.events.EventDispatcher;

class Item extends FlxSprite
{
	private var name:String;

	private var originX:Float;
	private var originY:Float;
	private var oldX:Float;
	private var oldY:Float;
	private var offsetX:Float;
	private var offsetY:Float;
	private var placed:Bool;
	public function new(X:Float=0, Y:Float=0, color:Int=FlxColor.WHITE, name:String="unknown") {
		placed = false;
		originX = X;
		originY = Y;
		oldX = X;
		oldY = Y;
		offsetX = 0;
		offsetY = 0;
		this.name = name;
		super(X, Y);
		makeGraphic(32, 32, color);
	}
	public function setOffsetX(x:Float):Void {
		this.offsetX = x;
	}
	public function setOffsetY(y:Float):Void {
		this.offsetY = y;
	}
	public function getOffsetX():Float {
		return this.offsetX;
	}
	public function getOffsetY():Float {
		return this.offsetY;
	}
	public function getName():String {
		return this.name;
	}
	public function setPlaced(placed:Bool):Void {
		this.placed = placed;
	}
	public function getPlaced():Bool {
		return this.placed;
	}
	public function lockPosition():Void {
		this.oldX = this.x;
		this.oldY = this.y;
	}
	public function revertPosition():Void {
		this.x = this.oldX;
		this.y = this.oldY;
	}
	public function clear():Void {
		this.x = this.originX;
		this.y = this.originY;
		this.placed = false;
		this.lockPosition();
	}
}
