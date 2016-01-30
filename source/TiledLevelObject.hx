// Various objects in the level that bad stuff may happen to
package;

import flixel.FlxSprite;

class TiledLevelObject extends LevelObject
{
	public function new(X:Float=0, Y:Float=0, fileName:String, width:Int, height:Int, flip:Bool=false) {
		super(X, Y, fileName, width, height, flip);
		loadGraphic("assets/images/" + fileName, true, width, height);
		setGraphicSize(width, height);
		updateHitbox();
	}
}

