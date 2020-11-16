.. Octopus documentation master file, created by
   sphinx-quickstart on Sun Mar 25 22:02:55 2018.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Octopus
=========

A tool for fast Lagrangian trajectory calculation
-----------------------------------------------

This fortran code is used to calculate particle trajectories using three dimensional velocity fields from numerical models, e.g., MITgcm (https://github.com/MITgcm/MITgcm). The current version is setup based on C-grid.

**Current status**: testing the volume conservation.

Offline calculation of Lagrangian trajectories

This model is in a development stage. Email me for questions. There are two configurations: Lagrangian particle and Argo float.  Use "make" to compile the code for Lagrangian particle simulation. Use "make argo" for simulating Argo float. Before running the model, go to scripts folder and run "python gen_data.py" to compute the binary files used by the code.

Jinbo Wang <jinbo.wang@jpl.nasa.gov>

Jet Propulsion Labortory, Caltech

11/16/2020

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   
   customize_velocity.rst
   build.rst
   argo.mode.rst
   

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
