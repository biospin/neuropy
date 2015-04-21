from psychopy import visual, core

nframes = 12  # will see stimulus for 12 frames, i.e., 200 ms on most monitors

win = visual.Window(size=(600,400), color='white', units='pix')
bitmap = visual.ImageStim(win, 'images/1a.jpg', size=(600,400))

core.wait(2)  # blank screen initially

for frame in range(nframes):
    bitmap.draw()  # draw bitmap on the window
    win.flip()  # make bitmap visible

win.flip()
core.wait(2)  # blank screen afterwards
    
win.close()