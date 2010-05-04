;; -*- emacs-lisp -*-

(setq debian-changelog-mailing-address "dottedmag@dottedmag.net")
(setq debian-changelog-full-name "Mikhail Gusarov")

; OpenInkpot-specific changes to debian-changelog-mode

(require 'debian-changelog-mode nil t)

(if (fboundp 'debian-changelog-mode)
    (defun debian-changelog-add-version ()
      "Add a new version section to a debian-style changelog file.
 If file is empty, create initial entry."
      (interactive)
      (if (not (= (point-min)(point-max)))
          (let ((f (debian-changelog-finalised-p)))
            (and (stringp f) (error f))
            (or f (error "Previous version not yet finalised"))))
      (goto-char (point-min))
      (let ((pkg-name (or (debian-changelog-suggest-package-name)
                          (read-string "Package name: ")))
            (version (or (debian-changelog-suggest-version)
                         (read-string "New version (including any revision): "))))
        (if (debian-changelog-experimental-p)
            (insert pkg-name " (" version ") experimental; urgency=low\n\n  * ")
          (insert pkg-name " (" version ") unstable; urgency=low\n\n  * "))
        (run-hooks 'debian-changelog-add-version-hook)
        (save-excursion (insert "\n\n --\n\n")))))
