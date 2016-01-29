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
	private var allItems:Array<String> = [
		"lamb",
		"firstBorn",
		"haybale",
		"twigBundle",
		"goldIngot",
		"fruit",
		"bread",
		"idol",
		"skull"
	];

	private var sequence:Array<Int>;
	private var places:Array<FlxSprite>;
	public var placeGroup:FlxTypedGroup<FlxSprite>;
	public function new(X:Float=0, Y:Float=0) {
		sequence = initSequence();
		trace(sequence);
		places = [for(i in (1...5)) new FlxSprite(300+50*i, 350)];
		placeGroup = new FlxTypedGroup();
		super(X, Y);
		makeGraphic(300, 100, FlxColor.BLUE);
		for(place in places) {
			place.makeGraphic(32, 32, FlxColor.AZURE);
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
