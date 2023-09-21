### DMA fences

- poll
- `SYNC_IOC_MERGE`
- `SYNC_IOC_FILE_INFO`

### Display control
- `DRM_IOCTL_CRTC_GET_SEQUENCE`
- `DRM_IOCTL_CRTC_QUEUE_SEQUENCE`
- `DRM_IOCTL_WAIT_VBLANK`

### Memory management
- `DRM_IOCTL_GEM_CLOSE`
- `DRM_IOCTL_PRIME_FD_TO_HANDLE`
- `DRM_IOCTL_PRIME_HANDLE_TO_FD`

### Modesetting
- `DRM_IOCTL_MODE_CURSOR2` pre-atomic, but still required for forwarding `hot_x`/`hot_y`

### Synchronization
- `DRM_IOCTL_SYNCOBJ_CREATE` (-> flags (CREATE_SIGNALED), <- handle)
- `DRM_IOCTL_SYNCOBJ_DESTROY` (-> handle)
- `DRM_IOCTL_SYNCOBJ_FD_TO_HANDLE` (-> fd, flags (IMPORT_SYNC_FILE), <- handle) (??? flags)
- `DRM_IOCTL_SYNCOBJ_HANDLE_TO_FD` (-> handle, flags (EXPORT_SYNC_FILE), <- fd) (??? flags)
  fds are opaque, and can only be used for passing around

  (EXPORT|IMPORT)_SYNC_FILE export a fence instead of syncobj
- `DRM_IOCTL_SYNCOBJ_QUERY` (-> handles, flags (LAST_SUBMITTED), <- points) (???)
- `DRM_IOCTL_SYNCOBJ_RESET` (-> handles)
- `DRM_IOCTL_SYNCOBJ_SIGNAL` (-> handles)
- `DRM_IOCTL_SYNCOBJ_TRANSFER` (-> src_handle, dst_handle, src_point, dst_point, flags) (???)
- `DRM_IOCTL_SYNCOBJ_WAIT` (-> handles, flags (WAIT_ALL (otherwise wait for one), WAIT_FOR_SUBMIT)) (???)

- `DRM_IOCTL_SYNCOBJ_TIMELINE_SIGNAL` (-> handles, points) (???)
- `DRM_IOCTL_SYNCOBJ_TIMELINE_WAIT` (-> handles, flags (WAIT_ALL (otherwise wait for one), WAIT_FOR_SUBMIT, WAIT_AVAILABLE (fence materializes, unsignalled))) (???)

### Obsolete

### Framebuffer handling
- `DRM_IOCTL_MODE_DIRTYFB` ?? - only for frontbuffer
- `DRM_IOCTL_GEM_FLINK` - use PRIME
- `DRM_IOCTL_GEM_OPEN` - use PRIME

Superseded by atomic:
- `DRM_IOCTL_MODE_SETPROPERTY` -- this is for connector only
- `DRM_IOCTL_MODE_PAGE_FLIP`
- `DRM_IOCTL_MODE_OBJ_SETPROPERTY`
- `DRM_IOCTL_MODE_SETPLANE`
- `DRM_IOCTL_MODE_SETCRTC`
- `DRM_IOCTL_MODE_GETGAMMA`
- `DRM_IOCTL_MODE_SETGAMMA`

Superseded by *2
- `DRM_IOCTL_MODE_ADDFB`
- `DRM_IOCTL_MODE_RMFB`

Not needed if pageflipping:
`DRM_IOCTL_DIRTYFB` marks specific region of framebuffer as dirty.

- `DRM_IOCTL_MODE_CURSOR`
- `DRM_IOCTL_MODESET_CTL`
- `DRM_IOCTL_GET_STATS`
- `DRM_IOCTL_GET_CLIENT`
- `DRM_IOCTL_GET_UNIQUE`
`DRM_IOCTL_SET_VERSION` `ioctl` sets the version of DRM interface
to:
- change the value returned by `DRM_IOCTL_GET_UINQUE`, however this `ioctl`
  exists only for backward compatibility,
- `DRM_IOCTL_GET_MAGIC` (obsolete?)
- `DRM_IOCTL_AUTH_MAGIC` (obsolete?)

These `ioctl`s are either explicitly marked as legacy, or stubbed out in kernel.

- `DRM_IOCTL_SET_UNIQUE`
- `DRM_IOCTL_IRQ_BUSID`
- `DRM_IOCTL_GET_MAP`
- `DRM_IOCTL_ADD_MAP` ??
- `DRM_IOCTL_RM_MAP` ??
- `DRM_IOCTL_GET_SAREA_CTX` ??
- `DRM_IOCTL_SET_SAREA_CTX` ??
- `DRM_IOCTL_ADD_CTX`
- `DRM_IOCTL_RM_CTX`
- `DRM_IOCTL_MOD_CTX`
- `DRM_IOCTL_GET_CTX`
- `DRM_IOCTL_SWITCH_CTX`
- `DRM_IOCTL_NEW_CTX`
- `DRM_IOCTL_RES_CTX`
- `DRM_IOCTL_UNLOCK`
- `DRM_IOCTL_LOCK`
- `DRM_IOCTL_ADD_BUFS` ??
- `DRM_IOCTL_MARK_BUFS` ??
- `DRM_IOCTL_INFO_BUFS` ??
- `DRM_IOCTL_MAP_BUFS` ??
- `DRM_IOCTL_FREE_BUFS` ??
- `DRM_IOCTL_DMA`
- `DRM_IOCTL_CONTROL`
- `DRM_IOCTL_SG_ALLOC`
- `DRM_IOCTL_SG_FREE`
- `DRM_IOCTL_FINISH`. Noop.
- `DRM_IOCTL_BLOCK`. Noop.
- `DRM_IOCTL_UNBLOCK`. Noop.
- `DRM_IOCTL_ADD_DRAW`. Noop.
- `DRM_IOCTL_RM_DRAW`. Noop.
- `DRM_IOCTL_UPDATE_DRAW`. Noop.
- `DRM_IOCTL_MODE_ATTACHMODE`. Noop.
- `DRM_IOCTL_MODE_DETACHMODE`. Noop.

AGP[^agp]-specific `ioctl`s:
- `DRM_IOCTL_AGP_ACQUIRE`
- `DRM_IOCTL_AGP_ALLOC`
- `DRM_IOCTL_AGP_BIND`
- `DRM_IOCTL_AGP_ENABLE`
- `DRM_IOCTL_AGP_FREE`
- `DRM_IOCTL_AGP_INFO`
- `DRM_IOCTL_AGP_RELEASE`
- `DRM_IOCTL_AGP_UNBIND`

## Driver-specific `ioctl`s

An an example `virtio-gpu` implements the following set:

- `DRM_IOCTL_VIRTGPU_MAP`
- `DRM_IOCTL_VIRTGPU_EXECBUFFER`
- `DRM_IOCTL_VIRTGPU_GETPARAM`
- `DRM_IOCTL_VIRTGPU_RESOURCE_CREATE`
- `DRM_IOCTL_VIRTGPU_RESOURCE_INFO`
- `DRM_IOCTL_VIRTGPU_TRANSFER_FROM_HOST`
- `DRM_IOCTL_VIRTGPU_TRANSFER_TO_HOST`
- `DRM_IOCTL_VIRTGPU_WAIT`
- `DRM_IOCTL_VIRTGPU_GET_GAPS`
- `DRM_IOCTL_VIRTGPU_RESOURCE_CREATE_BLOB`
- `DRM_IOCTL_VIRGPU_CONTEXT_INIT`

## References

- https://keithp.com/blogs/DRM-lease/

## Footnotes

[^agp]:
	Does anyone remember AGP nowadays?
