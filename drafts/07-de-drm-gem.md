## GEM

### libgbm

`libgbm`[^gbm] is a part of Mesa. It provides GPU/CPU memory allocation functions for
GPUs supported by Mesa.

Multiple GPU drivers provide their own unique `ioctl`s to manage memory, and Mesa works
with all these drivers. The result is `libgbm` that takes all these unique `ioctl`s and
exposes a uniform interface on top of them[^whygbm].

#### Initialization

`libgbm` provides a convoluted backend loader mechanism that on practice boils
down to "use DRM backend". There are no other open source backends.

One passes DRM fd to `gbm_create_device` and gets back `gbm_device *` to be used in other
GBM functions.

#### Device

Device can be used to query if the pixel format supported (`gbm_device_is_format_supported`), and how many separate
planes a pixel format+modifier actually have (`gbm_device_get_format_modifier_plane_count`).

#### BO

BO stands for "buffer object" and is a piece of memory with attached metadata, such as
width, height and pixel format.

Creating a BO (`gbm_bo_create_with_modifiers2`) requires a pixel format, pixel modifiers,
a pixel size, and a number of flags to request the capabilities of the BO:
- `GBM_BO_USE_SCANOUT` if the resulting BO should be assignable to a framebuffer
- `GBM_BO_USE_CURSOR` if the resulting BO should be assignable to a cursor framebuffer
- `GBM_BO_USE_RENDERING` if the BO should be usable for rendering source/target in Mesa. Seems to be ignored.
- `GBM_BO_USE_WRITE` if the BO should be usable in `gbm_bo_write`. Guaranteed for `GBM_BO_USE_CURSOR`, but not for others.
- `GBM_BO_USE_LINEAR` if the BO should be linear (not tiled)
- `GBM_BO_USE_PROTECTED` if the BO is DRMed[^drmdrm]
- `GBM_BO_USE_FRONT_RENDERING` - buffer can be used for front framebuffer. Seems to only matter for a single GPU driver.

When no longer needed BO is to be destroyed using `gbm_bo_destroy`.

##### Manipulation

Once created, BO can be interrogated for values such as GEM handles and fds (`gbm_bo_handle_for_plane`, `gbm_bo_get_fd_for_plane`),
or bits-per-pixel (`gbm_bo_get_bpp`).

If `GBM_BO_USE_WRITE` was requested, then data can be written to BO using `gbm_bo_write`.

Buffer can also be mapped into the userspace (possibly using shadow buffer for non-unified memory).
This is done by `gbm_bo_map` / `gbm_bo_unmap`.

`gbm_bo_map` takes a number of flags to control the mapping:
- `GBM_BO_TRANSFER_READ` to read from the buffer (possibly receiving data from GPU memory at map)
- `GBM_BO_TRANSFER_WRITE` to write to the buffer (possibly sending data from shadow buffer to GPU memory at unmap)
- `GBM_BO_TRANSFER_READ_WRITE` for both reading and writing

##### Usage

One can obtain a GEM handle (`gbm_bo_get_handle_for_plane`) or dmabuf fd (`gbm_bo_get_fd_for_plane`) for a BO plane
and use it anywhere these resources are used.

##### Import

There are foreign objects that can be imported into a BO (`gbm_bo_import`):
- EGLImage wrapped in Mesa's `EGLImage*`
- dmabuf wrapped in libwayland's `wl_buffer`.
- dmabuf(s) fds plus metadata (width, height, format, strides, offsets, modifier)

Created BO has its lifetime separate from the underlying object.

#### Surface

There is also a GBM surface object for interaction with EGL, to be explained in a later article.

### PRIME

## Footnotes

[^gbm]:
	Generic buffer manager
[^whygbm]:
	I guess the idea is the following: Linux ABI is backward-compatible, so exposing any
	abstraction there would immediately set it in stone. `libgbm` does not have this
	backward-compatibility guarantee, so if the abstraction turns out to be wrong it can
	be fixed. Only low-level graphics hardware details are exposed via Linux ABI, as those
	are hard to get wrong as long as they directly map to hardware.
[^drmdrm]:
	This time it is digital rights management: BOs thus marked will not expose their data
	to "insecure" outputs.
