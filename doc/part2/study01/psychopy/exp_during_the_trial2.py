from psychopy import visual, core

scrsize = (600,400)
win = visual.Window(size=scrsize, color='white', units='pix')
bitmap1 = visual.ImageStim(win, 'images/1a.jpg', size=scrsize)
bitmap2 = visual.ImageStim(win, 'images/1b.jpg', size=scrsize)
bitmap = bitmap1

for i in range(10):  # note that we now need 10, not 5 iterations
    # change the bitmap
    if bitmap == bitmap1:
        bitmap = bitmap2
    else:
        bitmap = bitmap1
    bitmap.draw()
    win.flip()
    core.wait(.5)
win.close()