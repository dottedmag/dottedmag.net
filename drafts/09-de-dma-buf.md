title: dma-buf
date: 2023-08-30
----
`dma-buf` is a Linux mechanism to share memory buffers and synchronization primitives
known as _fences_[^future] between processes and devices.

### Buffers

`dma-buf` buffer is a chunk of memory, residing anywhere in the system, including memory
locations not directly accessible to CPUs. Kernel takes care of synchronizing access to them
and issuing DMA requests as needed. These buffers are represented in userspace as file
descriptors (so they can be transferred between processes and inherited across `execve`).

There aren't many oprations userspace can use on them:
- `llseek(fd, 0, SEEK_END)` to determine buffer size
- `mmap`. This may involve copying data to CPU-accessible memory, so
  - it might be slow
  - it needs to be bracketed by `ioctl(DMA_BUF_SYNC_*)` to let kernel know when
    userspace has started or finished reading/writing the memory.

More useful operation is passing buffers to some kernel APIs that expect them,
thus allowing cross-device memory management without explicit copying through
CPU-accessible buffers.

Buffers may have fences attached to them, described below.

### Fences

`dma-buf` fence is a synchronization primitive. It starts in a unready state and
becomes ready at some point in future. Typically becoming ready signifies completion
of some operation (DMA transfer, GPU rendering etc).

Fences are represented in userspace as file descriptors, with one file descriptor
potentially representing several fences.

Fences come from several sources:
- attached to `dma-buf` buffers
- GPU-specific command buffer submission `ioctl`s return fences
- atomic KMS operations return fences
- `drm_syncobj` objects can export and import fences

There are several operations userspace can perform on these descriptors:
- `ioctl(SYNC_IOC_MERGE)` merges two fence file descriptors into one
- `ioctl(SYNC_IOC_FILE_INFO)` returns detailed information about the file descriptor
- `poll` to see if the all fences on file descriptor are ready

TBD

### Fences attached to buffers

TBD

- `poll` to see if fences attached to the buffer are ready.
- `ioctl(DMA_BUF_IOCTL_EXPORT_SYNC)` to retrieve fences attached to the buffer.
- `ioctl(DMA_BUF_IOCTL_IMPORT_SYNC)` to attach fences to the buffer.

## Footnotes

[^future]:
	Most of the world knows them as _futures_.
