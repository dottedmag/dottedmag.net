## Grouping fds

Grouping: events in a group are always sampled at the same time, so they are
meaningful.

Output redirection: send events to a given fd

* No grouping, no output redirection: `perf_event_open(group_fd=-1, flags=0)`
* Grouping: `perf_event_open(group_fd>=-1, flags=0)`
* Grouping + output redirection: `perf_event_open(group_fd>=-1, flags=PERF_FLAG_FD_OUTPUT)`
* Output redirection: `perf_event_open(group_fd>=-1, flags=PERF_FLAG_FD_NO_GROUP|PERF_FLAG_FD_OUTPUT)`

- Create first event fd with group_fd=-1
- Create all other event fds with group_fd of first event fd

## Sampling

sample_period misnamed. N events: save into ring buffer.
freq+sample_freq. N ticks: save into ring buffer.

sigtrap, sig_data
watermark, wakeup_watermark, wakeup_events: overflow notification levels

write_backward

sample_type: bitfield what to include into ring buffer
read_format: bitfield what to include into fd data

disabled, exnable_on_exec

inherit, inherit_thread

- pinned to CPU
- exclusive to CPU

exclude: userspace, kernel space, hypervisor, idle, host, guest, callchain_kernel, callchain_user

mmap, comm, task, precise_ip, mmap_data, sample_id_all, mmap2, comm_exec, use_clockid, context_switch
namespaces, ksymbol, bpf_event, aux_output, text_poke, build_id, bp_type, bp_addr, bp_len,
branch_sample_type, sample_regs_user, sample_stack_user, clockid, aux_watermark, sample_max_stack,
aux_sample_size

cgroup

## Reading from fd

Always available? struct read_format.

## Overflow

select: POLLIN/POLLHUP

## Events

A ton of.

## rdpmc?

## ioctls

- `IOC_ENABLE`/`IOC_DISABLE`: enable
- `IOC_REFRESH`: overflow notifications counter
- `IOC_RESET`: reset counter
- `IOC_PERIOD`: set period (time?)
- `IOC_SET_OUTPUT`: event notifications to another fd
- `IOC_SET_FILTER`: ftrace filter (?)
- `IOC_ID` return event ID (?)
- `IOC_SET_BPF` attach BPF to kprobe tracepoint event
- `IOC_QUERY_BPF`: return ID of BPF program (?)
- `IOC_PAUSE_OUTPUT`: put/don't put anything into ring buffer, discard and update PERF_RECORD_LOST
- `MODIFY_ATTRIBUTES`: update event (breakpoint events only)

## prctls

`PR_TASK_PERF_EVENTS_{ENABLE,DISABLE}`
