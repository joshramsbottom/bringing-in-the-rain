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

	public var oldX:Float;
	public var oldY:Float;
	private var offsetX:Float;
	private var offsetY:Float;
	public function new(X:Float=0, Y:Float=0, color:Int=FlxColor.WHITE) {
		oldX = X;
		oldY = Y;
		offsetX = 0;
		offsetY = 0;
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
}
