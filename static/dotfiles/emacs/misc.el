;; -*- emacs-lisp -*-

; remove GNU advertisments
(mapcar 'global-unset-key
        '("\C-h\C-c" "\C-h\C-d" "\C-h\C-p" "\C-h\C-w" "\C-hn" "\C-h\C-n"
          "\C-hP" "\C-h\C-n" "\C-h\C-m" "\C-hF"))

(defun my-switch-to-ibuffer ()
  (interactive)
  (list-buffers)
  (ibuffer)
  (delete-other-windows))

(global-set-key (kbd "C-M-s") 'my-switch-to-ibuffer)

(require 'ido)
(ido-mode t)
