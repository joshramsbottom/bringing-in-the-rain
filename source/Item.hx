// An Item
// The item has a click handler. On the main PlayState thing, we have a 
// function that moves the item and adds the item to the altar
package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Item extends FlxSprite
{
	private var name:String;

	public function new(X:Float=0, Y:Float=0, color:Int=FlxColor.WHITE) {
		super(X, Y);
		makeGraphic(32, 32, color);
	}
}
