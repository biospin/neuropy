from psychopy import gui

exp_name = 'Change Detection'
exp_info = {
            'participant': '', 
            'gender': ('male', 'female'), 
            'age':'', 
            'left-handed':False 
            }
dlg = gui.DlgFromDict(dictionary=exp_info, title=exp_name)

print exp_info