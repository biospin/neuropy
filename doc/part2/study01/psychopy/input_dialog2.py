from psychopy import gui, core

exp_name = 'Change Detection'
exp_info = {
            'participant': '', 
            'gender': ('male', 'female'), 
            'age':'', 
            'left-handed':False 
            }
dlg = gui.DlgFromDict(dictionary=exp_info, title=exp_name)

if dlg.OK == False:
    core.quit()  # user pressed cancel, so we quit