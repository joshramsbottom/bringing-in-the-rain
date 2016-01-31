// Various objects in the level that bad stuff may happen to
package;

import flixel.FlxSprite;

class LevelObject extends FlxSprite
{
	public function new(X:Float=0, Y:Float=0, fileName:String, width:Int, height:Int, flip:Bool=false) {
		super(X, Y);
		flipX = flip;
		loadGraphic("assets/images/" + fileName);
		setGraphicSize(width, height);
		updateHitbox();
	}
}
