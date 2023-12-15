# cl-mpm-worker
Used to build an MPI core for cl-mpm

## Installation

git clone to ~/quicklisp/local-projects
git clone [cl-mpm](https://github.com/Ionsto/cl-mpm) to local projects as well

Make a core image by running:

```lisp
(ql:quickload :cl-mpm-worker)
(in-package :cl-mpm-worker)
;;Load all nessesary files to stop compilers interacting when MPI-running
(ql:quickload :cl-mpm)
(ql:quickload :cl-mpm/setup)
(ql:quickload :cl-mpm/particle)
(ql:quickload :cl-mpm/mpi)

(defun primary-main ()
  ;;Code to execute in mpi
  ;;Useful to have project depedant code be loaded at runtime
  (load "tutorial-mpi.lisp"))
;;Compile down to a core-image
(sb-ext:save-lisp-and-die
 "mpi-worker"
 :executable t
 :toplevel #'main
 :save-runtime-options t)=
```

This core image may be run with mpi as such: 
```mpirun -N 2 ./mpi-worker```

## NOTE

Core images may break being unable to require base packages, you may need to set SBCL_HOME directly to the location of install:
```export SBCL_HOME=~/path-to-your-lisp-install/sbcl/lib/sbcl/```

## Author

* Sam Sutcliffe

## Copyright

Copyright (c) 2023 Sam Sutcliffe
