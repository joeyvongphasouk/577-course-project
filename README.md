# 577-course-project
Course project for the Mines CSCI 577 class.

## Team and Responsibilties
- Sovann Sam
  - Game developer
  - Level designer
  - Art and Sound director
- Joey Vongphasouk
  - Game developer
  - Game designer
  - Engine/Physics designer

---

## Need to Know stuffs
- Font size for menu is 40 px
- Player collision layer + mask is 2, grapple coll layer + mask is 1, thus blocks in env should check for both
- Audio for sound effects: https://www.zapsplat.com/sound-effect-packs/footsteps-on-hollow-wood-floor/?registration_redirect=1&item_id=40163
- To apply sticky to a wall, select the STATICBODY3D node and apply group to it
- To connect a trigger to a trap, go to trap and drag in trigger to its var

## Bug list
- Player will slow down in the air if they move towards the direction they want
	- This is due to the lerpf in the player move, they are lerping to a speed that is lower than intial vel
- Going from pause/main menu to options menu plays two sounds at the same time
- Pull onject mechanic can cause player to fly off into space if object is too light or small
- Pressing space bar removes the grapple entirely (I think the player should be able to jump while the grapple is extended)

## Current Assets List
# Characters
- 


# Music/Sounds
- Main menu
	- bg: https://alkakrab.itch.io/free-fantasy-exploration-ambient-music-pack
	- menu hover/slide: https://freesound.org/people/NenadSimic/sounds/157539/
	- menu click: https://freesound.org/people/NenadSimic/sounds/268108/
- Walking sounds
	- https://www.zapsplat.com

# Environment
- fire stuff
	- high brazier: "Brazier" (https://skfb.ly/OqVs) by Jochon is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).
	- low brazier: "Primitive Brazier (Free)" (https://skfb.ly/6XP6B) by wolfgar74 is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).
	- torch: "Low poly stylized Torch" (https://skfb.ly/6TXPC) by MMandali is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).
- Gates
	- castle gate: "Castle Portcullis" (https://skfb.ly/6YnEp) by MOJackal is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).
	- door: "Door" (https://mrscientist.itch.io/3d-low-poly-modular-dungeon) by Mr. Scientist. License is CC0.
  - doorway: "Door Way" (https://mrscientist.itch.io/3d-low-poly-modular-dungeon) by Mr. Scientist. License is CC0.
- Traps
	- Arrow: "Arrow" (https://skfb.ly/6WouA) by Boy Best is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).
	- spike trap: "Wooden Spike Trap" (https://skfb.ly/6TP9H) by Ananda Yokesh is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).
- Grapple gun
	- Gun: "Pistola Low Poly" (https://skfb.ly/oCvu7) by Limberax is licensed under Creative Commons Attribution-NonCommercial (http://creativecommons.org/licenses/by-nc/4.0/).
- Key
	- "Key" (https://skfb.ly/6zWTC) by Mr NISHKE is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).

# Grapple

---
## Deadlines
| Date | Description |
| -------- | ------- |
| Jan 21 | finalize ideas, schedule kathleen meeting, maybe reg meeting |
| Jan 26 | team contract and delivery letter |
| Jan 22 - Feb 7 | pitch proposal and meeting |
| Feb 16 | Game design doc and Product backlog |
| Mar 14 | Alpha Delivery |
| Apr 13 | Beta Delivery |
| Apr 28 | Final Delivery |
| Apr 28 - 30 | Final Presentation |

I hope this works
