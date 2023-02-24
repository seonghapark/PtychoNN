#!/bin/bash
# T. Guruswamy <tguruswamy@anl.gov>, 2020
# Download and build ImageJ and ADViewers EPICS plugins

IMAGEJ_VER=153
# Select from https://github.com/areaDetector/ADViewers/tags
ADVIEWERS_VER="R1-7"

# Fetch ImageJ1
# TODO: update if Java version changes
if [ ! -d ImageJ ]; then
    wget -c "http://wsr.imagej.net/distros/linux/ij${IMAGEJ_VER}-linux64-java8.zip"
    unzip -q "ij${IMAGEJ_VER}-linux64-java8.zip"
fi

if [ ! -d ImageJ ]; then
    echo "NO ImageJ folder found."
    exit 64
fi

# Fetch ADViewers, including ImageJ plugins
# not necessary to use git, can just download tar.gz from github releases
if [ ! -d ADViewers-${ADVIEWERS_VER} ]; then
    wget -c "https://github.com/areaDetector/ADViewers/archive/${ADVIEWERS_VER}/ADViewers-${ADVIEWERS_VER}.tar.gz"
    tar xf "ADViewers-${ADVIEWERS_VER}.tar.gz"
    #git clone -q -b master https://github.com/areaDetector/ADViewers.git
    #git checkout "$ADVIEWERS_VER"
fi

if [ ! -d ADViewers-${ADVIEWERS_VER} ]; then
    echo "NO ADViewers folder found."
    exit 64
fi

# Copy ADViewer plugins into ImageJ folder
cp -a "ADViewers-${ADVIEWERS_VER}/ImageJ/EPICS_areaDetector" ImageJ/plugins/

# Compile all plugins
pushd ImageJ

base="$(pwd)"
plugins=(
    "EPICS_AD_Viewer.java" 
    "EPICS_AD_Controller.java" 
    "EPICS_NTNDA_Viewer.java" 
    "Gaussian_Profiler.java" 
    "Dynamic_Profiler.java"
)

for plugin in "${plugins[@]}"; do
    echo "Compiling ${plugin}"
    # This command was extracted from the ImageJ logs after manually running "Plugins -> Compile and Run..."
    # The classpath is constructed from every *.jar file in the plugins/jars and plugins/EPICS_areaDetector folders
    javac -source 1.8 -target 1.8 -Xlint:unchecked -deprecation \
        -classpath 
"${base}/ij.jar:${base}/plugins/EPICS_areaDetector:${base}/plugins/jars/Auto_Threshold.jar:${base}/plugins/jars/BeanShell.jar:${base}/plugins/EPICS_areaDetector/epics-ntypes-0.3.5.jar:${base}/plugins/EPICS_areaDetector/epics-pvaccess-5.1.5.jar:${base}/plugins/EPICS_areaDetector/epics-pvaclient-4.3.2.jar:${base}/plugins/EPICS_areaDetector/epics-pvdata-6.1.5.jar:${base}/plugins/EPICS_areaDetector/epics-util-1.0.3.jar:${base}/plugins/EPICS_areaDetector/jca-2.4.5.jar:${base}/plugins/EPICS_areaDetector/jna-5.1.0.jar" 
\
        "${base}/plugins/EPICS_areaDetector/${plugin}"
done

popd

if [ -d "ImageJ_Profiles" ]; then
    cp -a "ImageJ_Profiles" "ImageJ"
fi

chmod -R ug+rwX,o+rX ImageJ
