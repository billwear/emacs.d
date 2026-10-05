;;; 15-org-roam.el --- networked notes -*- lexical-binding: t -*-

(use-package org-roam
  :after org
  :custom
  (org-roam-directory (expand-file-name "roam" org-directory))
  (org-roam-completion-everywhere t)

  ;; show backlinks, reflinks, and unlinked references in the roam buffer
  (org-roam-mode-sections
   '(org-roam-backlinks-section
     org-roam-reflinks-section
     org-roam-unlinked-references-section))

  ;; better node display in minibuffer — show tags and directory
  (org-roam-node-display-template
   (concat "${title:60} " (propertize "${tags:30}" 'face 'org-tag)))

  ;; db update on save, not on every buffer switch
  (org-roam-db-update-on-save t)

  ;; capture templates
  (org-roam-capture-templates
   '(;; ── default: quick note ──────────────────
     ("d" "default" plain
      "%?"
      :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                         "#+title: ${title}\n#+created: %U\n#+filetags: \n\n")
      :unnarrowed t)

     ;; ── reference: article, book, talk ───────
     ("r" "reference" plain
      "* Source\n\nAuthor: %^{Author}\nURL: %^{URL}\nType: %^{Type|article|book|talk|paper|video}\n\n* Summary\n\n%?\n\n* Key ideas\n\n- \n\n* Quotes\n\n#+begin_quote\n\n#+end_quote\n\n* My take\n\n"
      :target (file+head "references/%<%Y%m%d>-${slug}.org"
                         "#+title: ${title}\n#+created: %U\n#+filetags: :reference:\n\n")
      :unnarrowed t)

     ;; ── person: contact / collaborator ───────
     ("P" "person" plain
      "* About\n\n%?\n\n* Contact\n\n- Company: %^{Company}\n- Title: %^{Title}\n- LinkedIn: \n- Email: \n- Location: \n\n* Notes\n\n* Conversations\n\n"
      :target (file+head "people/${slug}.org"
                         "#+title: ${title}\n#+created: %U\n#+filetags: :person:\n\n")
      :unnarrowed t)

     ;; ── concept: an idea worth developing ────
     ("c" "concept" plain
      "* What it is\n\n%?\n\n* Why it matters\n\n\n* How it connects\n\n\n* Open questions\n\n- \n"
      :target (file+head "concepts/${slug}.org"
                         "#+title: ${title}\n#+created: %U\n#+filetags: :concept:\n\n")
      :unnarrowed t)

     ;; ── project: consulting or creative ──────
     ("p" "project" plain
      "* Goal\n\n%?\n\n* Scope\n\n\n* Tasks\n\n** TODO \n\n* Log\n\n* Notes\n\n"
      :target (file+head "projects/${slug}.org"
                         "#+title: ${title}\n#+created: %U\n#+filetags: :project:\n\n")
      :unnarrowed t)

     ;; ── tuesday after lunch: book material ───
     ("b" "book note" plain
      "* Context\n\n%?\n\n* The idea\n\n\n* Which rule(s)\n\n\n* Maria angle\n\n\n* Raw material\n\n"
      :target (file+head "book/${slug}.org"
                         "#+title: ${title}\n#+created: %U\n#+filetags: :book:tuesday:\n\n")
      :unnarrowed t)

     ;; ── emacs: for the-way-of-emacs.com ──────
     ("e" "emacs note" plain
      "* What\n\n%?\n\n* Why you'd want this\n\n\n* How\n\n#+begin_src emacs-lisp\n\n#+end_src\n\n* Gotchas\n\n"
      :target (file+head "emacs/${slug}.org"
                         "#+title: ${title}\n#+created: %U\n#+filetags: :emacs:\n\n")
      :unnarrowed t)))

  ;; dailies — quick scratchpad, separate from journal
  (org-roam-dailies-directory "dailies/")
  (org-roam-dailies-capture-templates
   '(("d" "default" entry
      "* %<%H:%M> %?"
      :target (file+head "%<%Y-%m-%d>.org"
                         "#+title: %<%Y-%m-%d %A>\n\n"))))

  :bind (("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n l" . org-roam-buffer-toggle)
         ("C-c n c" . org-roam-capture)
         ("C-c n g" . org-roam-graph)
         ("C-c n t" . org-roam-tag-add)
         ("C-c n T" . org-roam-tag-remove)
         ("C-c n a" . org-roam-alias-add)
         ("C-c n d" . org-roam-dailies-goto-today)
         ("C-c n D" . org-roam-dailies-goto-date)
         ("C-c n j" . org-roam-dailies-capture-today))

  :config
  ;; ensure all subdirectories exist
  (dolist (subdir '("references" "people" "concepts" "projects"
                    "book" "emacs" "dailies"))
    (let ((dir (expand-file-name subdir org-roam-directory)))
      (unless (file-directory-p dir)
        (make-directory dir t))))

  (org-roam-db-autosync-mode))

;; ── org-roam-ui: visual graph in the browser ────
;; open with M-x org-roam-ui-open
(use-package org-roam-ui
  :after org-roam
  :custom
  (org-roam-ui-sync-theme t)       ; match emacs theme
  (org-roam-ui-follow t)           ; graph follows current node
  (org-roam-ui-update-on-save t)   ; refresh on save
  (org-roam-ui-open-on-start nil)) ; don't auto-open browser

;; ── convenience functions ───────────────────────

(defun my/roam-find-person ()
  "Find a person node."
  (interactive)
  (org-roam-node-find nil nil
                      (lambda (node)
                        (member "person" (org-roam-node-tags node)))))

(defun my/roam-find-concept ()
  "Find a concept node."
  (interactive)
  (org-roam-node-find nil nil
                      (lambda (node)
                        (member "concept" (org-roam-node-tags node)))))

(defun my/roam-find-book ()
  "Find a Tuesday After Lunch book node."
  (interactive)
  (org-roam-node-find nil nil
                      (lambda (node)
                        (member "book" (org-roam-node-tags node)))))

(defun my/roam-find-emacs ()
  "Find an emacs node."
  (interactive)
  (org-roam-node-find nil nil
                      (lambda (node)
                        (member "emacs" (org-roam-node-tags node)))))

(defun my/roam-find-reference ()
  "Find a reference node."
  (interactive)
  (org-roam-node-find nil nil
                      (lambda (node)
                        (member "reference" (org-roam-node-tags node)))))

(defun my/roam-insert-timestamp ()
  "Insert a timestamp at point in a roam node."
  (interactive)
  (insert (format-time-string "\n[%Y-%m-%d %H:%M] ")))
