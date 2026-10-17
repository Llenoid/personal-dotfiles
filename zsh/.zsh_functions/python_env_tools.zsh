#!/bin/zsh

# Define the absolute path to your project directory
PROJECT_DIR="/home/brandon/Documents/rooche_digital/project_pelbaor/a-be-os1"

# Define the path to your virtual environment's activate script
VENV_ACTIVATE_SCRIPT="${PROJECT_DIR}/.venv/bin/activate"

# ---

## Verify Project Directory

# # Check if the current directory is the project directory
# if [[ "$(pwd)" != "$PROJECT_DIR" ]]; then
#   echo "Error: You are not in the project directory."
#   echo "Please navigate to: $PROJECT_DIR"
#   exit 1
# fi

# ---

## Activate Python Virtual Environment

# Check if the virtual environment activate script exists
if [[ ! -f "$VENV_ACTIVATE_SCRIPT" ]]; then
  echo "Error: Virtual environment activate script not found at $VENV_ACTIVATE_SCRIPT."
  echo "Please ensure your virtual environment is set up correctly by running 'python3 -m venv .venv' in your project directory."
  exit 1
fi

echo "Activating Python virtual environment..."
source "$VENV_ACTIVATE_SCRIPT"

# Check if the virtual environment was activated successfully
if [[ -z "$VIRTUAL_ENV" ]]; then
  echo "Error: Failed to activate virtual environment."
  echo "Please check the path and ensure the virtual environment is valid."
  exit 1
fi

echo "Virtual environment activated: $VIRTUAL_ENV"

# ---

## Start Development Server

# Construct the absolute path to the restart.sh script
RESTART_SCRIPT="${PROJECT_DIR}/service_control/restart.sh"

# Check if the restart script exists
if [[ ! -f "$RESTART_SCRIPT" ]]; then
  echo "Error: Restart script not found at $RESTART_SCRIPT."
  echo "Please ensure 'service_control/restart.sh' exists in your project directory."
  exit 1
fi

# Start all services using the provided restart.sh script with its absolute path
echo "Starting all services using $RESTART_SCRIPT..."
bash "$RESTART_SCRIPT"
