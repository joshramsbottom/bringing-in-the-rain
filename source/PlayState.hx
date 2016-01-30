package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxRandom;
import flixel.plugin.MouseEventManager;
import flash.events.MouseEvent;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var levelSprites:FlxSpriteGroup = new FlxSpriteGroup();
	private var characterSprites:FlxSpriteGroup = new FlxSpriteGroup();
	private var effectsSprites:FlxSpriteGroup = new FlxSpriteGroup();
	private var altar:Altar;
	private var items:Array<Item> = [];
	private var currentItem:Item;
	private var godlyRays:TiledLevelObject;
	private var allItems:Array<String> = [
		"first_born",
		"idol",
		"skull",
		"ps4",
		"wheat",
		"lamb",
		"gold",
		"bread",
		"fruit_basket"
	];
	private var rain:Array<String> = [
		"no rain",
		"drizzle",
		"light rain",
		"medium rain",
		"lots of rain!"
	];
	private var plagueCount:Int = 0;
	private var plagues:Array<String> = [
		"Frogs rain from the skies.",
		"Locusts ravage your crops.",
		"The river floods, washing away your homes.",
		"The river turns to blood.",
		"There is an earthquake. Your houses crumble to dust",
		"There is a tornado. Your houses are blown away",
		"Pestilence ravages your village.",
		"Wolves attack your village.",
		"A rival village raids your crops.",
		"An arrow shoots down your greatest warrior",
		"An alien abducts your firstborn"
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
		if(!place.getOccupied() && !item.getPlaced()) {
			item.x = place.x;
			item.y = place.y;
			item.lockPosition();
			item.setPlaced(true);
			place.setOccupied(true);
			place.setPlacedItem(item.getName());
			MouseEventManager.remove(item);
		} else {
			item.revertPosition();
		}
		godlyRays.kill();
	}
	private function toggleGodlyRays(item:Item, place:Place):Void {
		// This may not be 100%
		if(!place.getOccupied() && !item.getPlaced()) {
			godlyRays.reset(place.x, place.y-190+32);
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
			var correctItems:Int = guess[0];
			var wrongOrder:Int = guess[1];
			trace(correctItems+" item"+(if(correctItems==1)""else"s")+" correct, "+wrongOrder+" item"+(if(wrongOrder==1)""else"s")+" in the wrong order");
			// The win condition is when there are 4 correct items and none in the wrong order (rain, double rainbows, and growing crops)
			// The more correct items there are, the more rain there is
			// If there are items in the wrong order, something bad happens
			// If all the bad things happen, the Gods get angry with you and your village gets destroyed
			trace(rain[correctItems]);
			if(wrongOrder==0) {
				FlxG.switchState(new WinState());
			}
			else {
				trace(badStuff());
				plagueCount++;
				if(plagueCount >= 4) { // Set this to something like 15
					FlxG.switchState(new LoseState());
				}
			}
			//trace(altar.checkGuess());
			clearAltar();
		}
	}
	private function badStuff():String {
		return FlxRandom.getObject(plagues);
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
		altar = new Altar(136, 166, allItems);
		levelSprites.add(altar);
		for (place in altar.placeGroup)
			characterSprites.add(place);
		currentItem = null;
		FlxG.plugins.add(new MouseEventManager());
		for(i in(0...9)) {
			if(i<5) {
				items.push(new Item(99+42*i, 223, allItems[i]));
			}
			else {
				items.push(new Item(119+42*(i-5), 257, allItems[i]));
			}
		}
		for(item in items) {
			MouseEventManager.add(item, drag, drop);
			characterSprites.add(new LevelObject(item.x, item.y, "item_ring.png", 32, 32));
			characterSprites.add(new LevelObject(item.x+4, item.y+12, "item_shadow.png", 23, 14));
			characterSprites.add(item);
		}

		// Add other level sprites
		var hutsSprite = new LevelObject(98, 55, "huts.png", 201, 101);
		levelSprites.add(hutsSprite);
		var cropsSprite = new LevelObject(346, 110, "crops.png", 52, 60);
		levelSprites.add(cropsSprite);
		var sheepSprite = new LevelObject(0, 106, "sheep.png", 88, 55);
		levelSprites.add(sheepSprite);
		var fenceSprite = new LevelObject(0, 106, "fence.png", 88, 55);
		levelSprites.add(fenceSprite);
		var riverSprite = new TiledLevelObject(325, 108, "river.png", 75, 100);
		riverSprite.frame = riverSprite.framesData.frames[3]; // This looks too clunky
		levelSprites.add(riverSprite);
		var leftVillager = new LevelObject(122, 103, "villager_small.png", 15, 38);
		levelSprites.add(leftVillager);
		var rightVillager = new LevelObject(264, 110, "villager_small.png", 15, 38, true);
		levelSprites.add(rightVillager);
		var bigVillager = new LevelObject(280, 111, "villager_nude.png", 31, 68, true);
		levelSprites.add(bigVillager);
		var leader = new LevelObject(85, 91, "villager_tribal.png", 29, 71);
		levelSprites.add(leader);
		godlyRays = new TiledLevelObject(0, 0, "god_rays.png", 32, 190);
		godlyRays.animation.add("sparkle", [0,1,2,3,4,5], 6, true);
		godlyRays.animation.play("sparkle");
		characterSprites.add(godlyRays);
		godlyRays.kill();
		// Altar: 136, 166
		// Crops: 346, 110
		// Sheep: 0, 106
		// Fence: 0,, 106
		// Left small villager: 122, 103
		// Right small villager: 264, 111
		// Big villager: 280, 111
		// Leader: 85, 91
		// River: 325, 108

		// Item 0: 99, 223
		// Item 1: 141, 223 (99+42)
		// Item 2: 183, 223 
		// Item 3: 225, 223 
		// Item 4: 267, 223 
		// Item 5: 119, 257
		

		// Add background sprite
		var bgSprite:FlxSprite = new FlxSprite();
		bgSprite.loadGraphic("assets/images/background.png");
		bgSprite.setGraphicSize(400, 300);
		bgSprite.updateHitbox();

		// Add sprites in correct order
		add(bgSprite);
		add(levelSprites);
		add(characterSprites);

		var guessButton:FlxButton = new FlxButton(320, 250, "Sacrifice", guessCallback);
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
			if(!FlxG.overlap(currentItem, altar.placeGroup, toggleGodlyRays)) {
				godlyRays.kill();
			}
		}
		super.update();
	}	
}
