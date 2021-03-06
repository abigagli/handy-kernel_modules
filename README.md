<!-- TOC -->

- [Info](#info)
- [Setup](#setup)
- [Kernel module](#kernel-module)
    - [Simple](#simple)
    - [With parameter](#with-parameter)
- [General DS](#general-ds)
    - [container_of](#container_of)
    - [Linked list](#linked-list)
    - [List process](#list-process)
    - [kthread (simple)](#kthread-simple)
    - [kthread (advanced)](#kthread-advanced)
- [Locking](#locking)
    - [mutex](#mutex)
    - [spinlock](#spinlock)
    - [semaphore](#semaphore)
    - [rw-semaphore](#rw-semaphore)
- [Character device](#character-device)
    - [Simple](#simple-1)
    - [With File I/O](#with-file-io)
    - [With Sysfs](#with-sysfs)
- [Timer](#timer)
    - [Simple](#simple-2)
    - [hr-timer (one shot)](#hr-timer-one-shot)
    - [hr-timer (Repetitive)](#hr-timer-repetitive)
- [Worker](#worker)
    - [Tasklet](#tasklet)
    - [Wait Queue](#wait-queue)
    - [Work queue](#work-queue)
        - [Simple](#simple-3)
        - [Delayed](#delayed)
- [License](#license)

<!-- /TOC -->

# Info
It contains Linux kernel modules.

# Setup
- How to do setup of workspace, follow [this](https://aakbar5.wordpress.com/2020/02/15/linux-kernel-vs-code/).

![kernel_in_vscode](.devcontainer/kernel_in_vscode.gif)


# Kernel module
## Simple
Simple kernel module
- [helloworld.c](helloworld.c)

```
# insmod helloworld.ko
[ 8604.716927] Helloworld_module: init
#
# rmmod helloworld.ko
[ 8610.234228] Helloworld_module: exit
#
```

## With parameter
A kernel module which can accept parameters.
- [helloworld_param.c](helloworld_param.c)

- Insert module with no parameter
```
#
# insmod helloworld_param.ko
[ 8773.412883] Helloworld_module: init
[ 8773.413270] Helloworld_parameters:
[ 8773.413524]  - param_integer # 500
[ 8773.413785]  - param_array # [ 500][ 501][ 502]
[ 8773.414045]  - param_string # helloworld
#
# rmmod helloworld_param.ko
[ 8780.668106] Helloworld_module: exit
[ 8780.668684] Helloworld_parameters:
[ 8780.668980]  - param_integer # 500
[ 8780.669249]  - param_array # [ 500][ 501][ 502]
[ 8780.669564]  - param_string # helloworld
#
```

- Insert module with user defined parameter
```
# insmod helloworld_param.ko param_integer=600 param_string="testing" param_array=1,2,3
[ 8869.944889] Helloworld_module: init
[ 8869.945650] Helloworld_parameters:
[ 8869.945948]  - param_integer # 600
[ 8869.949919]  - param_array # [   1][   2][   3]
[ 8869.952371]  - param_string # testing
#
# rmmod helloworld_param.ko
[ 8893.422618] Helloworld_module: exit
[ 8893.423951] Helloworld_parameters:
[ 8893.424284]  - param_integer # 600
[ 8893.424550]  - param_array # [   1][   2][   3]
[ 8893.424878]  - param_string # testing
#
```

# General DS
## container_of
An example of how to use `container_of`.
- [container_of.c](container_of.c)

```
# modinfo container_of.ko
filename:       /root/container_of.ko
author:         aakbar5 <16612387+aakbar5@users.noreply.github.com>
license:        GPL
description:    co: container_of example
version:        0.0.1
srcversion:     39B80B8E047FA102727B810
depends:
name:           container_of
vermagic:       5.4.0-00001-gade746754348-dirty SMP preempt mod_unload aarch64
parm:           param_count:Number of groups to be created -- (Read only) (int)
parm:           param_idx:Index of the group to be shown -- (Read/write only) (int)
```

```
# insmod container_of.ko
[11503.238689] co: init
[11503.240342] Group @ index based
[11503.240556]  - Id # 32
[11503.240742]  - Obj1 # 21 -- obj1=1
[11503.240949]  - Obj2 # 11 -- obj2=1
[11503.241165] Group @ container_of @ id
[11503.241349]  - Id # 32
[11503.241517]  - Obj1 # 21 -- obj1=1
[11503.241698]  - Obj2 # 11 -- obj2=1
[11503.241893] Group @ container_of @ obj1
[11503.242079]  - Id # 32
[11503.242246]  - Obj1 # 21 -- obj1=1
[11503.242435]  - Obj2 # 11 -- obj2=1
#
# rmmod container_of.ko
[11523.668908] co: exit
#
```

```
# insmod container_of.ko param_idx=2
[   46.364041] container_of: loading out-of-tree module taints kernel.
[   46.397061] co: init
[   46.400697] Group @ index based
[   46.400988]  - Id # 34
[   46.401183]  - Obj1 # 22 -- obj1=2
[   46.401410]  - Obj2 # 12 -- obj2=2
[   46.401628] Group @ container_of @ id
[   46.406580]  - Id # 34
[   46.406878]  - Obj1 # 22 -- obj1=2
[   46.407131]  - Obj2 # 12 -- obj2=2
[   46.407360] Group @ container_of @ obj1
[   46.407643]  - Id # 34
[   46.407889]  - Obj1 # 22 -- obj1=2
[   46.408230]  - Obj2 # 12 -- obj2=2
```

## Linked list
An example of how to kernel linked list interface.
- [linked_list.c](linked_list.c)

```
# insmod linked_list.ko
[  796.369350] ll: init
[  796.370399] Add nodes to the list...
[  796.371385] List is not empty
[  796.371567] Traverse the list...
[  796.371774]  #1: obj=0
[  796.371944]  #2: obj=1
[  796.372098]  #3: obj=2
[  796.372249]  #4: obj=3
[  796.372400]  #5: obj=4
[  796.372554] Delete all nodes from the list...
[  796.373165] List is empty
[  796.373361] Traverse the list...
#
# rmmod linked_list.ko
[  812.966234] ll: exit
#
```

## List process
An example of usage of `for_each_process`.
- [proc_info.c](proc_info.c)

```
#
# insmod proc_info.ko
[37227.566385] proinfo_module: init
[37227.575743]  PID                 NAME                STATE       TIME
[37227.576613]    1                 init          Stopped[In]   00:00:00
[37227.576974]    2             kthreadd          Stopped[In]   00:00:00
[37227.577241]    3               rcu_gp        Stopped[UnNo]   00:00:00
[37227.577522]    4           rcu_par_gp        Stopped[UnNo]   00:00:00
[37227.577779]    6         kworker/0:0H        Stopped[UnNo]   00:00:00
[37227.578037]    8         mm_percpu_wq        Stopped[UnNo]   00:00:00
[37227.578319]    9          ksoftirqd/0          Stopped[In]   00:00:00
[37227.578587]   10          rcu_preempt        Stopped[UnNo]   00:00:00
[37227.578865]   11          migration/0          Stopped[In]   00:00:00
[37227.579131]   12              cpuhp/0          Stopped[In]   00:00:00
[37227.579401]   13              cpuhp/1          Stopped[In]   00:00:00
[37227.579677]   14          migration/1          Stopped[In]   00:00:00
[37227.579971]   15          ksoftirqd/1          Stopped[In]   00:00:00
[37227.580296]   16          kworker/1:0        Stopped[UnNo]   00:00:00
[37227.580729]   17         kworker/1:0H        Stopped[UnNo]   00:00:00
[37227.581011]   18            kdevtmpfs          Stopped[In]   00:00:00
[37227.581280]   19                netns        Stopped[UnNo]   00:00:00
[37227.581555]   20      rcu_tasks_kthre          Stopped[In]   00:00:00
[37227.581847]   21          kworker/0:1        Stopped[UnNo]   00:00:00
[37227.582355]   22          kworker/1:1        Stopped[UnNo]   00:00:00
[37227.583305]   23              kauditd          Stopped[In]   00:00:00
[37227.583620]   24           oom_reaper          Stopped[In]   00:00:00
[37227.583998]   25            writeback        Stopped[UnNo]   00:00:00
[37227.584653]   26           kcompactd0          Stopped[In]   00:00:00
[37227.584988]   27                 ksmd          Stopped[In]   00:00:00
[37227.585294]   28           khugepaged          Stopped[In]   00:00:00
[37227.585603]   46               cryptd        Stopped[UnNo]   00:00:00
[37227.585935]   77          kintegrityd        Stopped[UnNo]   00:00:01
[37227.586283]   78              kblockd        Stopped[UnNo]   00:00:01
[37227.586657]   79       blkcg_punt_bio        Stopped[UnNo]   00:00:01
[37227.586986]   80           tpm_dev_wq        Stopped[UnNo]   00:00:01
[37227.587359]   81              ata_sff        Stopped[UnNo]   00:00:01
[37227.587705]   82          edac-poller        Stopped[UnNo]   00:00:01
[37227.588303]   83           devfreq_wq        Stopped[UnNo]   00:00:01
[37227.588645]   84            watchdogd          Stopped[In]   00:00:01
[37227.588950]   85               rpciod        Stopped[UnNo]   00:00:01
[37227.589260]   86         kworker/u5:0        Stopped[UnNo]   00:00:01
[37227.589598]   87              xprtiod        Stopped[UnNo]   00:00:01
[37227.589930]  146              kswapd0          Stopped[In]   00:00:02
[37227.590287]  147               nfsiod        Stopped[UnNo]   00:00:02
[37227.590615]  151         kworker/1:1H        Stopped[UnNo]   00:00:04
[37227.590950]  152      vfio-irqfd-clea        Stopped[UnNo]   00:00:04
[37227.591276]  153           jbd2/vda-8          Stopped[In]   00:00:05
[37227.591591]  154      ext4-rsv-conver        Stopped[UnNo]   00:00:05
[37227.592152]  155         kworker/0:1H        Stopped[UnNo]   00:00:05
[37227.592673]  170              syslogd          Stopped[In]   00:00:08
[37227.593004]  174                klogd          Stopped[In]   00:00:08
[37227.593326]  185           irqbalance          Stopped[In]   00:00:09
[37227.593589]  199          dbus-daemon          Stopped[In]   00:00:11
[37227.593881]  205              rpcbind          Stopped[In]   00:00:11
[37227.594208]  239               dhcpcd          Stopped[In]   00:00:15
[37227.594559]  245             dropbear          Stopped[In]   00:00:16
[37227.594881]  259            rpc.statd          Stopped[In]   00:00:20
[37227.595217]  275           rpc.mountd          Stopped[In]   00:00:21
[37227.595503]  280                   sh          Stopped[In]   00:00:22
[37227.595901]  290             dropbear          Stopped[In]   00:14:19
[37227.596589]  291                   sh          Stopped[In]   00:14:20
[37227.597007]  393          kworker/0:2        Stopped[UnNo]   01:41:33
[37227.597347]  594         kworker/u4:0        Stopped[UnNo]   09:54:22
[37227.597643]  599         kworker/u4:2        Stopped[UnNo]   10:07:30
[37227.598210]  615               insmod              running   10:20:26
[37227.598819]         Code Section: 0x0000000000400000 -- 0x0000000000418140
[37227.599265]         Data Section: 0x0000000000428cb8 -- 0x0000000000429380
[37227.599595]         Stack:        0x0000ffffca7d5ee0
[37227.600168]         Task size:    0x1000000000000
[37227.600428]         VMA Count:    21
[37227.600729]         VMA #  1: 0x0000000000400000 -- 0x0000000000419000
[37227.601051]         VMA #  2: 0x0000000000428000 -- 0x0000000000429000
[37227.601342]         VMA #  3: 0x0000000000429000 -- 0x000000000042a000
[37227.601660]         VMA #  4: 0x0000000017717000 -- 0x0000000017738000
[37227.601973]         VMA #  5: 0x0000ffff8358e000 -- 0x0000ffff835c7000
[37227.602305]         VMA #  6: 0x0000ffff835c7000 -- 0x0000ffff836f9000
[37227.602641]         VMA #  7: 0x0000ffff836f9000 -- 0x0000ffff83709000
[37227.602948]         VMA #  8: 0x0000ffff83709000 -- 0x0000ffff8370d000
[37227.603251]         VMA #  9: 0x0000ffff8370d000 -- 0x0000ffff8370f000
[37227.603589]         VMA # 10: 0x0000ffff8370f000 -- 0x0000ffff83713000
[37227.604284]         VMA # 11: 0x0000ffff83713000 -- 0x0000ffff83724000
[37227.604666]         VMA # 12: 0x0000ffff83724000 -- 0x0000ffff83733000
[37227.604967]         VMA # 13: 0x0000ffff83733000 -- 0x0000ffff83734000
[37227.605267]         VMA # 14: 0x0000ffff83734000 -- 0x0000ffff83735000
[37227.605555]         VMA # 15: 0x0000ffff83735000 -- 0x0000ffff83751000
[37227.605868]         VMA # 16: 0x0000ffff8375a000 -- 0x0000ffff8375e000
[37227.606198]         VMA # 17: 0x0000ffff8375e000 -- 0x0000ffff8375f000
[37227.606550]         VMA # 18: 0x0000ffff8375f000 -- 0x0000ffff83760000
[37227.606859]         VMA # 19: 0x0000ffff83760000 -- 0x0000ffff83761000
[37227.607190]         VMA # 20: 0x0000ffff83761000 -- 0x0000ffff83763000
[37227.607519]         VMA # 21: 0x0000ffffca7b6000 -- 0x0000ffffca7d7000
#
# rmmod proc_info.ko
[37230.392163] proinfo_module: exit
```

## kthread (simple)
An example of how to use kthread.
- [kthread_simple.c](kthread_simple.c)

```
# insmod kthread_simple.ko
[ 9474.072607] kt: init
[ 9474.073518] Setup kthread...
[ 9474.076664] Start kthread...
[ 9474.077022]  - Task: # 1
[ 9474.082249] kt_callback -- START
[ 9474.082694] kt_callback -- Doing working (4297260549)
# [ 9476.111992] kt_callback -- Doing working (4297261056)
r[ 9478.128113] kt_callback -- Doing working (4297261560)
mmod [ 9480.146799] kt_callback -- Doing working (4297262065)
# rmmod kthread_[ 9482.157011] kt_callback -- Doing working (4297262568)
# rmmod kthread_simple.ko
[ 9483.283668] kt: exit
[ 9484.175665] kt_callback -- END
#
```

## kthread (advanced)
An example of kthread which can put in different states using device interface.
- [kthread_advanced.c](kthread_advanced.c)

```
# insmod kthread_advanced.ko.ko
[ 6135.380992] cd: init
[ 6135.390749] Setup kthread...
[ 6135.394460] Start kthread...
[ 6135.395504]  - Task: # 1
[ 6135.396174] cd: device(/dev/chdev) is create
[ 6135.396968]  - Major number # 235
[ 6135.397738]  - minor number # 0
[ 6135.403838] kt_callback -- START
# [ 6138.411780] task_state -- running
[ 6141.579159] task_state -- running
[ 6144.610556] task_state -- running
[ 6147.719321] task_state -- running
[ 6150.742247] task_state -- running
[ 6153.808043] task_state -- running
[ 6156.849512] task_state -- running
[ 6159.874557] task_state -- running
[ 6162.898715] task_state -- running
[ 6164.638231] task_state -- suspend
[ 6188.854869] task_state -- resume
[ 6188.856184] task_state -- suspend
[ 6202.501738] task_state -- resume
[ 6205.512596] task_state -- running
[ 6208.534654] task_state -- running
[ 6211.562560] task_state -- running
[ 6214.760988] task_state -- running
[ 6217.886862] task_state -- running
[ 6220.920993] task_state -- running
[ 6223.951613] task_state -- running
[ 6226.992809] task_state -- running
[ 6230.017034] task_state -- running
[ 6233.042452] task_state -- running
[ 6235.684908] task_state -- stop
[ 6235.690136] kt_callback -- END

# rmmod kthread_advanced.ko
[ 6244.914722] cd: exit
#
```

```
# echo "1" > /dev/chdev
# echo "4" > /dev/chdev
# echo "4" > /dev/chdev
# echo "2" > /dev/chdev
```


# Locking
## mutex
An example of how to use mutex.
- [lock_mutex.c](lock_mutex.c)

```
# insmod lock_mutex.ko
[ 7179.267261] lockmod: init
[ 7179.268022] Setup mutex...
[ 7179.268274] Setup kthread...
[ 7179.288063] Start kthreads...
[ 7179.288489]  - Read task # 1
[ 7179.288761]  - Write task # 1
[ 7179.289633] lockmod_read_callback -- START
[ 7179.293438] lockmod_read_callback  -- Doing working (0)
[ 7179.298124] lockmod_write_callback -- START
# [ 7181.555485] lockmod_read_callback  -- Doing working (0)
rmmod [ 7185.613442] lockmod_read_callback  -- Doing working (2)
[ 7187.629618] lockmod_read_callback  -- Doing working (2)
# rmmod lock_mutex.ko
[ 7189.584263] lockmod: exit
[ 7190.671527] lockmod_write_callback -- END
[ 7190.676295] lockmod_read_callback  -- Doing working (3)
[ 7192.715941] lockmod_read_callback -- END
#

```

## spinlock
An example of how to use spin lock.
- [lock_spin_lock.c](lock_spin_lock.c)

```
# insmod lock_spin_lock.ko
[ 7463.213732] lockmod: init
[ 7463.214213] Setup spin lock...
[ 7463.214393] Setup kthread...
[ 7463.218114] Start kthreads...
[ 7463.219204]  - Read task # 1
[ 7463.219570]  - Write task # 1
[ 7463.226368] lockmod_read_callback -- START
[ 7463.226826] lockmod_read_callback  -- Doing working (0)
[ 7463.233915] lockmod_write_callback -- START
# [ 7465.263678] lockmod_read_callback  -- Doing working (2)
[ 7467.276488] lockmod_read_callback  -- Doing working (4)
[ 7469.304131] lockmod_read_callback  -- Doing working (6)
[ 7471.344288] lockmod_read_callback  -- Doing working (8)
[ 7473.360127] lockmod_read_callback  -- Doing working (10)
[ 7475.375307] lockmod_read_callback  -- Doing working (12)
[ 7477.388274] lockmod_read_callback  -- Doing working (14)
rmmod [ 7479.408382] lockmod_read_callback  -- Doing working (16)
# rmmod lock_s[ 7481.418612] lockmod_read_callback  -- Doing working (18)
# rmmod lock_spin_lock.ko
[ 7482.256574] lockmod: exit
[ 7482.699630] lockmod_write_callback -- END
[ 7483.438937] lockmod_read_callback -- END
#
```

## semaphore
An example of how to use semaphore.
- [lock_semaphore.c](lock_semaphore.c)

```
# insmod lock_semaphore.ko
[ 8589.386225] lockmod: init
[ 8589.386982] Setup mutex...
[ 8589.387193] Setup kthread...
[ 8589.394059] Start kthreads...
[ 8589.394808]  - Read task # 1
[ 8589.395052]  - Write task # 1
[ 8589.395939] lockmod_read_callback -- START
[ 8589.396214] lockmod_read_callback  -- Doing working (0)
[ 8589.407185] lockmod_write_callback -- START
# [ 8592.431087] lockmod_read_callback  -- Doing working (1)
[ 8595.522174] lockmod_read_callback  -- Doing working (2)
[ 8598.571031] lockmod_read_callback  -- Doing working (3)
[ 8601.611084] lockmod_read_callback  -- Doing working (4)
[ 8604.650775] lockmod_read_callback  -- Doing working (5)
[ 8607.692312] lockmod_read_callback  -- Doing working (6)
rmmod [ 8610.733015] lockmod_read_callback  -- Doing working (7)
# rmmod lock_semaphore.ko [ 8613.773242] lockmod_read_callback  -- Doing working (8)

[ 8613.975061] lockmod: exit
[ 8616.812814] lockmod_write_callback -- END
[ 8616.818651] lockmod_read_callback  -- Doing working (9)
[ 8618.903293] lockmod_read_callback -- END
#
```

## rw-semaphore
An example of how to use rw-semaphore.
- [lock_rw_semaphore.c](lock_rw_semaphore.c)

```
# insmod lock_rw_semaphore.ko
[ 9332.805410] lockmod: init
[ 9332.806475] Setup rw-semaphore...
[ 9332.806796] Setup kthread...
[ 9332.811062] Start kthreads...
[ 9332.811766]  - Read task # 0: 1
[ 9332.812147]  - Read task # 1: 1
[ 9332.812593]  - Write task: # 1
[ 9332.816513] lockmod_read_callback0 -- START
[ 9332.816929] lockmod_read_callback0  -- Doing working (0)
[ 9332.817811] lockmod_read_callback1 -- START
[ 9332.818152] lockmod_read_callback1  -- Doing working (0)
[ 9332.832991] lockmod_write_callback -- START
# [ 9335.856640] lockmod_read_callback0  -- Doing working (1)
[ 9335.857343] lockmod_read_callback1  -- Doing working (1)
[ 9339.122699] lockmod_read_callback0  -- Doing working (2)
[ 9339.125193] lockmod_read_callback1  -- Doing working (2)
[ 9342.193709] lockmod_read_callback0  -- Doing working (3)
[ 9342.194847] lockmod_read_callback1  -- Doing working (3)
[ 9345.231656] lockmod_read_callback1  -- Doing working (4)
[ 9345.234824] lockmod_read_callback0  -- Doing working (4)
rmmod [ 9348.270767] lockmod_read_callback0  -- Doing working (5)
[ 9348.275197] lockmod_read_callback1  -- Doing working (5)
# rmmod lock_rw_semaphore.ko
[ 9351.188662] lockmod: exit
[ 9351.328923] lockmod_write_callback -- END
[ 9351.332399] lockmod_read_callback0  -- Doing working (6)
[ 9351.335479] lockmod_read_callback1  -- Doing working (6)
[ 9353.356717] lockmod_read_callback0 -- END
[ 9353.361283] lockmod_read_callback1 -- END
#

```

# Character device
## Simple
An example of how to create device interface using kernel kernel module.
- [char_device.c](char_device.c)

```
# insmod char_device.ko
[10284.207744] cd: init
[10284.217666] cd: device(/dev/chdev) is create
[10284.218597]  - Major number # 235
[10284.218850]  - minor number # 0
# ls -l /dev/chdev
crw-------    1 root     root      235,   0 Jan 29 19:04 /dev/chdev
# rmmod char_device.ko
[10298.025055] cd: exit
# ls -l /dev/c
console          cpu_dma_latency
# ls -l /dev/c
```

## With File I/O
A character device with FILE I/O support.
- [char_device_fops.c](char_device_fops.c)

```
# insmod char_device_fops.ko
[10396.352119] cd: init
[10396.363753] cd: device(/dev/chdev) is create
[10396.364155]  - Major number # 235
[10396.364401]  - minor number # 0
# ls -l /dev/chdev
crw-------    1 root     root      235,   0 Jan 29 19:05 /dev/chdev
# echo "test" > /dev/chdev
[10412.121341] cd: open
[10412.133604] cd: write (0)
[10412.135953] cd: release
[10412.136453] === Data found from user ===
[10412.137117] test
[10412.137433]
[10412.137433] ============================
#
# rmmod char_device_fops.ko
[10441.172617] cd: exit
#
```

## With Sysfs
A kernel module with sysfs interface.
- [char_device_sysfs.c](char_device_sysfs.c)

```
# insmod char_device_sysfs.ko
[22321.545163] cd: init
[22321.553631] cd: device(/dev/chdev) is create
[22321.554598]  - Major number # 235
[22321.554860]  - Minor number # 0
[22321.555283] Sysfs interface # /sys/chdev/root
# ls -l /sys/chdev/root/
total 0
-r--r--r-- 1 root root 4096 Feb  2 03:07 readonly
-rw-r--r-- 1 root root 4096 Feb  2 03:07 readwrite
# cat /sys/chdev/root/readonly
100
# cat /sys/chdev/root/readwrite
0
# echo "10" > /sys/chdev/root/readonly
-sh: can't create /sys/chdev/root/readonly: Permission denied
# echo "10" > /sys/chdev/root/readwrite
[22364.447180] readwrite = 10
# cat /sys/chdev/root/readwrite
10
# rmmod char_device_sysfs.ko
[22377.447454] cd: exit
```

# Timer
## Simple
An example how to use timer.
- [timer.c](timer.c)

```
# insmod timer.ko
[10872.794497] trmod: init
[10872.794922] Setup timer...
[10872.795101] Setup timeout...
# [10873.059272] trmod_timer_callback -- START
[10873.062645] trmod_timer_callback -- Doing working
[10873.064049] trmod_timer_callback -- END

# rmmod timer.ko
[10881.401745] trmod: exit
[10881.402717] Delete timer...
#
```

## hr-timer (one shot)
An example how to use higher resolution timer.
- [timer_hr.c](timer_hr.c)

```
# insmod timer_hr.ko
[11207.958620] hr: init
[11207.959071] Setup timer...
[11207.959256] Start timer...
[11207.965159] hr_timer_callback -- START
[11207.965442] hr_timer_callback -- Doing working
[11207.965639] hr_timer_callback -- END
# rmmod timer_hr.ko
[11248.155893] hr: exit
[11248.156897] Delete timer...
#
```

## hr-timer (Repetitive)
An example how to use higher resolution timer in repetitive mode.
- [timer_hr_repetitive.c](timer_hr_repetitive.c)

```
# insmod timer_hr_repetitive.ko
[ 7170.911353] hr: init
[ 7170.911731] Setup timer...
[ 7170.912005] Start timer...[4296684756 jiffies]
# [ 7172.917504] hr_timer_callback [4296685258 jiffies]
[ 7174.921212] hr_timer_callback [4296685759 jiffies]
[ 7176.961923] hr_timer_callback [4296686269 jiffies]
[ 7178.921332] hr_timer_callback [4296686759 jiffies]
[ 7180.914419] hr_timer_callback [4296687257 jiffies]
[ 7182.916584] hr_timer_callback [4296687758 jiffies]
[ 7184.918601] hr_timer_callback [4296688258 jiffies]
[ 7186.915450] hr_timer_callback [4296688757 jiffies]
[ 7188.921728] hr_timer_callback [4296689259 jiffies]
[ 7190.914254] hr_timer_callback [4296689757 jiffies]
[ 7192.913470] hr_timer_callback [4296690257 jiffies]
[ 7194.981200] hr_timer_callback [4296690774 jiffies]
[ 7196.914013] hr_timer_callback [4296691257 jiffies]
[ 7198.915422] hr_timer_callback [4296691757 jiffies]
[ 7200.917294] hr_timer_callback [4296692258 jiffies]
[ 7202.916724] hr_timer_callback [4296692758 jiffies]
[ 7204.917354] hr_timer_callback [4296693258 jiffies]
[ 7206.916150] hr_timer_callback [4296693757 jiffies]
[ 7208.914838] hr_timer_callback [4296694257 jiffies]
[ 7210.913370] hr_timer_callback [4296694757 jiffies]
[ 7212.917794] hr_timer_callback [4296695258 jiffies]
[ 7214.914670] hr_timer_callback [4296695757 jiffies]
[ 7216.915138] hr_timer_callback [4296696257 jiffies]
[ 7218.914531] hr_timer_callback [4296696757 jiffies]
[ 7220.915391] hr_timer_callback [4296697257 jiffies]
[ 7222.917358] hr_timer_callback [4296697758 jiffies]
[ 7224.920391] hr_timer_callback [4296698258 jiffies]
[ 7226.915757] hr_timer_callback [4296698757 jiffies]
[ 7228.915967] hr_timer_callback [4296699257 jiffies]
[ 7230.838390] hr: exit
[ 7230.838771] Delete timer...
```

# Worker
## Tasklet
An example of how to use tasklet.
- [tasklet.c](tasklet.c)

```
# insmod tasklet.ko
[11354.444642] tl: init
[11354.445198] tl_tasklet_func: Tasklet data
# rmmod tasklet.ko
[11363.968424] tl: exit
#
```

## Wait Queue
An example of how to use wait queue.
- [wait_queue.c](wait_queue.c)

```
# insmod wait_queue.ko
[ 9391.472501] wq: init
[ 9391.473955] Create work to be done...
[ 9391.475053] Create work to be done...
[ 9391.475763] wq_work_handler -- START
[ 9391.476074] wq_work_handler -- Doing working
[ 9391.476546] Going to suspend until is not done...
[ 9401.613610] wq_work_handler -- Work is done
[ 9401.616389] wq_work_handler -- END
[ 9401.617546] Wow! work is complete...
[ 9401.617838] wq: Bye!
# rmmod wait_queue.ko
[ 9405.778917] wq: exit
```


## Work queue
### Simple
An example of how to use work queue.
- [work_queue_simple.c](work_queue_simple.c)

```
# insmod work_queue_simple.ko
[16189.731808] wq: init
[16189.732197] Create work queue...
[16189.742714] Create work to be done...
[16189.743025] Queue a work...
[16189.743399] wq_work_handler -- START
[16189.743596] wq_work_handler -- Doing working
[16189.743901] wq: init -- end
# [16215.442424] wq_work_handler -- END
# rmmod work_queue_simple.ko
[16822.548017] wq: exit
#
```

### Delayed
An example of how to use work queue with delayed functionality.
- [work_queue_delayed.c](work_queue_delayed.c)

```
# insmod work_queue_delayed.ko
[ 6649.250160] wq: init
[ 6649.250957] Create work queue...
[ 6649.253994] Create work to be done...
[ 6649.254922] Queue a work...
[ 6649.255207] Current time: 4296554471 jiffies
[ 6649.255641] wq: init -- end
# [ 6659.457128] wq_work_handler -- START [4296557021 jiffies]
[ 6659.461149] wq_work_handler -- Doing working
[ 6669.584246] wq_work_handler -- END

# rmmod work_queue_delayed.ko
[ 6680.596487] wq: exit
#
```
# License
[MIT](LICENSE)
