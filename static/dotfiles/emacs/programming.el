;; -*- emacs-lisp -*-

;;
;; Stuff related to all programming activities (version control, compilation etc)
;;

(setq compilation-ask-about-save nil
      vc-follow-symlinks t
      cvs-auto-remove-directories nil
      vc-handled-backends '(RCS CVS SVN SCCS Bzr Git Hg Arch MCVS))

(setq-default tab-width 4
              indent-tabs-mode nil)
