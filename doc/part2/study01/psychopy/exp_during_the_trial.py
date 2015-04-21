from psychopy import visual, core

scrsize = (600,400)
win = visual.Window(size=scrsize, color='white', units='pix')
bitmap1 = visual.ImageStim(win, 'images/1a.jpg', size=scrsize)
bitmap2 = visual.ImageStim(win, 'images/1b.jpg', size=scrsize)

for i in range(5):
    bitmap1.draw()  # draw bitmap on the window
    win.flip()  # make bitmap visible
    core.wait(.5)

    bitmap2.draw()
    win.flip()
    core.wait(.5)
    
win.close()