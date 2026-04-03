;; don't let TRAMP connections hang forever
(setq tramp-connection-timeout 10
      tramp-verbose 1)

;; bridge the clipboard to work everywhere
(setq select-enable-clipboard t)
(setq select-enable-primary t)

;; let terminal emulators grab clipboard from remote
(when (not (display-graphic-p))
  (setq xterm-set-window-title t))

;; terminal-specific adjustments
(unless (display-graphic-p)
  ;; terminal can't do pixel scrolling, so don't try
  (setq mouse-wheel-progressive-speed nil
        mouse-wheel-scroll-amount '(3 ((shift) . 1)))
  ;; fix terminal color rendering
  (setq xterm-color-count 256))

;; warn before opening files larger than 50MB
(setq large-file-warning-threshold (* 50 1024 1024))

;; xterm mouse support (critical for Blink/iPhone)
(xterm-mouse-mode 1)
;; mouse wheel in terminal
(when (not (display-graphic-p))
  (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
  (global-set-key (kbd "<mouse-5>") 'scroll-up-line))

;; show buffer name and hostname in frame title
;; useful when you have emacs running on multiple machines
(setq frame-title-format
      '((:eval (or buffer-file-name (buffer-name)))
        " — emacs@" (:eval (system-name))))

;; pin timezone so org timestamps are consistent across machines
(setenv "TZ" "America/Chicago")

;; url.el: don't store cookies, increase timeout
(setq url-cookie-untrusted-urls '(".*")  ; reject all cookies
      url-queue-timeout 30)              ; default is 5, too aggressive on slow links

;; TLS: verify certificates, warn on problems
(setq gnutls-verify-error t
      gnutls-min-prime-bits 3072
      network-security-level 'high)

;; no proxy — be explicit so Emacs doesn't guess from environment
(setq url-proxy-services nil)

;; TRAMP: use ssh by default, reasonable timeouts
(setq tramp-default-method "ssh"
      tramp-connection-timeout 10
      tramp-verbose 1)

;; async DNS — don't freeze Emacs waiting for hostname resolution
(setq url-gateway-method 'native)

