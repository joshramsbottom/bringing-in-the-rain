package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Place extends FlxSprite {
	private var placeName:String;

	public function new(X:Float, Y:Float, placeName:String) {
		this.placeName = placeName;
		super(X, Y);
		makeGraphic(32, 32, FlxColor.AZURE);
	}
	public function getName():String {
		return placeName;
	}
}
