#!/bin/bash


function install_conda() {
	echo "Checking if miniconda3 is installed..."
	if [ ! -d "$WORK/miniconda3" ]; then
		echo "Miniconda not found in $WORK..."
		echo "Installing..."
		mkdir -p "$WORK/miniconda3"
		curl https://repo.anaconda.com/miniconda/Miniconda3-py311_23.10.0-1-Linux-x86_64.sh -o "$WORK/miniconda3/miniconda.sh"
		bash "$WORK/miniconda3/miniconda.sh" -b -u -p "$WORK/miniconda3"
		rm -rf "$WORK/miniconda3/miniconda.sh"
		export PATH="$WORK/miniconda3/bin:$PATH"
		echo "Ensuring conda base environment is OFF..."
		conda config --set auto_activate_base false
	else
		export PATH="$WORK/miniconda3/bin:$PATH"
	fi
	conda init bash
	echo "Sourcing .bashrc..."
	source ~/.bashrc
	unset PYTHONPATH
}

function load_cuda() {
	echo "Loading CUDA..."
	module load cuda/12.0
}


function init_directory() {
	mkdir -p ${COOKBOOK_REPOSITORY_PARENT_DIR}
	clone_cookbook_on_workspace
}


function conda_environment_exists() {
	conda env list | grep "${COOKBOOK_CONDA_ENV}"
}

function create_conda_environment() {
	conda create --name ${COOKBOOK_CONDA_ENV} 
	conda activate ${COOKBOOK_CONDA_ENV}
	pip install insanely-fast-whisper
}

function handle_installation() {
	if [ ${UPDATE_CONDA_ENV} = "true" ]; then
		if { conda_environment_exists; } >/dev/null 2>&1; then
			delete_conda_environment
		fi
		create_conda_environment
	else
		if { conda_environment_exists; } >/dev/null 2>&1; then
			echo "Conda environment already exists"
		else
			create_conda_environment
		fi
	fi
}

function delete_conda_environment() {
	conda deactivate
	conda env remove -n ${COOKBOOK_CONDA_ENV}
}
echo $@
export COOKBOOK_CONDA_ENV="whisper"
export file_name=$1
export output = $2
export min_speakers=$3
echo $file_name 
echo $output $min_speakers
export UPDATE_CONDA_ENV=true
# install_conda
load_cuda
# export_repo_variables
# init_directory
# handle_installation
# conda activate ${COOKBOOK_CONDA_ENV}
insanely-fast-whisper --file-name $file_name --diarization_model nvidia/speakerverification_en_titanet_large --min-speakers $min_speakers --transcript-path $output


