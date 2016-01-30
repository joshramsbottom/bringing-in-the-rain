package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.plugin.MouseEventManager;
import flash.events.MouseEvent;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var altar:Altar;
	private var items:Array<Item>;
	private var colors:Array<Int>;
	private var currentItem:Item;
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
	private function drag(item:Item):Void {
		// If it's not placed, we can drag it around
		if(!item.getPlaced()) {
			trace(item.getName());
			currentItem = item;
			currentItem.setOffsetX(FlxG.mouse.x-currentItem.x);
			currentItem.setOffsetY(FlxG.mouse.y-currentItem.y);
		}
	}
	private function drop(item:Item):Void {
		// Check if the item is over the altar and only then do we drop it
		if(!FlxG.overlap(item, altar.placeGroup, snapItem)) {
			item.revertPosition();
		}
		currentItem = null;
	}
	private function snapItem(item:Item, place:Place):Void {
		if(!place.getOccupied()) {
			item.x = place.x;
			item.y = place.y;
			item.lockPosition();
			trace("Item "+item.getName()+" dropped on place "+ place.getName());
			item.setPlaced(true);
			place.setOccupied(true);
			place.setPlacedItem(item.getName());
			MouseEventManager.remove(item);
		} else {
			item.revertPosition();
		}
	}

	private function guessCallback() {
		var placedCount:Int = 0;
		for (item in items) {
			if (item.getPlaced()) {
				placedCount ++;
			}
		}
		if (placedCount < 4) {
			FlxG.camera.shake(0.01, 0.05, FlxCamera.SHAKE_HORIZONTAL_ONLY);
		}
		else {
			// The first number is the correct items. The second number is the items in the wrong order
			var guess:Array<Int> = altar.checkGuess();
			trace(guess[0]+" item"+(if(guess[0]==1)""else"s")+" correct, "+guess[1]+" item"+(if(guess[0]==1)""else"s")+" in the wrong order");
			trace(altar.checkGuess());
			clearAltar();
		}
	}
	private function clearAltar():Void {
		altar.clear();
		for(item in items) {
			item.clear();
			MouseEventManager.add(item, drag, drop);
		}
	}

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		// Here we need to set up an altar with four spaces, 
		//a random selection of the nine items, 
		//and nine items which the user will click on
		colors = [0xffff0000, 0xffffdd00, 0xffffff00, 0xffddff00, 0xff00ff00, 0xff00ffff, 0xff00ddff, 0xff0000ff, 0xffdd00ff, 0xffff00ff];
		altar = new Altar(300, 300, allItems);
		add(altar);
		add(altar.placeGroup);
		currentItem = null;
		FlxG.plugins.add(new MouseEventManager());
		items = [for (i in (0...9)) new Item(300+50*i, 450, colors[i], allItems[i])];
		for(item in items) {
			MouseEventManager.add(item, drag, drop);
			add(item);
		}

		var guessButton:FlxButton = new FlxButton(700, 500, "Sacrifice", guessCallback);
		add(guessButton);

		super.create();
		// 
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		// This handles dragging functionality
		if(currentItem!=null) {
			currentItem.x = FlxG.mouse.x-currentItem.getOffsetX();
			currentItem.y = FlxG.mouse.y-currentItem.getOffsetY();
		}
		super.update();
	}	
}
