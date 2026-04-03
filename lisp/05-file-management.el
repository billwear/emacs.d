;; remember where I was in each file
(save-place-mode 1)

;; remember recent files
(recentf-mode 1)
(setq recentf-max-saved-items 200
      recentf-max-menu-items 25)

;; persist minibuffer history across sessions
(savehist-mode 1)

;; follow symlinks to vc-tracked files without asking
(setq vc-follow-symlinks t)

;; ── centralize all emacs file debris in
;; ~/var/archive/emacs
(defvar my/archive-root (expand-file-name "~/var/archive/emacs"))
(defvar my/backup-dir   (expand-file-name "backups"   my/archive-root))
(defvar my/autosave-dir (expand-file-name "auto-save" my/archive-root))

;; create the whole tree if missing
(dolist (dir (list my/archive-root my/backup-dir my/autosave-dir))
  (unless (file-directory-p dir)
    (make-directory dir t)))

;; backups: versioned, by copy, in one place
(setq backup-directory-alist `(("." . ,my/backup-dir))
      backup-by-copying t
      version-control t
      kept-new-versions 6
      kept-old-versions 2
      delete-old-versions t)

;; auto-save files: same neighborhood
(setq auto-save-file-name-transforms
      `((".*" ,my/autosave-dir t)))

;; lock files: don't create them at all
;; single user, syncthing handles conflicts
(setq create-lockfiles nil)

;; org archive target: grouped by source file
(setq org-archive-location
      (concat my/archive-root "/archive.org::* From %s"))

;; keep recentf clean — exclude noise
(setq recentf-exclude
      '("/tmp/" "/ssh:" "/sudo:" "\\.git/" "COMMIT_EDITMSG"
        "/var/" "\\.elc$" "/elpa/"))

;; save all buffers when Emacs loses focus
(add-hook 'focus-out-hook
          (lambda () (save-some-buffers t)))

;; auto-revert files changed on disk (syncthing, git)
(global-auto-revert-mode 1)
(setq auto-revert-use-notify t
      auto-revert-avoid-polling t
      auto-revert-verbose nil)        ; don't announce every revert
;; also revert dired buffers (directory listings go stale)
(setq global-auto-revert-non-file-buffers t)

;; delete-by-moving-to-trash — recoverable mistakes
(setq delete-by-moving-to-trash t)


