3p;hn!/bin/bash

# ==============================================================================
# LBM Convergence Study (Multi-seed)
# Plots: permeability vs NX for multiple seeds
# ==============================================================================

if [ -f "$HOME/anaconda3/bin/python" ]; then
    PYTHON_CMD="$HOME/anaconda3/bin/python"
else
    PYTHON_CMD=python3
fi

#PYTHON_CMD="$HOME/anaconda3/bin/python"

LOG_DIR="logs"
RESULTS_DIR="results"
DATA_FILE="results.csv"


# ---------------------- CHECK DEPENDENCIES ----------------------

echo "Checking Python dependencies"

MISSING_LIBS=()

# Check pandas
$PYTHON_CMD -c "import pandas" 2>/dev/null
if [ $? -ne 0 ]; then
    MISSING_LIBS+=("pandas")
fi

# Check matplotlib
$PYTHON_CMD -c "import matplotlib" 2>/dev/null
if [ $? -ne 0 ]; then
    MISSING_LIBS+=("matplotlib")
fi

# If any libraries are missing
if [ ${#MISSING_LIBS[@]} -ne 0 ]; then
    echo "ERROR: Missing required Python libraries: ${MISSING_LIBS[@]}"
    echo ""
    echo "Install with:"
    echo "  pip install ${MISSING_LIBS[@]}"
    echo ""
    echo "Or if using conda:"
    echo "  conda install ${MISSING_LIBS[@]}"
    exit 1
fi

echo "All dependencies found."

# ---------------------- PARAMETERS ----------------------
DELTA_P=0.1
LENGTH=2e-4

NX_VALUES=(25 50 100 200)
SEEDS=(99 100 101 102 103)

PORO=0.900
FIBER_DIAMETER_MEAN=12.5
FIBER_DIAMETER_STD=2.85

mkdir -p "$LOG_DIR"
mkdir -p "$RESULTS_DIR"

# Init CSV
echo "seed,NX,dx,k" > "$RESULTS_DIR/$DATA_FILE"

# ---------------------- FUNCTION ----------------------

run_simulation() {
    local seed=$1
    local NX=$2
    local DX=$3
    tag="s${seed}_NX${NX}"
    LOG_FILE="$LOG_DIR/${tag}.log"
    TEMP_SCRIPT="temp_${tag}.py"
    cat > "$TEMP_SCRIPT" << EOF
    
import matplotlib
matplotlib.use('Agg')
from devoir3_lbm import Generate_sample, LBM

seed = $seed
deltaP = $DELTA_P
NX = $NX
poro = $PORO
mean_fiber_d = $FIBER_DIAMETER_MEAN
std_d = $FIBER_DIAMETER_STD
dx = $DX
filename = 'fiber_mat_temp.tiff'

d_equivalent = Generate_sample(seed, filename, mean_fiber_d, std_d, poro, NX, dx)
k = LBM(filename, NX, deltaP, dx, d_equivalent)

EOF
    MPLBACKEND=Agg $PYTHON_CMD "$TEMP_SCRIPT" > "$LOG_FILE" 2>&1
    k=$(grep "k_in_micron2" "$LOG_FILE" | awk '{print $3}')
    echo "$seed,$NX,$DX,$k" >> "$RESULTS_DIR/$DATA_FILE"
    rm -f "$TEMP_SCRIPT"
}

# ---------------------- MAIN LOOP ----------------------

echo "Starting convergence study"

for seed in "${SEEDS[@]}"; do
    for NX in "${NX_VALUES[@]}"; do
        DX=$(awk "BEGIN {print $LENGTH / $NX}")
        echo "Running: seed=$seed NX=$NX dx=$DX"
        run_simulation "$seed" "$NX" "$DX"
    done
done

echo "Simulations completed."

# ---------------------- PLOT SCRIPT ----------------------

cat > "$RESULTS_DIR/plot_convergence.py" << 'EOF'
import pandas as pd
import matplotlib.pyplot as plt

data = pd.read_csv('results.csv')

plt.figure()

# Plot one curve per seed
for seed in data['seed'].unique():
    subset = data[data['seed'] == seed].sort_values('NX')
    plt.plot(subset['NX'], subset['k'], 'o-', label=f'seed {seed}')

plt.xlabel('Number of elements (NX)')
plt.ylabel('Permeability k (µm²)')
plt.title('Convergence of permeability with grid refinement')
plt.legend()
plt.grid(True)

plt.savefig('convergence_multi_seed.png', dpi=150)
print("Saved convergence_multi_seed.png")
EOF

# Run plot
echo "Generating plot..."
(cd "$RESULTS_DIR" && $PYTHON_CMD plot_convergence.py)

echo "Done."

