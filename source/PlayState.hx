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
import flixel.util.FlxTimer;
import flixel.util.FlxRandom;
import flixel.tweens.FlxTween;
import flixel.plugin.MouseEventManager;
import flash.events.MouseEvent;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var soundManager:SoundManager;
	private var backgroundSprites:FlxSpriteGroup = new FlxSpriteGroup();
	private var levelSprites:FlxSpriteGroup = new FlxSpriteGroup();
	private var characterSprites:FlxSpriteGroup = new FlxSpriteGroup();
	private var effectsSprites:FlxSpriteGroup = new FlxSpriteGroup();
	private var raindropSprites:FlxSpriteGroup = new FlxSpriteGroup();
	private var altar:Altar;
	private var items:Array<Item> = [];
	private var raindrops:Array<Raindrop>;
	private var currentItem:Item;
	private var godlyRays:TiledLevelObject;
	private var bigVillager:TiledLevelObject;
	private var leader:TiledLevelObject;
	private var rainbow:TiledLevelObject;
	private var hutFire:TiledLevelObject;
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
	private var plagueCount:Int = 0;
	private var badThings:Array<EffectObject> = [];/* = [
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
	];*/
	private var clouds:Array<LevelObject> = [];
	private var shakeIntensity:Float = 0.02;
	private var rainState:Int = 0;
	private var stormState:Int = 2;
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
		} else {
			// Check whether all four items have been droped
			var allOccupied = true;
			for(place in altar.placeGroup.members) {
				if(!place.getOccupied()) {
					allOccupied = false;
				}
			}
			if(allOccupied) {
				trace("The Gods want sacrifice!");
				// Wait half a second and then do a thing
				var timer = new FlxTimer(0.5, guessCallback);
			}
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
		}
		else {
			item.revertPosition();
		}
		godlyRays.kill();
	}
	private function toggleGodlyRays(item:Item, place:Place):Void {
		// This may not be 100%
		// The third place seems dodgy
		if(!place.getOccupied() && !item.getPlaced()) {
			godlyRays.reset(place.x, place.y-190+22);
		}
		// We only kill if it's not occupied to avoid a race condition
		else if(!place.getOccupied()){
			godlyRays.kill();
		}
	}

	private function guessCallback(timer:FlxTimer):Void {
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
			createRain(correctItems);
			updateClouds(correctItems, wrongOrder);
			if(wrongOrder==0) {
				rainbow.animation.play("win");
				rainbow.visible = true;
				var _winText = new FlxText(150, 150, 150, "The Gods are happy with your sacrifice. You get double rainbows and your crops prosper. You win.", 10);
				add(_winText);
				var _btnPlay = new FlxButton(175, 250, "Play again", clickPlay);
				add(_btnPlay);
				//FlxG.switchState(new WinState());
			}
			else {
				badStuff();
			}
			clearAltar();
		}
	}
	private function createRain(correct:Int):Void {
		var speeds = [1, 1.5, 2, 4];
		for(i in (0...200)) {
			raindrops[i].kill();
		}
		for(i in (0...correct*50)) {
			raindrops[i].setSpeed(speeds[correct-1]);
			raindrops[i].play();
		}
	}

	private function clickPlay():Void {
		FlxG.switchState(new PlayState());
	}


	private function updateClouds(correct:Int, wrongOrder:Int) {
		if (correct == 0)
		{
			for (i in 0...3) {
				FlxTween.linearMotion(clouds[i], clouds[i].x, clouds[i].y, clouds[i].x, -30, 1);
			}
		}
		if (rainState == 0 && correct > 0)
		{
			for (i in 0...3) {
				FlxTween.linearMotion(clouds[i], clouds[i].x, clouds[i].y, clouds[i].x, -10 + (i*10), 1);
			}
		}

		var change:Int = cast(Math.abs(stormState - wrongOrder), Int);
		if (wrongOrder > stormState) {
			for (cloud in clouds) {
				FlxTween.color(cloud, 2, cloud.color, darken(cloud.color, change));
			}
		}
		else if (wrongOrder < stormState) {
			for (cloud in clouds) {
				FlxTween.color(cloud, 2, cloud.color, lighten(cloud.color, change));
			}
		}

		rainState = correct;
		stormState = wrongOrder;
	}

	private function darken(colour:Int, change:Int) {
		return colour >> change;
	}

	private function lighten(colour:Int, change:Int) {
		return colour << change;
	}

	private function checkBadThing(timer:FlxTimer):Void {
		plagueCount++;
		if(plagueCount >= 8) {
			bigVillager.animation.play("giveup");
			leader.animation.play("giveup");
			hutFire.visible = true;
			var _loseText = new FlxText(150, 150, 150, "The Gods are angry with your sacrifice. Your village burns to the ground. Blood rains from the skies and the sharknado destroys your crops. You die.", 10);
			add(_loseText);
			var _btnPlay = new FlxButton(175, 250, "Play again", clickPlay);
			add(_btnPlay);
		}
		var chosenEffect:EffectObject = FlxRandom.getObject(badThings);
		chosenEffect.play("anim");
		if (chosenEffect.getName() == "earthquake") {
			var shakeTimer = new FlxTimer();
			shakeTimer.start(1, keepShaking, 3);
		}
		badThings.remove(chosenEffect);
	}
	private function badStuff():Void {
		// altar + (3, 32)
		// altar + (18, 32)
		// altar + (33, 32)
		var x = altar.x + 4;
		var y = altar.y + 31;
		// This is very slightly off.
		var altarBlood = new TiledLevelObject(x+15*plagueCount, y, "altar_blood.png", 16, 16);
		altarBlood.animation.add("spill", [for (i in (0...17)) i], 17, false);
		levelSprites.add(altarBlood);
		altarBlood.animation.play("spill");
		// Wait 1s for the animation to complete
		var timer = new FlxTimer(1, checkBadThing);
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
		rainbow = new TiledLevelObject(130, 26, "rainbow.png", 147, 85);
		rainbow.animation.add("win", [0,1,2,3,4,5,6,7,8,9,10,11], 6, false);
		rainbow.visible = false;
		levelSprites.add(rainbow);

		var hutsSprite = new LevelObject(98, 56, "huts.png", 201, 101);
		levelSprites.add(hutsSprite);

		hutFire = new TiledLevelObject(90, 45, "fire.png", 215, 86);
		hutFire.animation.add("lose", [0,1,2,3], 6, true);
		hutFire.animation.play("lose");
		hutFire.visible = false;
		levelSprites.add(hutFire);

		var cropsSprite = new EffectObject(346, 94, 346, 94, "swarm", "locust_swarm.png", 59, 81);
		cropsSprite.frame = cropsSprite.framesData.frames[0];
		cropsSprite.animation.add("anim", [for (i in (1...24)) i], 8, false);
		badThings.push(cropsSprite);
		levelSprites.add(cropsSprite);

		var sheepSprite = new EffectObject(0, 72, 0, 72, "sheep", "sheep.png", 88, 108);
		sheepSprite.frame = sheepSprite.framesData.frames[0];
		sheepSprite.animation.add("anim", [for (i in (1...38)) i], 8, false);
		badThings.push(sheepSprite);
		levelSprites.add(sheepSprite);
		var fenceSprite = new LevelObject(0, 106, "fence.png", 88, 55);
		levelSprites.add(fenceSprite);
		var leftVillager = new TiledLevelObject(122, 103, "villager_small.png", 29, 38);
		levelSprites.add(leftVillager);

		var rightVillager = new TiledLevelObject(264, 110, "villager_small.png", 29, 38, true);
		levelSprites.add(rightVillager);

		bigVillager = new TiledLevelObject(280, 111, "villager_nude.png", 48, 96);
		bigVillager.animation.add("idle", [for (i in (0...50)) i], 5, true);
		bigVillager.animation.add("giveup", [for(i in (40...52)) i], 12, false);
		levelSprites.add(bigVillager);
		bigVillager.animation.play("idle");

		leader = new TiledLevelObject(85, 91, "villager_tribal.png", 48, 96);
		leader.animation.add("idle", [for (i in (0...40)) i], 5, true);
		leader.animation.add("giveup", [for(i in (40...52)) i], 12, false);

		var ufo = new EffectObject(0, 20, 0, 20, "ufo", "ufo.png", 121, 101);
		ufo.frame = ufo.framesData.frames[0];
		ufo.animation.add("anim", [for (i in (0...38)) i], 10, false);
		badThings.push(ufo);
		levelSprites.add(ufo);

		levelSprites.add(leader);
		leader.animation.play("idle");

		var cloudSprite1 = new LevelObject(-10, -30, "clouds_1.png", 448, 28);
		clouds.push(cloudSprite1);
		var cloudSprite2 = new LevelObject(-10, -30, "clouds_2.png", 448, 28, true);
		clouds.push(cloudSprite2);
		var cloudSprite3 = new LevelObject(-10, -30, "clouds_3.png", 448, 28);
		clouds.push(cloudSprite3);
		effectsSprites.add(cloudSprite3);
		effectsSprites.add(cloudSprite2);
		effectsSprites.add(cloudSprite1);

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

		// Add effects sprites
		var riverSprite = new EffectObject(325, 108, 325, 108, "river", 1, "river.png", 75, 100);
		riverSprite.frame = riverSprite.framesData.frames[3]; // This looks too clunky
		riverSprite.animation.add("anim", [3,2,1,0], 1, false);
		badThings.push(riverSprite);
		effectsSprites.add(riverSprite);

		var tornado = new EffectObject(390, 10, -80, 10, "tornado", 6, "tornado.png", 83, 119, "wind");
		tornado.animation.add("anim", [0,1,2,3,4], 10, true);
		tornado.kill();
		effectsSprites.add(tornado);
		badThings.push(tornado);

		var earthquake = new EffectObject(50, 205, 50, 205, "earthquake", "fissure_crack.png", 40, 94);
		earthquake.animation.add("anim", [0,1,2,3], 1, false);
		earthquake.kill();
		effectsSprites.add(earthquake);
		badThings.push(earthquake);

		var frog = new EffectObject(400, 220, 355, 220, "frog", 0.5, "jumping_frog.png", 20, 32);
		frog.animation.add("anim", [9,8,7,6,5], 10, false);
		frog.kill();
		effectsSprites.add(frog);
		badThings.push(frog);

		var lightning = new EffectObject(206, 12, 206, 12, "lightning", 0.5, "lightning_bolt.png", 31, 92);
		lightning.kill();
		lightning.animation.add("anim", [0, 1], 2, true);
		effectsSprites.add(lightning);
		badThings.push(lightning);

		// Add background sprite
		var bgSprite:FlxSprite = new FlxSprite();
		bgSprite.loadGraphic("assets/images/background.png");
		bgSprite.setGraphicSize(400, 300);
		bgSprite.updateHitbox();
		backgroundSprites.add(bgSprite);
		// Add the rain
		raindrops = [];
		for(i in (0...200)) {
			var startX = FlxRandom.intRanged(0, 700);
			var endY = FlxRandom.intRanged(117, 300);
			var endX = startX-endY; // The raindrops fall 45 degrees
			var raindrop = new Raindrop(startX, 0, endX, endY, FlxRandom.floatRanged(1, 4));
			raindropSprites.add(raindrop);
			raindrop.kill();
			raindrops.push(raindrop);
		}

		// Add sprites in correct order
		add(backgroundSprites);
		add(effectsSprites);
		add(levelSprites);
		add(characterSprites);
		add(raindropSprites);

		// Add sounds
		soundManager = new SoundManager();
		//var guessButton:FlxButton = new FlxButton(320, 250, "Sacrifice", guessCallback);
		//add(guessButton);

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
