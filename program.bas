print "Play with one hand on each side of the keyboard."
print "Move: adws";
print "Shoot: i"

rem score variables
killedenemycount = 0
lettercolor = "black"
letterheight = 5
letterwidth = 4
numberofdigits = 3
timeinseconds = 0
drawingtime = false
gosub 1900

ARRAY enemyxs
ARRAY enemyys
enemycount = 0
ARRAY bulletxs
ARRAY bulletys
bulletcount = 0
ticks = 0
miny = letterheight + 2
boardwidth = 50
boardmaxy = 50
boardheight = boardwidth - miny / 2
gunx = boardwidth / 2
guny = boardmaxy - 1
for x = 0 to boardwidth
   plot x, letterheight + 1, "blue"
next x
plot gunx, guny, "black"

1000 rem main game loop
ticks = ticks + 1
if ticks % 100 = 0 then timeinseconds = timeinseconds + 1
if ticks % 100 = 0 then drawingtime = true
if ticks % 100 = 0 then gosub 2000
if ticks % 10 = 0 or ticks = 0 then gosub 1400
for i = 0 to enemycount
  if gunx = enemyxs[i] and guny = enemyys[i] then goto 999999
next i
if enemycount > 0 and ticks % 5 = 0 then gosub 1600
if enemycount > 0 and ticks % 5 = 0 then gosub 1500
if enemycount > 0 and ticks % 5 = 0 then gosub 1600
if bulletcount > 0 and ticks % 5 = 0 then gosub 1300
if ticks = 1000 then ticks = 0
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
if gunx > boardwidth - 1 then gunx = 0
if gunx < 0 then gunx = boardwidth
if guny > boardwidth - 1 then guny = miny
if guny < miny then guny = boardwidth - 1
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
enemyxs[enemycount] = rand(boardwidth) - 1
enemyys[enemycount] = miny
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
    if enemykilled then killedenemycount = killedenemycount + 1
    if enemykilled then goto 1900
    if enemykilled then gosub 1700
    if enemykilled then gosub 1800
    if enemykilled then goto 1600
    if enemyy > boardmaxy - 1 then gosub 1700
    if enemyy > boardmaxy - 1 then goto 1600
    if bullety <= miny then gosub 1800
    if bullety <= miny then goto 1600
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
plot bulletxs[enemytoremove], bulletys[enemytoremove], "white"
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

1900 rem draw three-digit score
gosub 90001
digit = 0
hundreds = FLOOR(killedenemycount / 100)
print "hundreds is " + hundreds
if hundreds = 0 then gosub 99999
if hundreds > 0 then gosub hundreds * 10000
digit = 1
tens = FLOOR(killedenemycount % 100 / 10)
print "tens is " + tens
if tens = 0 then gosub 99999
if tens > 0 then  gosub tens * 10000
digit = 2
ones = killedenemycount % 10
print "ones is " + ones
if ones = 0 then gosub 99999
if ones > 0 then gosub ones * 10000
return

2000 rem draw time
print "draw time"
digit = (boardwidth - letterwidth) / letterwidth
print digit
gosub 99999
digit = 0
return

999999 rem game over
print "GAME OVER"
return

99999 rem draw 0
x = 0 + digit * letterwidth
y = 0
gosub 100000
gosub 200000
y = 4
gosub 200000
y = 0
x = 2 + digit * letterwidth
gosub 100000
return

10000 rem draw 1
print "drawing a 1"
x = 1 + digit * letterwidth
y = 0
gosub 100000
return

20000 rem draw 2
x = digit * letterwidth
y = 0
gosub 200000
y = 2
gosub 200000
y = 4
gosub 200000
plot x + 2, 1, lettercolor
plot x, 3, lettercolor
return

30000 rem draw 3
x = 2 + digit * letterwidth
y = 0
gosub 100000
x = digit * letterwidth
gosub 200000
y = 2
gosub 200000
y = 4
gosub 200000
return

40000 rem draw 4
x = 2 + digit * letterwidth
y = 0
gosub 100000
x = digit * letterwidth
y = 2
gosub 200000
plot x, 0, lettercolor
plot x, 1, lettercolor
return

50000 rem draw 5
x = digit * letterwidth
y = 0
gosub 200000
y = 2
gosub 200000
y = 4
gosub 200000
plot x, 1, lettercolor
plot x + 2, 3, lettercolor
return

60000 rem draw 6
x = digit * letterwidth
y = 2
gosub 200000
y = 4
gosub 200000
x = digit * letterwidth
y = 0
gosub 100000
plot 2 + digit * letterwidth, 3, lettercolor
return

70000 rem draw 7
x = 0 + digit * letterwidth
y = 0
gosub 200000
x = 2 + digit * letterwidth
gosub 100000
return

80000 rem draw 8
x = 0 + digit * letterwidth
y = 0
gosub 100000
gosub 200000
y = 2
gosub 200000
y = 4
gosub 200000
x = 2 + digit * letterwidth
y = 0
gosub 100000
return

90000 rem draw 9
x = 0 + digit * letterwidth
y = 0
gosub 200000
y = 2
gosub 200000
y = 0
x = 2 + digit * letterwidth
gosub 100000
plot digit * letterwidth, 1, lettercolor
return

90001 rem draw blank
for w = 0 to numberofdigits
  for x = 0 + w * (letterwidth) to letterwidth + w * (letterwidth)
    print "digit is " + w + " and x is " + x
    for y = 0 to letterheight
      plot x, y, "white"
    next y
  next x
next w
return

100000 rem draw vertical line
plot x, y, lettercolor 
plot x, y + 1, lettercolor
plot x, y + 2, lettercolor 
plot x, y + 3, lettercolor
plot x, y + 4, lettercolor
return

200000 rem draw horizontal line
plot x, y, lettercolor 
plot x + 1, y, lettercolor
plot x + 2, y, lettercolor 
return