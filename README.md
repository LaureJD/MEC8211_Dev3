# MEC8211_Dev3


## CONTENT
###CHECK DEPENDENCIES
Allows choosing Python from Anaconda Navigator if present, or Python3 if Anaconda is not installed. Ensures all required libraries are installed.
### PARAMETERS
Contains parameters that can be altered by the user and saves important values for plotting in `results/results.csv`
### FUNCTION
Imports usable outputs from the `devoir3_lbm (accelerated).py` file
### MAIN LOOP
Loops through all NX values for every seed defined in the PARAMETER section
### PLOT SCRIPT
Plots the results and saves them as `results/convergence_multi_seed.png`

## Usage

1. Place `run_simulation.sh` and `devoir3_lbm (accelerated).py` in the same directory.
2. Rename `devoir3_lbm (accelerated).py` to remove spaces in the name.  
   Example: `devoir3_lbm.py`
3. Modify the `run_simulations` file to use the correct Python file from the previous step:
   - Change the import line from `from devoir3_lbm import Generate_sample, LBM` to your chosen filename (without extension).  
     Example: `devoir3_lbm`
4. Modify `NX_VALUES` and `SEEDS` under the PARAMETER section to your desired values.
5. If using Anaconda3 to run Python, verify the directory path is correctly set in the following line:
   ```bash
   if [ -f "$HOME/anaconda3/bin/python" ]; then
6.Run the script. Results will be saved in the results folder, including a CSV file with values from each simulation run and a convergence plot.
