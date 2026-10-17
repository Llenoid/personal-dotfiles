# --- Configuration for script locations (these are the scripts in visit_assist_tools) ---
# Backend startup script
_BACKEND_SCRIPT_PATH="/home/brandon/Documents/rooche_digital/visit_assist_tools/start_backend.sh"
# Frontend startup script
_FRONTEND_SCRIPT_PATH="/home/brandon/Documents/rooche_digital/visit_assist_tools/start_frontend.sh"
# Database manager script (start_dev_dbs.sh)
_DBS_MANAGER_SCRIPT_PATH="/home/brandon/Documents/rooche_digital/visit_assist_tools/start_dev_dbs.sh"
# Directory where the database script and docker-compose file reside (the new tools directory)
_DBS_SCRIPT_EXEC_DIR="/home/brandon/Documents/rooche_digital/visit_assist_tools"

# Original project directories (used by the scripts themselves for internal operations)
_BACKEND_PROJECT_ROOT="/home/brandon/Documents/rooche_digital/a-be-os1"
_FRONTEND_PROJECT_ROOT="/home/brandon/Documents/rooche_digital/VisitAssist-fe"

# --- Zsh Functions ---

# Function to start the backend services
start_backend() {
  echo "--- Starting Backend Services ---"

  if [[ ! -f "$_BACKEND_SCRIPT_PATH" ]]; then
    echo "Error: Backend startup script not found at $_BACKEND_SCRIPT_PATH."
    return 1
  fi

  # Execute the backend startup script.
  # The script itself will handle changing to the actual backend project directory.
  bash "$_BACKEND_SCRIPT_PATH"
  local exit_code=$?

  echo "--- Backend Startup Command Finished ---"
  return $exit_code
}

# Function to start the frontend development server
start_frontend() {
  echo "--- Starting Frontend Development Server ---"

  if [[ ! -f "$_FRONTEND_SCRIPT_PATH" ]]; then
    echo "Error: Frontend startup script not found at $_FRONTEND_SCRIPT_PATH."
    return 1
  fi

  # Execute the frontend startup script.
  # The script itself will handle changing to the actual frontend project directory.
  bash "$_FRONTEND_SCRIPT_PATH"
  local exit_code=$?

  echo "--- Frontend Startup Command Finished ---"
  return $exit_code
}

# Function to start both backend and frontend development servers
start_all_dev() {
  start_backend
  if [[ $? -eq 0 ]]; then
    start_frontend
  else
    echo "Backend failed to start. Not attempting to start frontend."
    return 1
  fi
}

# Function to manage development databases (start, stop, status)
manage_dbs() {
  if [[ -z "$1" ]]; then
    echo "Usage: manage_dbs [start|stop|status]"
    return 1
  fi

  if [[ ! -f "$_DBS_MANAGER_SCRIPT_PATH" ]]; then
    echo "Error: Database manager script not found at $_DBS_MANAGER_SCRIPT_PATH."
    return 1
  fi

  echo "--- Managing Development Databases ($1) ---"

  # Crucial: Change to the directory where start_dev_dbs.sh and docker-compose file reside.
  # This is necessary because start_dev_dbs.sh uses relative paths for its operations.
  local original_dir=$(pwd) # Save current directory
  echo "Navigating to database scripts directory: $_DBS_SCRIPT_EXEC_DIR"
  cd "$_DBS_SCRIPT_EXEC_DIR" || { echo "Failed to change to database scripts directory."; return 1; }

  # Pass all arguments to the underlying script
  bash "$_DBS_MANAGER_SCRIPT_PATH" "$@"
  local exit_code=$?

  # Return to the original directory
  cd "$original_dir" > /dev/null

  echo "--- Database Management Command Finished ---"
  return $exit_code
}

# Function for database setup, like creating users (this one operates on the backend project directly)
db_setup_users() {
  local VENV_ACTIVATE_SCRIPT="${_BACKEND_PROJECT_ROOT}/.venv/bin/activate"
  local CREATE_USERS_SCRIPT="${_BACKEND_PROJECT_ROOT}/server/scripts/create_users.py"

  echo "--- Running Database User Setup ---"

  # Change to the backend project root to activate venv and run script
  local original_dir=$(pwd)
  echo "Navigating to backend directory: $_BACKEND_PROJECT_ROOT"
  cd "$_BACKEND_PROJECT_ROOT" || { echo "Failed to change to backend directory."; return 1; }

  if [[ ! -f "$VENV_ACTIVATE_SCRIPT" ]]; then
    echo "Error: Virtual environment activate script not found at $VENV_ACTIVATE_SCRIPT."
    echo "Please ensure your backend virtual environment is set up correctly."
    return 1
  fi
  echo "Activating Python virtual environment..."
  source "$VENV_ACTIVATE_SCRIPT"
  if [[ -z "$VIRTUAL_ENV" ]]; then
    echo "Error: Failed to activate virtual environment."
    return 1
  fi
  echo "Virtual environment activated: $VIRTUAL_ENV"

  if [[ ! -f "$CREATE_USERS_SCRIPT" ]]; then
    echo "Error: Create users script not found at $CREATE_USERS_SCRIPT."
    return 1
  fi
  echo "Executing: python "$CREATE_USERS_SCRIPT""
  python "$CREATE_USERS_SCRIPT"
  if [[ $? -ne 0 ]]; then
    echo "Error: Database user setup failed."
    return 1
  fi
  echo "Database user setup complete."

  # Deactivate virtual environment (optional, good practice)
  deactivate > /dev/null 2>&1
  echo "Virtual environment deactivated."

  # Return to the original directory
  cd "$original_dir" > /dev/null

  echo "--- Database User Setup Complete ---"
}
