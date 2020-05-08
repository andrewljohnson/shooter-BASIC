print "Play with one hand on each side of the keyboard."
print "Move: adws"
print "Shoot: i"

ARRAY enemyxs
ARRAY enemyys
enemycount = 0
ARRAY bulletxs
ARRAY bulletys
bulletcount = 0
ticks = 0
boardcenter = 24
boardsize = 50
gunx = boardcenter
guny = boardsize - 1
plot gunx, guny, "black"

1000 rem main game loop
ticks = ticks + 1
if ticks % 10 = 0 or ticks = 0 then gosub 1400
for i = 0 to enemycount
  if gunx = enemyxs[i] and guny = enemyys[i] then goto 10000
next i
if enemycount > 0 then gosub 1600
if enemycount > 0 then gosub 1500
if enemycount > 0 then gosub 1600
if bulletcount > 0 then gosub 1300
if ticks = 100 then ticks = 0
k = getchar()
if k = "i" then gosub 1200
if k = "a" or k = "d" or k = "w" or k = "s" then gosub 1100
pause 50
goto 1000

1100 rem move
plot gunx, guny, "white"
if k = "a" then gunx = gunx - 1
if k = "d" then gunx = gunx + 1
if k = "w" then guny = guny - 1
if k = "s" then guny = guny + 1
if gunx > boardsize - 1 then gunx = 0
if gunx < 0 then gunx = boardsize
if guny > boardsize - 1 then guny = 0
if guny < 0 then guny = boardsize - 1
plot gunx, guny, "black"
return

1200 rem spawn northerly bullet
bulletx = gunx 
bullety = guny - 1
plot bulletx, bullety, "red"
bulletxs[bulletcount] = bulletx
bulletys[bulletcount] = bullety
bulletcount = bulletcount + 1
print "Spawn bullet at: " + bulletx + ", " + bullety
return

1300 rem move northerly bullets
for i = 0 to bulletcount
  bulletx = bulletxs[i]
  bullety = bulletys[i]
  plot bulletx, bullety, "white"
  bullety = bullety - 1
  bulletxs[i] = bulletx
  bulletys[i] = bullety
  plot bulletx, bullety, "red"
next i
return

1400 rem spawn southerly enemy
enemyxs[enemycount] = rand(boardsize) - 1
enemyys[enemycount] = 0
plot enemyxs[enemycount], enemyys[enemycount], "magenta"
print "spawn at: " + enemyxs[enemycount] + ", " + enemyys[enemycount]
enemycount = enemycount + 1
return

1500 rem move southerly enemies
for i = 0 to enemycount
  enemyx = enemyxs[i]
  enemyy = enemyys[i]
  plot enemyx, enemyy, "white"
  enemyy = enemyy + 1
  enemyxs[i] = enemyx
  enemyys[i] = enemyy
  plot enemyx, enemyy, "magenta"
next i
return

1600 rem check for killed enemies
if enemycount = 0 or bulletcount = 0 then return
enemykilled = False
bullettoremove = -1
enemytoremove = -1
for i = 0 to enemycount
  enemyx = enemyxs[i]
  enemyy = enemyys[i]
  for j = 0 to bulletcount
    bulletx = bulletxs[j]
    bullety = bulletys[j]
    bullettoremove = j
    enemytoremove = i
    if enemyy = bullety and enemyx = bulletx then enemykilled = true
    if enemykilled then gosub 1700
    if enemykilled then gosub 1800
    if enemykilled then goto 1600
    if enemyy > boardsize - 1 then gosub 1700
    if enemyy > boardsize - 1 then goto 1600
    if bullety < 0 then gosub 1800
    if bullety < 0 then goto 1600
  next j
next i
return

1700 rem remove enemy
plot enemyxs[enemytoremove], enemyys[enemytoremove], "white"
ARRAY newenemyxs
ARRAY newenemyys
index = 0
for i = 0 to enemycount
  if i <> enemytoremove then newenemyxs[index] = enemyxs[i]
  if i <> enemytoremove then newenemyys[index] = enemyys[i]
  if i <> enemytoremove then index = index + 1
next i
enemyxs = newenemyxs
enemyys = newenemyys
enemycount = enemycount - 1
return

1800 rem remove bullet
ARRAY newbulletxs
ARRAY newbulletys
index = 0
for i = 0 to bulletcount
  if i <> bullettoremove then newbulletxs[index] = bulletxs[i]
  if i <> bullettoremove then newbulletys[index] = bulletys[i]
  if i <> bullettoremove then index = index + 1
next i
bulletxs = newbulletxs
bulletys = newbulletys
bulletcount = bulletcount - 1
return

10000 rem game over
print "GAME OVER"