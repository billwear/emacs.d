;;; 20-functions.el --- convenience functions -*- lexical-binding: t -*-

(defun my/edit-init ()
  "Open the lisp/ config directory for editing."
  (interactive)
  (find-file (expand-file-name "lisp" user-emacs-directory)))

(defun my/insert-date-and-time ()
  "Insert ISO timestamp with epoch."
  (interactive)
  (insert (format-time-string "%Y-%m-%d %H:%M:%S (%s)")))

(defun my/insert-time-and-epoch ()
  "Insert time and epoch."
  (interactive)
  (insert (format-time-string "%H:%M (%s)")))

(defun my/show-hybrid-agenda ()
  "Show the org agenda in 3-day view."
  (interactive)
  (org-agenda nil "n"))

(defun my/kill-other-buffers ()
  "Kill all buffers except the current one."
  (interactive)
  (mapc #'kill-buffer
        (delq (current-buffer) (buffer-list)))
  (message "All other buffers killed."))

(defun my/scratch ()
  "Jump to (or create) the scratch buffer."
  (interactive)
  (switch-to-buffer "*scratch*"))

(defun my/today ()
  "Open today's journal and agenda side by side."
  (interactive)
  (delete-other-windows)
  (org-journal-new-entry t)
  (split-window-right)
  (other-window 1)
  (my/show-hybrid-agenda))

(defun my/writing-mode ()
  "Toggle distraction-free writing: centered text, no chrome."
  (interactive)
  (if (bound-and-true-p olivetti-mode)
      (progn
        (olivetti-mode -1)
        (message "Writing mode off"))
    (olivetti-mode 1)
    (message "Writing mode on")))

(defun my/word-count-region (start end)
  "Count words, sentences, and paragraphs in region."
  (interactive "r")
  (let* ((text (buffer-substring-no-properties start end))
         (words (length (split-string text "\\W+" t)))
         (sentences (length (split-string text "[.!?]+" t)))
         (paragraphs (length (split-string text "\n\n+" t))))
    (message "%d words, %d sentences, %d paragraphs (avg %.1f words/sentence)"
             words sentences paragraphs
             (if (> sentences 0) (/ (float words) sentences) 0))))
