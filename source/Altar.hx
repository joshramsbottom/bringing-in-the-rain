// The altar has the random initialisation, and slots for each thing
// Clicking on a thing adds it to the altar
// If the thing is correct, woohoo!
// Otherwise, things die
package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Altar extends FlxSprite
{
	private var sequence:Array<Int>;
	public function new(X:Float=0, Y:Float=0) {
		sequence = [1,2,3,4];
		super(X, Y);
		makeGraphic(300, 100, FlxColor.BLUE);
	}
}
