;; start maximized, no chrome
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t
      initial-scratch-message "scratch buffer")

;; pixel-perfect resizing
(setq frame-resize-pixelwise t
      window-resize-pixelwise t
      x-stretch-cursor t)

;; comfortable font size
(set-face-attribute 'default nil :height 200)

;; ── aubergine theme ──────────────────────────────
;; dark ubuntu-inspired palette: deep aubergine background,
;; warm orange accent, rainbow heading colours
(load-theme 'modus-vivendi t)   ; dark base with good contrast

;; override background to ubuntu aubergine
(set-face-attribute 'default nil
                    :background "#2D0022"
                    :foreground "#F0E6EC")

;; modeline: orange on dark aubergine
(set-face-attribute 'mode-line nil
                    :background "#5E2750"
                    :foreground "#FB8B24"
                    :box '(:line-width 2 :color "#5E2750"))
(set-face-attribute 'mode-line-inactive nil
                    :background "#3C0030"
                    :foreground "#A88B9A"
                    :box '(:line-width 2 :color "#3C0030"))

;; fringe, line numbers, region — keep the aubergine family
(set-face-attribute 'fringe nil :background "#2D0022")
(set-face-attribute 'line-number nil
                    :background "#2D0022" :foreground "#6B4560")
(set-face-attribute 'line-number-current-line nil
                    :background "#3C0030" :foreground "#FB8B24")
(set-face-attribute 'region nil :background "#5E2750")
(with-eval-after-load 'hl-line
  (set-face-attribute 'hl-line nil :background "#3C0030"))

;; minibuffer prompt: ubuntu orange
(set-face-attribute 'minibuffer-prompt nil :foreground "#FB8B24" :weight 'bold)

;; isearch / lazy highlight
(set-face-attribute 'isearch nil
                    :background "#FB8B24" :foreground "#2D0022" :weight 'bold)
(set-face-attribute 'lazy-highlight nil
                    :background "#5E2750" :foreground "#F0E6EC")

;; comments: muted lavender
(with-eval-after-load 'font-lock
  (set-face-attribute 'font-lock-comment-face nil :foreground "#A88B9A" :slant 'italic)
  (set-face-attribute 'font-lock-comment-delimiter-face nil :foreground "#A88B9A")
  (set-face-attribute 'font-lock-string-face nil :foreground "#77DD77")
  (set-face-attribute 'font-lock-keyword-face nil :foreground "#AEC6FF")
  (set-face-attribute 'font-lock-function-name-face nil :foreground "#FB8B24")
  (set-face-attribute 'font-lock-variable-name-face nil :foreground "#FFD580")
  (set-face-attribute 'font-lock-type-face nil :foreground "#D5BAFF")
  (set-face-attribute 'font-lock-constant-face nil :foreground "#FF6B6B")
  (set-face-attribute 'font-lock-builtin-face nil :foreground "#77E4D4"))

;; strip chrome
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; silence
(setq ring-bell-function #'ignore
      visible-bell nil)

;; no "really quit?" prompts
(setq confirm-kill-emacs nil
      confirm-kill-processes nil)

;; autosave silently
(setq auto-save-no-message t)

;; window navigation: C-<arrow> moves between windows; creates if none exists
(windmove-default-keybindings 'control)
(setq windmove-create-window t)

;; selected text behaves like every other editor
(delete-selection-mode 1)

;; cursor
(blink-cursor-mode 1)

;; wrap long lines visually everywhere
(global-visual-line-mode 1)

;; useful modeline info
(column-number-mode t)
(line-number-mode t)

;; highlight the current line
(global-hl-line-mode t)

;; show matching parens immediately
(setq show-paren-delay 0)
(show-paren-mode 1)

;; distinguish buffers with the same filename by their directory
(setq uniquify-buffer-name-style 'forward)

;; never pop up GUI dialog boxes — use the minibuffer
(setq use-dialog-box nil
      use-file-dialog nil)

;; tabs: spaces, 4 wide, everywhere
(setq-default tab-width 4
              indent-tabs-mode nil)

;; auto-close parens, brackets, quotes
(electric-pair-mode 1)

;; visible window dividers in the aubergine palette
(setq window-divider-default-right-width 2
      window-divider-default-bottom-width 2)
(window-divider-mode 1)

;; bar cursor — easier to track on dark backgrounds
(setq-default cursor-type 'bar)

;; tooltips in the echo area, not floating windows
(tooltip-mode -1)

;; show trailing whitespace in programming and text modes
(add-hook 'prog-mode-hook (lambda () (setq show-trailing-whitespace t)))
(add-hook 'text-mode-hook (lambda () (setq show-trailing-whitespace t)))

;; y/n instead of yes/no
(setq use-short-answers t)

;; scroll smoothly
(setq scroll-conservatively 101
      scroll-margin 3
      scroll-preserve-screen-position t)

