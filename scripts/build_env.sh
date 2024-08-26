

if [[ $1 == "macos-latest" ]]
then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install md5sha1sum
    mkdir -p ~/miniconda3
    curl -s https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh -o ~/miniconda3/miniconda.sh
    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
    rm ~/miniconda3/miniconda.sh
    ~/miniconda3/bin/conda init bash
    ~/miniconda3/bin/conda init zsh
    source ~/.zshrc
    source ~/.bashrc
    ~/miniconda3/bin/conda init bash
    ~/miniconda3/bin/conda init zsh
    conda env create -f macos-arm-environment.yml
elif [[ $1 == "macos-13" ]]
then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install md5sha1sum
    mkdir -p ~/miniconda3
    curl -s https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -o ~/miniconda3/miniconda.sh
    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
    rm ~/miniconda3/miniconda.sh
    ~/miniconda3/bin/conda init bash
    ~/miniconda3/bin/conda init zsh
    source ~/.zshrc
    source ~/.bashrc
    ~/miniconda3/bin/conda init bash
    ~/miniconda3/bin/conda init zsh
    conda env create -f environment.yml
else
    mkdir -p ~/miniconda3
    curl -s https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o ~/miniconda3/miniconda.sh
    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
    rm ~/miniconda3/miniconda.sh
    echo "Conda install done"
    ~/miniconda3/bin/conda init bash
    source ~/.bashrc
    ~/miniconda3/bin/conda init bash
    conda env create -f environment.yml
fi

eval "$(conda shell.bash hook)"
conda activate test_gpu_install_env

if [[ $1 == "ubuntu-latest" ]]
then
    conda install -c conda-forge cupy cuda-nvcc cuda-libraries-dev cuda-version=$2} -y
    export CUDAHOME=$CONDA_PREFIX
    ln -s $CONDA_PREFIX/lib $CONDA_PREFIX/lib64
    cp -r $CONDA_PREFIX/targets/$(ls $CONDA_PREFIX/targets/ | head -1)/include/* $CONDA_PREFIX/include/ 
fi
