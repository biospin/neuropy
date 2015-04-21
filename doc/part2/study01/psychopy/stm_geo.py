from psychopy import visual, core
win = visual.Window(size=(600,400), color='white', units='pix')
bubble = visual.Circle(win, fillColor='black', lineColor='black', radius=30)
bubble.draw()
win.flip()
core.wait(3)  # seconds
win.close()