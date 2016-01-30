// The altar has the random initialisation, and slots for each thing
// Clicking on a thing adds it to the altar
// If the thing is correct, woohoo!
// Otherwise, things die
package;

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
		places = [for(i in (0...4)) new Place(350+50*i, 350, sequence[i])];
		placeGroup = new FlxTypedGroup();
		super(X, Y);
		makeGraphic(300, 100, FlxColor.BLUE);
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
}
