(use-package magit
  :commands (magit-status magit-clone magit-blame magit-log)
  :custom
  ;; full-frame status — no split-window clutter
  (magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)
  ;; save buffers without asking before magit operations
  (magit-save-repository-buffers 'dontask)
  ;; show word-level diff highlighting on all hunks
  (magit-diff-refine-hunk 'all)
  ;; show full commit message in log, not just first line
  (magit-log-margin '(t "%Y-%m-%d %H:%M" magit-log-margin-width t 18))
  ;; when staging, stay on the current hunk instead of jumping to next
  (magit-diff-visit-previous-blob nil)
  ;; auto-show the process buffer if a git command takes too long
  (magit-process-popup-time 3)
  ;; show recent commits in status buffer
  (magit-log-section-commit-count 20)

  :config
  ;; show the full diff in commit buffer so you see what you're committing
  (setq magit-commit-show-diff t)
  ;; speed up status buffer by not running expensive git operations
  (setq magit-refresh-status-buffer t)
  ;; word-level granularity in diffs
  (setq magit-diff-adjust-tab-width t))

;; show TODOs/FIXMEs in magit status buffer
(use-package magit-todos
  :after magit
  :config (magit-todos-mode 1))

;; git diff indicators in the fringe — shows added/modified/deleted lines
(use-package diff-hl
  :config
  (global-diff-hl-mode 1)
  ;; update fringe indicators after magit operations
  (add-hook 'magit-pre-refresh-hook  #'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh)
  ;; also show diff indicators in dired
  (add-hook 'dired-mode-hook #'diff-hl-dired-mode)
  ;; in terminal (Blink/iPhone), use the margin instead of fringe
  (unless (display-graphic-p)
    (diff-hl-margin-mode 1)))

;; git-timemachine: step through every revision of a file
;; M-n / M-p to walk forward/back through history
(use-package git-timemachine
  :commands git-timemachine)

;; gitignore-templates: quickly generate .gitignore files
;; M-x gitignore-templates-new-file
(use-package gitignore-templates
  :commands (gitignore-templates-insert
             gitignore-templates-new-file))

;; ── repo shortcuts ──────────────────────────────
;; quick magit access for active repos
;; keybindings will live in the keybindings file
(defun my/magit-billwear ()
  "Open magit for billwear.github.io."
  (interactive)
  (magit-status "~/billwear.github.io"))

(defun my/magit-way-of-emacs ()
  "Open magit for the-way-of-emacs site."
  (interactive)
  (magit-status "~/the-way-of-emacs"))

;; generic repo jumper — ivy-powered pick list of your repos
(defvar my/repo-list
  '(("billwear.github.io" . "~/billwear.github.io")
    ("the-way-of-emacs"   . "~/the-way-of-emacs"))
  "Alist of repo names and paths for quick magit access.")

(defun my/magit-repo ()
  "Pick a repo from my/repo-list and open magit there."
  (interactive)
  (let* ((name (completing-read "Repo: " (mapcar #'car my/repo-list)))
         (path (cdr (assoc name my/repo-list))))
    (magit-status path)))
