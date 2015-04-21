from psychopy import visual, core, event

win = visual.Window(size=(600,400), color='white', units='pix')
text = visual.TextStim(win, text='Press spacebar to start the trial', color='red', height=20)
text.draw()
win.flip()

keys = event.waitKeys(keyList=['space', 'escape'])
print keys

if 'escape' in keys:
    win.close()
else:
    print 'Start of the trial'
    win.close()