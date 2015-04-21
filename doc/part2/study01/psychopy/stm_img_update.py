from psychopy import visual, core
win = visual.Window(size=(600,400), color='white', units='pix')
bitmap = visual.ImageStim(win, 'images/1a.jpg', size=(600,400))
bitmap.draw()  # draw bitmap on the window
win.flip()  # make bitmap visible
core.wait(3)

bitmap.setImage('images/2a.jpg')
bitmap.setOri(180)
bitmap.draw()
win.flip()
core.wait(3)

win.close()