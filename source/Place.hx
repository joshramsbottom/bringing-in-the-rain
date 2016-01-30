package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Place extends FlxSprite {
	private var placeName:String;
	private var placedItem:String;

	public function new(X:Float, Y:Float, placeName:String) {
		this.placeName = placeName;
		super(X, Y);
		makeGraphic(32, 32, FlxColor.AZURE);
	}
	public function getName():String {
		return placeName;
	}

	public function getPlacedItem():String {
		return placedItem;
	}

	public function setPlacedItem(name:String) {
		placedItem = name;
	}
}
