from psychopy import visual, core

win = visual.Window(size=(600,400), color='white', units='pix')
bitmap = visual.ImageStim(win, 'images/1a.jpg', size=(600,400))

# define and start a clock
rt_clock = core.Clock()
rt_clock.reset()
# this is equivallent to core.wait(3)
while rt_clock.getTime() < 3:
    bitmap.draw()  # draw bitmap on the window
    win.flip()  # make bitmap visible
    
win.close()