from psychopy import visual, core, event

scrsize = (600,400)
win = visual.Window(size=scrsize, color='white', units='pix')
bitmap1 = visual.ImageStim(win, 'images/1a.jpg', size=scrsize)
bitmap2 = visual.ImageStim(win, 'images/1b.jpg', size=scrsize)
bitmap = bitmap1

# Initialize clock to register response time
rt_clock = core.Clock()
rt_clock.reset()  # set rt clock to 0
done = False

# Empty the keypresses list
keys = None

# Start the trial
# Stop trial if spacebar or escape has been pressed, or if 30s have passed
while keys is None and rt_clock.getTime() < 30:
    
    # Switch the image
    if bitmap == bitmap1:
        bitmap = bitmap2
    else:
        bitmap = bitmap1
    bitmap.draw()
    
    # Show the new screen we've drawn
    win.flip()
        
    # For 0.5s, listen for a spacebar or escape press
    keys = event.waitKeys(maxWait=.5, keyList=['space', 'escape'], timeStamped=rt_clock)
    print keys
    
win.close()