package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Place extends LevelObject {
	private var placeName:String;
	private var placedItem:String;
	private var occupied:Bool;

	public function new(X:Float, Y:Float, placeName:String, index:Int) {
		occupied = false;
		this.placeName = placeName;
		super(X, Y, "place_"+index+".png", 32, 32);
		//makeGraphic(32, 32);
		//setGraphicSize(32, 32);
		//updateHitbox();
		//offset.set(-32, 0);
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
	public function getOccupied():Bool {
		return occupied;
	}
	public function setOccupied(occupied:Bool):Void {
		this.occupied = occupied;
	}
	public function clear():Void {
		placedItem = null;
		occupied = false;
	}
}
