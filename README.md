# LOVE2D TEST 3
Hello I am john 2d using love to make things  

Okay so something I wanna do mmm
1. Asset Paths
2. Cameras
3. Maybe Format Everything Too Snake Case
4. Audio Thingy
5. More Converters
6. State/Hot Reloading
7. Meta.lua Files so the language server stops having a fucking stroke
8. Cool Crash Handler
9. More Stuff For the Todo List

> WARNING: this is a for fun project and honestly can seize in development at any moment lmao  
this project is designed for *MY* convenience   aka does alot of random bullshit that does not make anysense  
because I am a lazy fuck that does not wanna make shit work conventionally or reasonably  
and also my intoduction to programming was psych engine lua that is another reason for this
also uses love12 so get that btw (I swear to god can this release ANY FASTER)

This project is the combination of work from 3 different love2d attempts
## RPG TEST 001
The first love2D test was this self insert rpg attempt called externally as Colo(u)r Brawl, I was making it with a friend but we got too out of scope and it never really went anywhere, I also didn't really know how to use love2D, or let alone understand most of the systems that are required to use love2D at the time, and my only saving grace was like 7 different liberaries that did most of the work for me. The main take away is that this was my intro into love2D, and my start as a failed game dev.  
<img src="https://github.com/user-attachments/assets/ad3bd460-8074-4bb9-ad9d-88bdab3e6a37" width="380">
## LOVE2D-ENGINE
An attempt at a full love2d engine, based off of some of the code from RPG TEST 001, never really went anywhere for the same reason.  
<img src="https://github.com/user-attachments/assets/cbc3f9b3-417f-4496-9c65-cfbe3ec1f0eb" width="380">

## LOVE2D-BULLSHIT
This is the project where I finally started to understand the deeper workings of love2d, not well mind you I was making a system that involved using the stencil system masking a rectangle for animation (bro did NOT know about `love.graphics.newQuad`), but some important parts from there like the sparrow parcing was originated from that project. Also the code base for that project was REALLY STUPID, all of it was local functions, by all of it, I MEAN all of it. Objects worked by creating a new table and appending ALL of the local functions into it. It worked, maybe it was faster, but by god was it stupid and annoying to work with.  
I wish I was joking  
<img src="https://github.com/user-attachments/assets/01585b97-d588-4b17-aa9d-ff64ac24d132" width="380">

## THIS PROJECT (LOVE2D TEST 3)
Hai! Hello! This project oringated because I really liked deltarune and wanted to give a full shot on at least making SOMETHING of essence, a project with a goal, which I still have not fully found yet, that's what I need to work on, maybe I'll draw up drafts of somethings I don't know. GOD IT IS REALLY HARD TO COME UP WITH IDEAS THAT ARE NOT STEALING FROM TOBY FOXES WORK FUCKKKK, like the battle system is such a good idea oh my fucking god I wanna steal it I WANT TO STEAL IT SO BAD BUT I CAN'TTT. How can I iterate on something that is so simple yet so fundimental in a creative yet interesting way. It reminds me of just shapes and beats a bit  

### Sparrow/Starling Atlas Parser (Yay?)
> basically this is a parser for the atlas format used in the [Sparrow Framework](https://www.sparrow-framework.org) because that is what I mainly work with because I am from the FNF scene. Gonna add support Asesprite exports and MAYBE some more that are exportable from [free-tex-packer](https://free-tex-packer.com/app/). But none the less the way the parser works by taking the sparrow atlas and then procreading to get 4 key proterties from it
> 1. dimensions: Width/Height of it's bounding box  
> 2. angle: if the sprite is rotated or not and what angle it should rotate at  
> 3. offset: the offset in x/y pixels already accounting for the angled offset  
> 4. quad: the corespondent quad used for rendering, litterally it makes the quad in the lua file it is HELLA connivent   
>
> also the converter makes these things called tags from the format, tags are caused when the frame repeats for animation purposes, I did this to save up on space because hold frames are everywhere but it really just ended up making half of the work for setting up the animation system already done

### CAMERA MOVEMENT
> oh my fucking god I hate this, I hate this so much, with every ounce of my SOUL I want this to DIE. So fun fact you can move the camera right, with middle button on your mouse you can move the camera around, which is neat wanna know what is not neat. DOING IT, accounting for zoom needs to be one of the most fucky processes in my life because all I wanted to do is to NOT manually recalculate the mouse delta because to get the global position you either need to do ffi shit or upgrade to love12, you would NEVER guess which one I picked.
> ```lua
>local last_x, last_y = 0, 0
>--UPDATE FUNCTION
>local _x, _y = graphics.inverseTransformPoint(love.mouse.getGlobalPosition())
>
>if love.mouse.isDown(3) then
>	local dx, dy = (_x - last_x), (_y - last_y)
>	x, y = x + dx, y + dy
>end
>
>last_x, last_y = _x, _y
>```

### Animation System 
> very rudimentary and basic, being based off of flixel's fuck ass system  
> here's some sample code so you can get a grip on how this works  
> it also works with rotation now!  
> ```lua
>test = sprite:new(0, 0, love.graphics.newImage("BOYFRIEND.png")) ---@type sprite
>test:load_frames("BOYFRIEND.lua")
>test.add_anim("idle"     , "BF idle dance", 24, false, {-5 ,  0})
>test.add_anim("singLEFT" , "BF NOTE LEFT" , 24, false, { 5 , -6})
>test.add_anim("singDOWN" , "BF NOTE DOWN" , 24, false, {-20, -51})
>test.add_anim("singUP"   , "BF NOTE UP"   , 24, false, {-46,  27})
>test.add_anim("singRIGHT", "BF NOTE RIGHT", 24, false, {-48, -7})
>
>test.play_anim("idle")
>```
> <img src="https://github.com/user-attachments/assets/21247d90-1d5a-45d9-8f9b-2296d4cc20d3" width="380">
