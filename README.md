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

## Bug list
- Player will slow down in the air if they move towards the direction they want
	- This is due to the lerpf in the player move, they are lerping to a speed that is lower than intial vel
- Going from pause/main menu to options menu plays two sounds at the same time

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
- Braziers
	- high brazier: "Brazier" (https://skfb.ly/OqVs) by Jochon is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).
	- low brazier: "Primitive Brazier (Free)" (https://skfb.ly/6XP6B) by wolfgar74 is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).
- Gates
	- castle gate: "Castle Portcullis" (https://skfb.ly/6YnEp) by MOJackal is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).
	- door

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
