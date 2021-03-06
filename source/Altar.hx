// The altar has the random initialisation, and slots for each thing
// Clicking on a thing adds it to the altar
// If the thing is correct, woohoo!
// Otherwise, things die
package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxRandom;
import flixel.group.FlxTypedGroup;

class Altar extends FlxSprite
{
	private var sequence:Array<String>;
	private var allItems:Array<String>;
	private var places:Array<Place>;
	public var placeGroup:FlxTypedGroup<Place>;
	public function new(X:Float=0, Y:Float=0, itemNames:Array<String>) {
		allItems = itemNames;
		sequence = initSequence();
		trace(sequence);
		super(X, Y);

		places = [for(i in (0...4)) new Place(x+32.5*i, y, sequence[i], i+1)];
		placeGroup = new FlxTypedGroup();

		loadGraphic("assets/images/altar.png");
		setGraphicSize(130, 51);
		updateHitbox();

		for(place in places) {
			placeGroup.add(place);
		}
	}

	private function initSequence():Array<String> {
		var alreadyChosen:Array<Int> = [];
		var chosenItems:Array<String> = [];

		for (i in 0...4)
		{
			var chosenIndex = FlxRandom.intRanged(0, allItems.length-1, alreadyChosen);
			alreadyChosen.push(chosenIndex);
			chosenItems.push(allItems[chosenIndex]);
		}
		return chosenItems;
	}

	public function checkGuess():Array<Int> {
		var totalRightItems:Int = 0;
		var wrongOrderItems:Int = 0;
		//trace(sequence);

		for (place in places) {
			var placedItem:String = place.getPlacedItem();
			//trace(placedItem, place.getName());
			if (sequence.indexOf(placedItem) != -1)
				totalRightItems ++;
			if (placedItem != place.getName())
				wrongOrderItems ++;
		}
		return [totalRightItems, wrongOrderItems];
	}
	public function clear():Void {
		for(place in places) {
			place.clear();
		}
	}
}
