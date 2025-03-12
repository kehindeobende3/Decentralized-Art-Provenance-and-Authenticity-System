;; Artwork Registration Contract
;; Records details of art pieces and their creation

(define-data-var artwork-counter uint u0)

(define-map artworks
  { id: uint }
  {
    artist: principal,
    title: (string-ascii 64),
    creation-date: uint,
    medium: (string-ascii 32),
    dimensions: (string-ascii 32),
    description: (string-ascii 256),
    image-url: (string-ascii 128)
  }
)

(define-map artist-profiles
  { address: principal }
  {
    name: (string-ascii 64),
    biography: (string-ascii 256),
    verified: bool
  }
)

;; Register a new artwork
(define-public (register-artwork
                (title (string-ascii 64))
                (creation-date uint)
                (medium (string-ascii 32))
                (dimensions (string-ascii 32))
                (description (string-ascii 256))
                (image-url (string-ascii 128)))
  (let
    ((new-id (+ (var-get artwork-counter) u1)))

    ;; Update counter
    (var-set artwork-counter new-id)

    ;; Store artwork data
    (ok (map-set artworks
      { id: new-id }
      {
        artist: tx-sender,
        title: title,
        creation-date: creation-date,
        medium: medium,
        dimensions: dimensions,
        description: description,
        image-url: image-url
      }
    ))
  )
)

;; Register or update artist profile
(define-public (register-artist-profile
                (name (string-ascii 64))
                (biography (string-ascii 256)))
  ;; Store artist profile
  (ok (map-set artist-profiles
    { address: tx-sender }
    {
      name: name,
      biography: biography,
      verified: false
    }
  ))
)

;; Verify an artist (admin only)
(define-public (verify-artist (artist-address principal))
  ;; Only contract owner can verify artists
  (if (is-eq tx-sender (contract-owner))
    (ok (map-set artist-profiles
      { address: artist-address }
      (merge (default-to
               { name: "", biography: "", verified: false }
               (map-get? artist-profiles { address: artist-address }))
             { verified: true })
    ))
    (err u403)
  )
)

;; Get artwork details
(define-read-only (get-artwork (artwork-id uint))
  (map-get? artworks { id: artwork-id })
)

;; Get artist profile
(define-read-only (get-artist-profile (artist-address principal))
  (map-get? artist-profiles { address: artist-address })
)

;; Check if artwork exists
(define-read-only (artwork-exists (artwork-id uint))
  (is-some (map-get? artworks { id: artwork-id }))
)

;; Helper function to get contract owner
(define-read-only (contract-owner)
  (as-contract tx-sender)
)

