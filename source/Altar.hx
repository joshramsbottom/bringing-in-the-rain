// The altar has the random initialisation, and slots for each thing
// Clicking on a thing adds it to the altar
// If the thing is correct, woohoo!
// Otherwise, things die
package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxRandom;

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

	public function new(X:Float=0, Y:Float=0) {
		sequence = initSequence();
		trace(sequence);
		super(X, Y);
		makeGraphic(300, 100, FlxColor.BLUE);
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
