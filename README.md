# LOVE2D TEST 3
Hello I am john 2d using love to make things  

> WARNING: this is a for fun project and honestly can seize in development at any moment lmao  
this project is designed for *MY* convenience   aka does alot of random bullshit that does not make anysense  
because I am a lazy fuck that does not wanna make shit work conventionally or reasonably  
and also my intoduction to programming was psych engine lua that is another reason for this

This project is the combination of work from 2 different love2d attempts
## RPG TEST 001
The first love2D test was this self insert rpg attempt called externally as Colo(u)r Brawl, I was making it with a friend but we got too out of scope and it never really went anywhere, I also didn't really know how to use love2D, or let alone understand most of the systems that are required to use love2D at the time, and my only saving grace was like 7 different liberaries that did most of the work for me. The main take away is that this was my intro into love2D, and my start as a failed game dev.  
## LOVE2D-BULLSHIT
This is the project where I finally started to understand the deeper workings of love2d, not well mind you I was making a system that involved using the stencil system masking a rectangle for animation (bro did NOT know about `love.graphics.newQuad`), but some important parts from there like the sparrow parcing was originated from that project. Also the code base for that project was REALLY STUPID, all of it was local functions, by all of it, I MEAN all of it. Objects worked by creating a new table and appending ALL of the local functions into it. It worked, maybe it was faster, but by god was it stupid and annoying to work with.  
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

### Animation System 
> very rudimentary and basic, being based off of flixel's fuck ass system  
> here's some sample code so you can get a grip on how this works
> ```lua
>test = sprite:new(0, 0, love.graphics.newImage("BOYFRIEND.png")) ---@type sprite
>test:loadFrames("BOYFRIEND.lua")
>test.animation:addByTag("idle"     , "BF idle dance", 24, false, {-5 ,  0})
>test.animation:addByTag("singLEFT" , "BF NOTE LEFT" , 24, false, { 5 , -6})
>test.animation:addByTag("singDOWN" , "BF NOTE DOWN" , 24, false, {-20, -51})
>test.animation:addByTag("singUP"   , "BF NOTE UP"   , 24, false, {-46,  27})
>test.animation:addByTag("singRIGHT", "BF NOTE RIGHT", 24, false, {-48, -7})
>	
>test.animation:play("idle")
>```