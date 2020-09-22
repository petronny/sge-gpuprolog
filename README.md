Gridengine GPU prolog
=====================

Scripts to manage NVIDIA GPU devices in Sun Grid Engine 6.2u5 and Son of Grid Engine 8.1.9 .

Sun Grid Engine and Son of Grid Engine do not contain the RSMAP functionality
implemented in recent Univa Grid Engine.
The ad-hoc scripts in this package implement resource allocation for NVIDIA devices.

Installation
------------

First, set up complex `gpu_free`, `gpu_used` and `gpu_total`.

    $ qconf -mc
    #name               shortcut     type      relop requestable consumable default  urgency
    #----------------------------------------------------------------------------------------
    gpu_free            gpu          INT       <=    YES         YES        0        0
    gpu_total           gpu_total    INT       <=    YES         NO         0        0
    gpu_used            gpu_used     INT       >=    NO          NO         0        0

At each execution host, setup `load_sensor`.

    $ qconf -mconf your_execution_host

    load_sensor                  /path/to/sge-gpuprolog/load-sensor.sh

Set up `prolog` and `epilog` in the queue.

    $ qconf -mq gpu.q

    prolog                sgeadmin@/path/to/sge-gpuprolog/prolog.sh
    epilog                sgeadmin@/path/to/sge-gpuprolog/epilog.sh

Alternatively, you may set up a parallel environment for GPU and set
`start_proc_args` and `stop_proc_args` to the packaged scripts.

Usage
-----

Show free GPU resources in the cluster.

    $ qhost -F gpu

Show free, used and total GPU resources in the cluster.

    $ qhost -F gpu,gpu_used,gpu_total

Request GPU resources in the designated queue.

    $ qsub -q gpu.q -l gpu=1 gpujob.sh

The job script can access the `CUDA_VISIBLE_DEVICES` variable.

```sh
#!/bin/sh
echo $CUDA_VISIBLE_DEVICES
```

The variable contains a comma-delimited device IDs, such as `0` or `0,1,2`
depending on the number of `gpu` resources to be requested. Use the device ID
for `cudaSetDevice()`.
