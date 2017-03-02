#!/bin/bash

nb_home=$HOME/jupnb

function install() {
    # install curl virtualenvwrapper
    apt-get install -y curl virtualenvwrapper
    
    # install as workaround for https://github.com/matplotlib/matplotlib/issues/3029/
    apt-get install -y pkg-config
    
    # install python development packages and g++
    apt-get install -y python3-dev g++
    
    # install dependencies for scipy
    apt-get install -y libblas-dev liblapack-dev gfortran
    
    # install some dependencies for matplotlib
    apt-get install -y libfreetype6-dev libpng-dev libjpeg8-dev
}

function virtualenv() {
    
    # create and activate virtual environment  (env name is jupnb)
    # logout & relogin
    mkvirtualenv --no-setuptools --python /usr/bin/python3 jupnb 
    
    # install fresh pip
    curl https://bootstrap.pypa.io/get-pip.py | python
    
    # install fresh setuptools
    pip install setuptools distribute
    
    # install numpy as it is dependecy for many others
    pip install numpy
    
    # install scientific packages (seaborn instead of matplotlib for pretty plots)
    pip install sympy scipy seaborn pandas jupyter pillow
    
    # install scikit-learn separately, it depends on numpy and scipy
    pip install scikit-learn

    pip install tensorflow keras
    
    # deactivate env
    deactivate
}

function nbprofile() {
    # activate virtual env
    workon jupnb

    mkdir -p ~/.jupyter
    cd ~/.jupyter
    openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout jupnb.key -out jupnb.pem
    echo "c.NotebookApp.ip = '*'" >> jupyter_notebook_config.py
    echo "c.NotebookApp.port = 8888" >> jupyter_notebook_config.py
    echo "c.NotebookApp.open_browser = False" >> jupyter_notebook_config.py
    echo "c.NotebookApp.password = u'$(ipython -c 'from notebook.auth import passwd; print(passwd())')'" >> jupyter_notebook_config.py
    echo "c.NotebookApp.certfile = u'$HOME/.jupyter/jupnb.pem'" >> jupyter_notebook_config.py
    echo "c.NotebookApp.keyfile = u'$HOME/.jupyter/jupnb.key'" >> jupyter_notebook_config.py
    echo "c.NotebookApp.cookie_secret_file = '$HOME/.jupyter/secret_cookie'" >> jupyter_notebook_config.py
    cp ~/.jupyter/jupnb.pem .
    cd -

    deactivate
}

function start() {
    workon jupnb

    mkdir -p $nb_home; cd $nb_home # the home directory for jupyter user
    nohup jupyter notebook 2>&1 > jupbook.log &
}


function stop() {
    kill $(pgrep jupyter)
    deactivate
}


function help() {
    echo "$0 command"
    echo "command: "
    echo "         install"
    echo "         start"
    echo "         stop"
}

function main() {
    cmd="$1"

    if [ "$cmd" == "install" ]; then
        install
        virtualenv  
        nbprofile
    elif [ "$cmd" == "start" ]; then
        start
    elif [ "$cmd" == "stop" ]; then
        stop
    else
        help
    fi
} 


main $*
