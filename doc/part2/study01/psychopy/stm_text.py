from psychopy import visual, core
win = visual.Window(size=(600,400), color='white', units='pix')
text = visual.TextStim(win, text='Press spacebar to start the trial', color='red', height=20)
text.draw()
win.flip()
core.wait(3)  # seconds
win.close()