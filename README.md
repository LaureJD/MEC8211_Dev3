# MEC8211_Dev3

CONTENT
CHECK DEPENDENCIES ( allowing to choose python from anaconda navigator if present or python3 if anaconda is not installed. As well as making sure all the libraries used by the script are installed)
PARAMETERS ( Contains the parametere that can be altered by the user and saves important values for plotting in results/results.cvs)
FUNCTION ( Import usable ouputs from the devoir3_lbm (accelerated).py file)
MAIN LOOP (Loops on all the NX values for every seed defined in the PARAMETER section)
PLOT SCRIPT ( Plot the results and save it as results/convergence_multi_seed.png)

USAGE
Place run_simulation.sh and devoir3_lbm (accelerated).py in the same directory. 
Rename devoir3_lbm (accelerated).py to remove the spaces in the name. ex devoir3_lbm.py
Modify the run_simulations file to run the correct py file defined in the previous step. Change the name devoir3_lbm in the import in the line : from devoir3_lbm import Generate_sample, LBM to the chosen file name without the file type extention. ex devoir3_lbm.
Modify the NX_VALUES and SEEDS under the section parameter to the wanted ones. 
If using anaconda3 to run python, make sure the directory is correctly setted in the following line : if [ -f "$HOME/anaconda3/bin/python" ]; then
Run the script. Results will be saved in the results folder, including a CSV file with values from each simulation run and a convergence plot.
