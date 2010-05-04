;; -*- emacs-lisp -*-

;
; Remapping keyboard to feel comfortable in Emacs with Dvorak layout
; Switches C-q <-> C-x and M-q <-> M-x
;

(defun dvorak-frame-setup (frame)
  (let ((sf (selected-frame)))
    (unwind-protect
        (progn
          (select-frame frame)
          (keyboard-translate ?\C-q ?\C-x)
          (keyboard-translate ?\C-x ?\C-q)
          (keyboard-translate ?\C-Q ?\C-X)
          (keyboard-translate ?\C-X ?\C-Q))
      (select-frame-set-input-focus sf))))

(add-hook 'after-make-frame-functions 'dvorak-frame-setup)

(dvorak-frame-setup (selected-frame))

(global-set-key "\M-x" 'fill-paragraph)
(global-set-key "\M-q" 'execute-extended-command)
